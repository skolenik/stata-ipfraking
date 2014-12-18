*! v.0.8 convert matrices to do-files. Author: Stas Kolenikov
program define mat2do
	version 9
	syntax name(name=thematrix) using/ , [replace append type list]
	
	confirm matrix `thematrix'
	
	local rows = rowsof( `thematrix' )
	local cols = colsof( `thematrix' )
	
	tempname towr
	
	file open `towr' using `"`using'"', write text `replace' `append'
	file write `towr' "* Produced automatically by mat2do on `=c(current_date)' at `=c(current_time)'" _n(2)
	
	if `rows' * `cols' < 100 {
		file write `towr' "matrix `thematrix' = ( ///" _n
		forvalues r=1/`rows' {
			forvalues c=1/`cols' {
				file write `towr' _col(6) %22.0g (`thematrix'[`r',`c'])
				if `c' < `cols'      file write `towr' ", ///" _n
				else if `r' < `rows' file write `towr' "\ ///" _n
			}
		}
		
		file write `towr' ")" _n(2)
	}
	else {
		file write `towr' "matrix `thematrix' = J(`rows',`cols',.) " _n(2)
	
		forvalues r=1/`rows' {
			forvalues c=1/`cols' {
				file write `towr' "matrix `thematrix'[`r',`c'] = " %22.0g (`thematrix'[`r',`c']) _n
			}
		}
	
	}

	foreach attr in rownames colnames {
		local this : `attr' `thematrix'
		if "`this'" != "" file write `towr' `"matrix `attr' `thematrix' = `this'"' _n
	}
	foreach attr in roweq coleq {
		local this : `attr' `thematrix', quoted
		if `"`this'"' != `""' & `"`this'"' != `"_"' file write `towr' `"matrix `attr' `thematrix' = `this'"' _n
	}
	
	if "`list'" != "" file write `towr' _n "matrix list `thematrix'" _n
	
	file close `towr'

	if "`type'" != "" {
		matrix list `thematrix'
		di _n `"{txt} The listing of {res}`using'{txt} follows:"' _n "{hline}" _n(2)
		type `"`using'"'
		di _n "{txt}{hline}" _n
	}
	
end // of mat2do
