*! conversion of the matrices of totals from ipfraking to svycal formats
program define totalmatrices
	version 10

	syntax namelist, [ svycal IPFRaking stub( namelist min=1 max=1 ) replace ]

	if "`svycal'" == "svycal" & "`ipfraking'" == "ipfraking" {
		di "{err}Only one of svycal or ipfraking can be specified at a time"
		exit (198)
	}
	
	if "`ipfraking'`svycal'" != "" {
		* an attempt will be made to convert the matrices
		if ("`replace'"=="replace") + ("`stub'"!="") != 1 & "`ipfraking'" == "ipfraking" {
			di "{err}One and only one of replace or stub() must be specified along with ipfraking"
			exit (198)
		}
	}
	
	tempname a
	
	* look at the matrices
	foreach mat of local namelist {
		local cnames : colnames `mat'
		local coleq  : coleq `mat'
		local rnames : rownames `mat'
		
		* ipfraking format: columns are equation-like
		cap confirm name `coleq'
		if _rc local ipfraking 0
		else {
			matrix `a' = J(1,colsof(`mat'),0)
			if "`coleq'" == "`: coleq `a''" local ipfraking 0
			else {
				local ipfraking 1
				cap confirm numeric variable `coleq'
				if _rc {
					di "{txt}Matrix {res}`mat'{txt} has column equation name set to {res}`coleq'{txt}."
					di "{txt}  I was suspecting the {inp}ipfraking{txt} format, but variable {res}`coleq'{txt} was not found."
				}
			}
		}
		
		* ipfraking: rowname is a variable
		cap confirm name `rnames'
		if _rc local ipfraking = `ipfraking' * 0
		else local ipfraking = `ipfraking' * 1
		
		if `ipfraking' {
			cap confirm numeric variable `rnames'
			if _rc {
				di "{txt}Matrix {res}`mat'{txt} has row name set to {res}`rnames'{txt}."
				di "{txt}  I was suspecting the {inp}ipfraking{txt} format, but variable {res}`rnames'{txt} was not found."
			}
			else {
				* check categories
				foreach c of local cnames {
					cap confirm number `c' 
					if _rc {
						local ipfraking 0
						continue, break
					}
					qui count if `rnames' == `c'
					if r(N) == 0 {
						di "{txt}Matrix {res}`mat' has a column labeled {res}`c'."
						di "{txt}  I was suspecting the {inp}ipfraking{txt} format, but variable {res}`rnames'{txt} does not take this value."
					}
				}
			}
		}
		
		if `ipfraking' {
			di "{txt}It appears that the matrix {res}`mat'{txt} is of {inp}ipfraking{txt} format."
			local type_`mat' ipfraking
			continue
		}
		
		* coleq and rnames are set to none for svycal
		if "`coleq'" == "`: coleq `a''" local svycal 1
		* rowname is irrelevant
		else continue
		
		* column names are factor combinations
		foreach c of local cnames {
			* try regex
			local svycal = `svycal' * regexm("`c'","[ic]*[1-9]*\.")
		}
		
		if `svycal' {
			di "{txt}It appears that the matrix {res}`mat'{txt} is of the {inp}svycal{txt} format."
			local type_`mat' svycal
			cap fvrevar `cnames', list
			if _rc {
				di "{txt}I was suspecting the {inp}svycal{txt} format, but the column names of it do not seem to be"
				di "{txt}  factor variables in the current data set."
			}			
		}
		
		if "`type_`mat''" == "" di "{txt}It appears that the matrix {res}`mat'{txt} is useless."
		
		
	} // end of cycle over matrices to determine their type

	if "`ipfraking'" == "ipfraking" {
		* attempt to convert to ipfraking format
		foreach mat of local namelist {
			if "`type_`mat''" == "ipfraking" {
				if "`replace'" == "replace" {
					* do nothing 
					di "{txt}Note: matrix {res}`mat'{txt} is already of the {inp}ipfraking{txt} format." 
				}
				else {
					matrix `stub'`mat' = `mat'
					di "{txt}Matrix {res}`stub'`mat'{txt} is copied from {res}`mat'{txt} which is of the {inp}ipfraking{txt} format."
				}
			}
			if "`type_`mat''" == "svycal" {
				* convert the matrix, to the extent possible
				local cnames : colnames `mat'
				fvrevar `cnames', list
				local thevars `r(varlist)'
				foreach x of varlist `thevars' {
					cap confirm matrix `stub'`mat'_`x'
					if _rc == 0 {
						di "{err}Warning:{txt} matrix {res}`stub'`mat'_`x'{txt} already exists."
					}
				}
				
				foreach c of local cnames {
					* parse the simple one, forfeit the interactions
					if strpos("`c'","#") {
						di "{err}Warning:{txt} I won't attempt to handle the interaction {res}`c'{txt}."
						continue
					}
					
				}
			}
		}
	}
	
	if "`svycal'" == "svycal" {
	
		if "`stub'" == "" {
			di "stub() must be specified with svycal"
			exit (198)
		}
	
		cap confirm matrix `stub'
		if _rc == 0 & "`replace'" != "replace" {
			di "{txt}Matrix {res}`stub'{txt} already exists; specyify {inp}replace{txt} to replace it."
			exit
		}
		* cap in case the matrix does not exist, which should not bother anybody
		cap mat drop `stub'
	
		* attempt to convert the ipfraking matrices to the svycal format
		* place it to the matrix `stub'
		
		foreach mat of local namelist {
			if "`type_`mat''" == "ipfraking" {
				* append the matrix
				matrix `stub' = nullmat( `stub' ), `mat'
				local totcnames   : colnames `mat'
				local totrname    : rownames `mat'
				local totceqnames : coleq    `mat'
				
				* convert the names into factor variable notation
				forvalues k=1/`=colsof(`mat')' {
					if trim("`: word `k' of `totceqnames''") == "_one" local stubcname `stubcname' `: word `k' of `totcnames''.`totrname'
					else local stubcname `stubcname' `: word `k' of `totcnames''.`totrname'#c.`: word `k' of `totceqnames''
				}
				if "`: word 1 of `totceqnames''" == "_one" local calibvars `calibvars' ibn.`totrname'
				else local calibvars `calibvars' ibn.`totrname'#c.`: word 1 of `totceqnames''

				// di "{txt}Current stubcname: {res}`stubcname'"
			}
		}
		if `= colsof(`stub')' > 0 {
			matrix coleq    `stub' = "_"
			matrix rownames `stub' = "_"
			matrix colnames `stub' = `stubcname'
		}
		
		qui svyset
		
		// matrix list `stub'
		
		di "{txt}You can now {stata matrix list `stub'} to check and then call {inp}svycal{txt} as:"
		di "   {inp}svycal [regress|rake] `stubcname' [pw=`r(wvar)'], generate(...) totals(`stub') nocons"
		di "{txt}I suspect the following would be simpler and could work, too:"
		di "   {inp}svycal [regress|rake] `calibvars' [pw=`r(wvar)'], generate(...) totals(`stub') nocons"
	}
	
end // of totalmatrices
