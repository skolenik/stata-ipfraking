*! whatsdeff : compute 1+CV^2 approximation to the unequal weighting design effect 
*! v.0.7 Stas Kolenikov skolenik at gmail.com
program define whatsdeff, rclass
	version 10
	
	syntax varlist (numeric min=1 max=1) [if] [in] , [by(varlist numeric min=1 max=1)]
	
	marksample touse
	
	local wgt `varlist'
	tempvar wgt2 
	qui gen `wgt2' = `wgt'*`wgt' if `touse'
	
	* header
	di _n "{txt}    Group" _col(15) "{c |}   Min" _col(25) "{c |}   Mean" _col(35) "{c |}   Max"   _c 
	di _col(45) "{c |}    CV" _col(55) "{c |}   DEFF" _col(65) "{c |}   N" _col(73) "{c |}  N eff"
	di "{txt}{dup 14:{c -}}{c +}{dup 9:{c -}}{c +}{dup 9:{c -}}{c +}{dup 9:{c -}}{c +}{dup 9:{c -}}{c +}{dup 9:{c -}}{c +}{dup 7:{c -}}{c +}{dup 8:{c -}}"
	
	if "`by'" != "" {
		qui levelsof `by' if `touse', local( allbys )
		di "{res}`by'" _c
		if length("`by'") < 15 di _col(15)"{txt}{c |}" _c
		if length("`by'") < 25 di _col(25)"{txt}{c |}" _c
		di _col(35) "{c |}" _col(45) "{c |}" _col(55) "{c |}" _col(65) "{c |}" _col(73) "{c |}"
		foreach k of numlist `allbys' {
			PrintDEFF `wgt' `wgt2' if `touse' & `by'==`k', caption("`: lab (`by') `k''")
			return add
		}
		di "{txt}{dup 14:{c -}}{c +}{dup 9:{c -}}{c +}{dup 9:{c -}}{c +}{dup 9:{c -}}{c +}{dup 9:{c -}}{c +}{dup 9:{c -}}{c +}{dup 7:{c -}}{c +}{dup 8:{c -}}"
	}
	
	PrintDEFF `wgt' `wgt2' if `touse' , caption(Overall)
	return add
	
end

program define PrintDEFF, rclass

	syntax varlist( numeric min=2 max=2) [if] [in], caption(str)
	
	marksample touse
	
	local wgt  : word 1 of `varlist'
	local wgt2 : word 2 of `varlist'
	
	tempname sumw sumw2 N deff

	sum `wgt2' if `touse', mean
	scalar `sumw2' = r(sum)
	scalar `N' = r(N)
	
	qui sum `wgt' if `touse'
	scalar `sumw' = r(sum)
	assert scalar(`N') == r(N)
	
	scalar `deff' = scalar(`N')*scalar(`sumw2')/( scalar(`sumw')*scalar(`sumw') )
		
	di "{txt}" %13s abbrev("`caption'",13) _col(15) "{txt}{c |}{res}" %8.2f r(min) _col(25) "{txt}{c |}{res}" %8.2f r(mean) _col(35) "{txt}{c |}{res}" %8.2f r(max) _c
	di _col(45) "{txt}{c |}{res}" %8.4f r(sd)/r(mean) _col(55) "{txt}{c |}{res}" %8.4f scalar(`deff') _c
	di _col(65) "{txt}{c |}{res}" %6.0f `N' _col(73) "{txt}{c |}{res}" %8.2f `N'/scalar(`deff')
	
	* strip eq signs from caption
	local capeq = subinstr("`caption'","==","_eq_",1)
	return scalar DEFF_`capeq' = scalar(`deff')
	return scalar Neff_`capeq' = `N'/scalar(`deff')

end

exit

History
31-Mar-2015	v.0.7	produces DEFF by groups 
