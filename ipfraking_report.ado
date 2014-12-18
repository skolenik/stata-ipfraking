*! 1.2.1 ipfraking_report: weight reports as a follow-up to ipfraking -- Stas Kolenikov
program define ipfraking_report, rclass

	version 12
	
	syntax using/ , raked_weight(varname numeric min=1 max=1) [by(varlist numeric) matrices(string) xls replace]
	
	* (i) extract everything we need from chars
	local oldweight : char `raked_weight'[source]
	local k=1 
	while "`: char `raked_weight'[over`k']'" != "" {
		local over`k'    : char `raked_weight'[over`k']
		if "`over`k''" == "" {
			di "{err}No meta data were saved with `raked_weight'. Re-run raking with -meta- option."
			exit 2000
		}
		local totalof`k' : char `raked_weight'[totalof`k']
		local mat`k'     : char `raked_weight'[mat`k']
		cap confirm matrix `mat`k''
		if _rc == 111 {
			di "{err}Control total matrix `mat`k'' not found"
			local lost`k' 1
		}
		else local lost`k' 0
		
		local allover `allover' `over`k''
		
		local ++k
	}
	* total number of margins
	local p = `k' - 1
	
	* (ii) check integrity
	tempname hash1
	mata : st_view(w=.,.,"`raked_weight'")
	mata : st_numscalar("`hash1'",hash1(w,.,2) )
	
	if "`: char `raked_weight'[hash1]'" == "" {
		di "{err}WARNING: check sums was not created for `raked_weight'; re-run ipfraking with -meta- option."
		local changed unknown
	}
	else if scalar(`hash1') != `: char `raked_weight'[hash1]' {
		di "{err}WARNING: check sums are different from when the weights were created to the current version;"
		di "{err}the data set may have changed since the weight variable `raked_weight' was created."
		local changed changed
	}
	
	tempvar touse
	qui gen byte `touse' = !mi( `raked_weight' )
	
	* (iii) set up the post
	tempname postf
	postfile `postf' ///
		str64( Weight_Variable) ///
		str64( C_Total_Margin_Variable_Name) ///
		str240(C_Total_Margin_Variable_Label) ///
		str64( Variable_Class ) ///
		str64( C_Total_Arg_Variable_Name) ///
		str240(C_Total_Arg_Variable_Label) ///
		///
		long( C_Total_Margin_Category_Number) ///
		str240(C_Total_Margin_Category_Label) ///
		///
		double(Category_Total_Target) ///
		double(Category_Total_Prop) ///
		///
		long(  Unweighted_Count) ///
		double(Unweighted_Prop Unweighted_Prop_Discrep) ///
		///
		double(Category_Total_SRCWGT) ///
		double(Category_Prop_SRCWGT) ///
		double(Category_Total_Discrep_SRCWGT) ///
		///
		double(Category_Prop_Discrep_SRCWGT) ///
		///
		double(Category_RelDiff_SRCWGT) ///
		double(Overall_Total_SRCWGT) ///
		///
		double(Min_SRCWGT) ///
		double(P25_SRCWGT) ///
		double(P50_SRCWGT) ///
		double(P75_SRCWGT) ///
		double(Max_SRCWGT) ///
		///
		double(Mean_SRCWGT) ///
		double(SD_SRCWGT) ///
		double(DEFF_SRCWGT) ///
		///
		double(Category_Total_RKDWGT) ///
		double(Category_Prop_RKDWGT) ///
		double(Category_Total_Discrep_RKDWGT) ///
		double(Category_Prop_Discrep_RKDWGT) ///
		double(Category_RelDiff_RKDWGT) ///
		double(Overall_Total_RKDWGT) ///
		double(Min_RKDWGT) ///
		double(P25_RKDWGT) ///
		double(P50_RKDWGT) ///
		double(P75_RKDWGT) ///
		double(Max_RKDWGT) ///
		double(Mean_RKDWGT) ///
		double(SD_RKDWGT) ///
		double(DEFF_RKDWGT) ///
		str240(Comment) ///
		using `using', `replace'
	
	* (iv) cycle over the margins
	tempname sumSRCWGT sumRKDWGT overall_target cat_target
	forvalues k=1/`p' {
		* di "{txt}{hline}"
		di "{txt}Margin variable {res}`over`k''{txt} (total variable: {res}`totalof`k''{txt}; " _c
		local comment_var
		
		* (iv.a) are there any missing values lurking around
		qui count if mi(`over`k'') & !mi(`raked_weight')
		if r(N) local comment_var `"`comment_var' `=r(N)' missing values of `over`k''. "'
		qui count if mi(`totalof`k'') & !mi(`raked_weight')
		if r(N) local comment_var `"`comment_var' `=r(N)' missing values of `totalof`k''. "'
		
		* (iv.b) sums of weights
		qui sum `oldweight' [aw=`totalof`k''] if `touse' & !mi( `over`k'' ) & !mi( `totalof`k'' )
		scalar `sumSRCWGT' = r(sum)
		qui sum `raked_weight' [aw=`totalof`k''] if `touse' & !mi( `over`k'' ) & !mi( `totalof`k'' )
		scalar `sumRKDWGT' = r(sum)
		
		if !`lost`k'' {
			mata : st_numscalar( "`overall_target'", sum( st_matrix( "`mat`k''" ) ) )
		}

		* (iv.c) cycle over categories
		qui levelsof `over`k'' if !mi(`raked_weight') 
		di "{txt}categories: {res}`r(levels)'{txt})."		

		foreach c of numlist `r(levels)' {
			local comment_cat
			
			qui count if `over`k''==`c' & mi(`totalof`k'')
			if r(N) local comment_cat `"`comment_cat' `=r(N)' missing values of `totalof`k'' encountered with `over`k''==`c'."'
		
			* fixed text: margin name, etc.
			local topost ("`raked_weight'") ("`over`k''") ("`: var label `over`k'''") ("Raking margin") 
			local topost `topost' ("`totalof`k''") ("`: var label `totalof`k'''") 
			* category text
			local topost `topost' (`c') ("`: label (`over`k'') `c' '") 
			
			* category target
			if !`lost`k'' {
				local where = colnumb("`mat`k''","`c'")
				scalar `cat_target'= `mat`k''[1,`where']
			}
			else scalar `cat_target'= .
			local topost `topost' (`=scalar(`cat_target')') (`=scalar(`cat_target')/scalar(`overall_target')')
			
			* unweighted count and prop of category
			qui sum `c'.`over`k'' if `touse'
			local topost `topost' (`=r(sum)') (`=r(mean)') (`=r(mean) - scalar(`cat_target')/scalar(`overall_target')')
			
			* weighted with source weights
			qui sum `oldweight' [aw=`totalof`k''] if `touse' & `over`k'' == `c'
			local topost `topost' (`=r(sum)') (`=r(sum)/scalar(`sumSRCWGT')') (`=r(sum)-scalar(`cat_target')')
			local topost `topost' (`=r(sum)/scalar(`sumSRCWGT') - scalar(`cat_target')/scalar(`overall_target')')
			local topost `topost' (`=r(sum)/scalar(`cat_target')-1') (`=scalar(`sumSRCWGT')')
			qui sum `oldweight' if `touse' & `over`k'' == `c', det
			local topost `topost' (`=r(min)') (`=r(p25)') (`=r(p50)') (`=r(p75)') (`=r(max)')
			local topost `topost' (`=r(mean)') (`=r(sd)') (`=1+( r(sd)/ r(mean) )^2')
			
			* weighted with source weights
			qui sum `raked_weight' [aw=`totalof`k''] if `touse' & `over`k'' == `c'
			local topost `topost' (`=r(sum)') (`=r(sum)/scalar(`sumRKDWGT')') (`=r(sum)-scalar(`cat_target')')
			local topost `topost' (`=r(sum)/scalar(`sumRKDWGT') - scalar(`cat_target')/scalar(`overall_target')')
			local topost `topost' (`=r(sum)/scalar(`cat_target')-1') (`=scalar(`sumRKDWGT')')
			qui sum `raked_weight' if `touse' & `over`k'' == `c', det
			local topost `topost' (`=r(min)') (`=r(p25)') (`=r(p50)') (`=r(p75)') (`=r(max)')
			local topost `topost' (`=r(mean)') (`=r(sd)') (`=1+( r(sd)/ r(mean) )^2')
			
			
			post `postf' `topost' ("`comment_var' `comment_cat'")
		}
		
	}
		
	* (v) cycle over other known target variables
	if "`matrices'" != "" {
		forvalues k=1/`: word count `matrices'' {
			local thismat : word `k' of `matrices'

			* is this really a known matrix?
			cap confirm matrix `thismat'
			if _rc {
				di "{err}Matrix `thismat' could not be found." 
				continue
			}
		
			* the variable
			local over : rownames `thismat'
			local overall `overall' `over'
			local totalof : coleq `thismat'
			local totalof : word 1 of `totalof'
			cap confirm numeric variable `over'
			if _rc {
				di "{err}Matrix `thismat' refers to a variable `over' which was not found."
				continue
			}
		
			* has it been processed before
			if strpos( "`allover'", "`over'" ) {
				di "{err}Warning: {txt}matrix {res}`thismat'{txt} refers to a variable {res}`over'{txt} that was already processed."
				continue
			}
			
			di "{txt}Known targets variable {res}`over'{txt} (total variable: {res}`totalof'{txt}; " _c

			local comment_var
			
			* (v.a) are there any missing values lurking around
			qui count if mi(`over') & !mi(`raked_weight')
			if r(N) local comment_var `"`comment_var' `=r(N)' missing values of `over'. "'
			qui count if mi(`totalof') & !mi(`raked_weight')
			if r(N) local comment_var `"`comment_var' `=r(N)' missing values of `totalof'. "'
			
			* (v.b) sums of weights
			qui sum `oldweight' [aw=`totalof'] if `touse' & !mi( `over' ) & !mi( `totalof' )
			scalar `sumSRCWGT' = r(sum)
			qui sum `raked_weight' [aw=`totalof'] if `touse' & !mi( `over' ) & !mi( `totalof' )
			scalar `sumRKDWGT' = r(sum)
			
			mata : st_numscalar( "`overall_target'", sum( st_matrix( "`thismat'" ) ) )

			* (v.c) cycle over categories
			qui levelsof `over' if !mi(`raked_weight') 
			di "{txt}categories: {res}`r(levels)'{txt})."		

			foreach c of numlist `r(levels)' {
				local comment_cat
				
				qui count if `over'==`c' & mi(`totalof')
				if r(N) local comment_cat `"`comment_cat' `=r(N)' missing values of `totalof' encountered with `over'==`c'."'
			
				* fixed text: margin name, etc.
				local topost ("`raked_weight'") ("`over'") ("`: var label `over''") ("Other known target") 
				local topost `topost' ("`totalof'") ("`: var label `totalof''") 
				* category text
				local topost `topost' (`c') ("`: label (`over') `c' '") 
				
				* category target
				local where = colnumb("`thismat'","`c'")
				scalar `cat_target'= `thismat'[1,`where']
				local topost `topost' (`=scalar(`cat_target')') (`=scalar(`cat_target')/scalar(`overall_target')')
				
				* unweighted count and prop of category
				qui sum `c'.`over' if `touse'
				local topost `topost' (`=r(sum)') (`=r(mean)') (`=r(mean) - scalar(`cat_target')/scalar(`overall_target')')
				
				* weighted with source weights
				qui sum `oldweight' [aw=`totalof'] if `touse' & `over' == `c'
				local topost `topost' (`=r(sum)') (`=r(sum)/scalar(`sumSRCWGT')') (`=r(sum)-scalar(`cat_target')')
				local topost `topost' (`=r(sum)/scalar(`sumSRCWGT') - scalar(`cat_target')/scalar(`overall_target')')
				local topost `topost' (`=r(sum)/scalar(`cat_target')-1') (`=scalar(`sumSRCWGT')')
				qui sum `oldweight' if `touse' & `over' == `c', det
				local topost `topost' (`=r(min)') (`=r(p25)') (`=r(p50)') (`=r(p75)') (`=r(max)')
				local topost `topost' (`=r(mean)') (`=r(sd)') (`=1+( r(sd)/ r(mean) )^2')
				
				* weighted with source weights
				qui sum `raked_weight' [aw=`totalof'] if `touse' & `over' == `c'
				local topost `topost' (`=r(sum)') (`=r(sum)/scalar(`sumRKDWGT')') (`=r(sum)-scalar(`cat_target')')
				local topost `topost' (`=r(sum)/scalar(`sumRKDWGT') - scalar(`cat_target')/scalar(`overall_target')')
				local topost `topost' (`=r(sum)/scalar(`cat_target')-1') (`=scalar(`sumRKDWGT')')
				qui sum `raked_weight' if `touse' & `over' == `c', det
				local topost `topost' (`=r(min)') (`=r(p25)') (`=r(p50)') (`=r(p75)') (`=r(max)')
				local topost `topost' (`=r(mean)') (`=r(sd)') (`=1+( r(sd)/ r(mean) )^2')
				
				
				post `postf' `topost' ("`comment_var' `comment_cat'")
			}
			
		}
	}
		
	* (vi) cycle over by-variables
	tempvar one
	gen byte `one' = 1
	
	forvalues k=1/`: word count `by'' {
		local byvar : word `k' of `by'
		if strpos( "`allover'", "`byvar'" ) {
			di "{err}Warning: variable {res}`byvar'{txt} was already processed."
			continue
		}
		
		
		di "{txt}Auxiliary variable {res}`byvar'{txt} " _c
	
		local comment_var 
		
		* (v.a) are there any missing values lurking around
		qui count if mi(`byvar') & !mi(`raked_weight')
		if r(N) local comment_var `"`comment_var' `=r(N)' missing values of `byvar'. "'
		qui count if mi(`one') & !mi(`raked_weight')
		if r(N) local comment_var `"`comment_var' `=r(N)' missing values of `one'. "'
		
		* (v.b) sums of weights
		qui sum `oldweight' [aw=`one'] if `touse' & !mi( `byvar' ) & !mi( `one' )
		scalar `sumSRCWGT' = r(sum)
		qui sum `raked_weight' [aw=`one'] if `touse' & !mi( `byvar' ) & !mi( `one' )
		scalar `sumRKDWGT' = r(sum)

		scalar `overall_target' = .

		* (v.c) cycle over categories
		qui levelsof `byvar' if !mi(`raked_weight') 
		di "{txt}(categories: {res}`r(levels)'{txt})."
		foreach c of numlist `r(levels)' {
			local comment_cat
			
			qui count if `byvar'==`c' & mi(`one')
			if r(N) local comment_cat `"`comment_cat' `=r(N)' missing values of `one' encountered with `byvar'==`c'."'
		
			* fixed text: margin name, etc.
			local topost ("`raked_weight'") ("`byvar'") ("`: var label `byvar''") ("Auxiliary variable")
			local topost `topost' ("Identically one") ("Identically one") 
			* category text
			local topost `topost' (`c') ("`: label (`byvar') `c' '") 
			
			* category target
			scalar `cat_target'= .
			local topost `topost' (`=scalar(`cat_target')') (`=scalar(`cat_target')/scalar(`overall_target')')
			
			* unweighted count and prop of category
			qui sum `c'.`byvar' if `touse'
			local topost `topost' (`=r(sum)') (`=r(mean)') (.)
			
			* weighted with source weights
			qui sum `oldweight' [aw=`one'] if `touse' & `byvar' == `c'
			local topost `topost' (`=r(sum)') (`=r(sum)/scalar(`sumSRCWGT')') (`=r(sum)-scalar(`cat_target')')
			local topost `topost' (`=r(sum)/scalar(`sumSRCWGT') - scalar(`cat_target')/scalar(`overall_target')')
			local topost `topost' (`=r(sum)/scalar(`cat_target')-1') (`=scalar(`sumSRCWGT')')
			qui sum `oldweight' if `touse' & `byvar' == `c', det
			local topost `topost' (`=r(min)') (`=r(p25)') (`=r(p50)') (`=r(p75)') (`=r(max)')
			local topost `topost' (`=r(mean)') (`=r(sd)') (`=1+( r(sd)/ r(mean) )^2')
			
			* weighted with source weights
			qui sum `raked_weight' [aw=`one'] if `touse' & `byvar' == `c'
			local topost `topost' (`=r(sum)') (`=r(sum)/scalar(`sumRKDWGT')') (`=r(sum)-scalar(`cat_target')')
			local topost `topost' (`=r(sum)/scalar(`sumRKDWGT') - scalar(`cat_target')/scalar(`overall_target')')
			local topost `topost' (`=r(sum)/scalar(`cat_target')-1') (`=scalar(`sumRKDWGT')')
			qui sum `raked_weight' if `touse' & `byvar' == `c', det
			local topost `topost' (`=r(min)') (`=r(p25)') (`=r(p50)') (`=r(p75)') (`=r(max)')
			local topost `topost' (`=r(mean)') (`=r(sd)') (`=1+( r(sd)/ r(mean) )^2')
			
			
			post `postf' `topost' ("`comment_var' `comment_cat'")
		}
		
	}
	
	* (vi) done with the posting
	postclose `postf'
	
	preserve
	
	di
	
	use `using', clear
	label data `"Raking report for `raked_weight' ($S_DATE $S_TIME)"'
	
	* (vii) relabel the variables
	foreach x of varlist * {
		local thislab `x'
		local thislab : subinstr local thislab "_" " ", all
		local thislab : subinstr local thislab "C Total" "Control Total", all
		local thislab : subinstr local thislab "Arg" "Multiplier", all
		local thislab : subinstr local thislab "Prop" "Proportion ", all
		if length("`x'") < 12 local thislab : subinstr local thislab "SRCWGT" "of Source Weight", all
		else                  local thislab : subinstr local thislab "SRCWGT" ", with Source Weight", all
		if length("`x'") < 12 local thislab : subinstr local thislab "RKDWGT" "of Raked Weight", all
		else                  local thislab : subinstr local thislab "RKDWGT" ", with Raked Weight", all
		local thislab : subinstr local thislab "RelDiff" "Relative Difference", all
		local thislab : subinstr local thislab "SD" "Std. dev.", all
		local thislab : subinstr local thislab " , " ", ", all
		
		lab var `x' "`thislab'"
	}
	if "`xls'" != "" {
		local xlsfname : subinstr local using ".dta" ".xls", all
		export excel `"`xlsfname'"', `replace' firstrow(varlabels)
	}
	lab data "Weighting report on `raked_weight'"
	
	qui compress
	save, replace
	
	restore
	
end // of ipfraking_report

exit

/*
History
1.1.34.23	aligned with same version of ipfraking
			picks up the source weight and the final weight from char[`raked_weight']
			allows additional diagnostics with -by-
1.2			Don't know what version of ipfraking it is, but...
				. added variable describing the class of the analysis variable
				. added variable: unweighted % discrepancy
1.2.1		Checks hash/meta

*/
