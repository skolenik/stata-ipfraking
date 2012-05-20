program define ipfraking, rclass

	version 10

	syntax [pw/] [if] [in] , [ CTOTal( namelist ) cmean( namelist ) ///
		generate(name) quietly replace ITERate(int 2000) TOLerance(passthru) CTRLTOLerance(passthru) loglevel(int 0) meta double ///
		trimhirel(passthru) trimhiabs(passthru) trimlorel(passthru) trimloabs(passthru) TRIMFREQuency(string) ///
		selfcheck ]

	// syntax:
	//   [pw=original weight variable]
	//   ctotal        is the list of matrix names, each matrix is a e(b) of an appropriate -total y, over()- command
	//   cmean         is the list of matrix names, each matrix is a e(b) of an appropriate -mean y, over()- command
	//   generate()    is the name of the variable to be created
	//   replace       indicates that the weight variable is to be overwritten
	//   trimrel       is the upper bound on the relative weight adjustment ratio
	//   trimabs       is the maximum weight allowed
	//   iterate       is the maximum number of iterations
	//   tolerance     is the difference in weight adjustment ratios over an iteration cycle

	if "`exp'"=="" {
		display as error "pweight is required"
		exit 198
	}
	
	if "`selfcheck'" != "" {
		SelfCheck
		exit
	}
	
	local trimopts `trimhiabs' `trimhirel' `trimloabs' `trimlorel'

	if "`trimfrequency'"!="" {
		if "`trimopts'" == "" {
			display "{err}Warning: trimfreuency() option is specified without numeric settings; will be ignored"
		}
		if !strpos("often sometimes once","`trimfrequency'") {
			display "{err}Warning: trimfrequency() option is specified incorrectly, assume default value (sometimes)"
			local trim sometimes
		}
	}
	if "`trimopts'" != "" & "`trimfrequency'" == "" {
		local trimfrequency sometimes
	}
	
	tempvar oldweight currweight prevweight one
	
	marksample touse
	
	quietly generate byte `one' = 1
	
	if ("`generate'"!="") + ("`replace'"!= "") != 1 {
		display as error "one and only one of generate() or replace must be specified"
		exit 198
	}
	
	if ("`ctotal'"!="") + ("`cmean'"!= "") != 1 {
		display as error "one and only one of ctotal or cmean must be specified"
		exit 198
	}
	if "`ctotal'" != "" local total total
	if "`cmean'"  != "" local mean mean

	if "`generate'"!="" {
		capture confirm new variable `generate'
		// the following line will fail intentionally
		if _rc generate `generate' = .
	}
	
	// finished checking input options
	
	display
	
	// parse and check the control totals/means
	ControlCheckParse `ctotal' `cmean' , one( `one' ) loglevel(`loglevel')
	
	generate double `oldweight' = `exp' if `touse'
	generate double `prevweight' = `oldweight'
	generate double `currweight' = `oldweight'
	
	local nvars : word count `cmean' `ctotal'

	forvalues i=1/`iterate' {
		quietly replace `prevweight' = `currweight'
		forvalues k=1/`nvars' {
			PropAdjust `currweight' if `touse' , `total' `mean' target(`mat`k'') control(`var`k'') over(`over`k'') loglevel(`loglevel')
			if "`trimfrequency'" == "often" & "`trimopts'" != "" TrimWeights `oldweight' `currweight', `trimopts' one( `one' ) over( `over`k'' ) loglevel(`loglevel')
		}
		if "`trimfrequency'" == "sometimes" & "`trimopts'"!="" TrimWeights `oldweight' `currweight', `trimopts' one( `one' ) over( `overlist' ) loglevel(`loglevel')
		CheckConvergence `prevweight' `currweight' if `touse', `tolerance'
		display "{txt} Iteration `i', max rel difference of raked weights = {res}" r(maxreldif) _n
		if r(converged) continue, break
	}
	
	if !r(converged) {
		display "{err}Warning: raking procedure did not converge"
	}
	
	if "`trimfrequency'" == "once" & "`trimopts'"!="" TrimWeights `oldweight' `currweight', `trimopts' one( `one' ) over( `overlist' )	
	return add

	local badcontrols 0
	
	forvalues k=1/`nvars' {
		CheckResults ,  target(`mat`k'') `ctrltolerance' loglevel(`loglevel') : `total' `mean' `var`k'' if `touse' [pw=`currweight'] , over(`over`k'', nolab)
		local badcontrols = `badcontrols' | r(badcontrols)
	}
	if `badcontrols' {
		display "{err}Warning: weight adjustments converged, but the control figures did not match"
	}
	return scalar badcontrols = `badcontrols'

	DiagDisplay `oldweight' `currweight'
	return add
	
	// generate or replace the values
	if "`replace'" != "" replace `oldweight' = `currweight'
	else {
		generate `double' `generate' = `currweight' if `touse'
		label variable `generate' "Raked weights"
		if "`meta'" != "" {
			note `generate' : Raking controls used: ctotal( `ctotal' ) / cmean( `cmean' )
		}
	}
	
end // of ipfraking

program define CheckResults, rclass

	gettoken cropt rest  : 0    , parse(":")
	gettoken colon torun : rest , parse(":")
	
	assert "`colon'" == ":"
	
	local 0 `cropt'
	syntax , target(name) [ ctrltolerance(real 1e-6) loglevel(int 0) ]
	
	confirm matrix `target'
	
	quietly `torun'
	
	tempname bb
	matrix `bb' = e(b)
	
	local badcontrols = (mreldif(`bb',`target') > `ctrltolerance')
	
	return scalar badcontrols = `badcontrols'
	
	if `badcontrols' {
		display as error _n "Warning: the controls `target' did not match"
		if `loglevel' > 0 {
			display "{txt}Target:" _c
			matrix list `target', noheader format(%12.0g)
			display "{txt}Realization:" _c
			matrix list `bb', noheader format(%12.0g)
		}
	}
	
	display

end // of CheckResults

program define PropAdjust

	syntax varname(numeric) [if] [in], target(namelist min=1 max=1) control(varname numeric) over(varname numeric) [total mean loglevel(int 0)]
	
	local currweight `varlist'

	marksample touse
	
	capture `total' `mean' `control' [pw=`currweight'] if `touse', over( `over', nolab )
	if _rc {
		display as error "cannot compute controls for `control' over `over' with the current weights"
		exit 301
	}
	
	if `loglevel' < 2 local quietly quietly
	
	tempname bb
	matrix `bb' = e(b)

	if colsof(`bb') == 1 {
		if `bb'[1,1] == 0 {
			display as error "Warning: division by zero weighted total encountered with `control' control"
		}
		`quietly' replace `currweight' = `currweight' * `target'[1,1] / `bb'[1,1] if `touse'
	}
	else {
		// cycle over categories
		forvalues k=1/`= colsof(`target')' {
			capture assert "`: word `k' of `: colnames `bb' ''" == "`: word `k' of `: colnames `target' ''"
			if _rc {
				// we've done the diagnostic before, so this should not be happening
				display as error "categories mismatch in PropAdjust"
				exit 111
			}
			if `bb'[1,`k'] == 0 {
				display as error "Warning: division by zero weighted total encountered with `control' control with `over' == `k'"
			}
			
			`quietly' replace `currweight' = `currweight' * `target'[1,`k'] / `bb'[1,`k'] if `touse' & `over' == `: word `k' of `: colnames `bb' ''
		}
	}
	
end // of PropAdjust


program define ControlCheckParse

	syntax namelist , one( varname ) [ loglevel(int 0) ]

	tempname b
	
	local nvars : word count `namelist'
	forvalues k=1/`nvars' {
		local mat`k' : word `k' of `namelist'
		if colsof(`mat`k'') == 1 {
			// this is an overall total/mean
			capture local var`k' : colnames `mat`k''
			if _rc {
				display as error "cannot process matrix `mat`k''"
				exit 111
			}
			capture confirm numeric variable `var`k''
			if _rc {
				display as error "variable `var`k'' corresponding to the control matrix `mat`k'' not found"
				exit 111
			}
			local over`k' `one'
			c_local over`k' `one'
			c_local var`k'  `var`k''
			c_local mat`k'  `mat`k''
		}
		else {
			// this is -over()- something, must be obtained 
			capture local var`k' : word 1 of `: coleq `mat`k'''
			if _rc {
				display as error "cannot process matrix `mat`k''"
				exit 111
			}
			capture confirm numeric variable `var`k''
			if _rc {
				display as error "variable `var`k'' corresponding to the control matrix `mat`k'' not found"
				exit 111
			}
			local over`k' : rownames `mat`k''
			capture confirm numeric variable `over`k''
			if _rc {
				display as error "variable `over`k'' tabulating the control matrix `mat`k'' not found"
				exit 111
			}
			capture total `var`k'', over( `over`k'', nolab )
			if _rc {
				display as error "`var`k'' and `over`k'' variables are not compatible"
				exit 111
			}
			matrix `b' = e(b)
			if "`: colfullnames `mat`k'''" != "`: colfullnames `b''" {
				display as error "categories of `over`k'' do not match in the control `mat`k'' and in the data"
				exit 111
			}
			
			c_local var`k' `var`k''
			c_local over`k' `over`k''
			c_local mat`k'  `mat`k''
		}
		local overlist `overlist' `over`k''
	}
	c_local overlist `overlist'

end // of ControlCheckParse

program define TrimWeights

	syntax varlist(numeric min=2 max=2) , [ one(varname numeric) over(varlist) ///
		trimhirel(real `=c(maxdouble)') trimhiabs(real `=c(maxdouble)') trimlorel(real 0) trimloabs(real 0) loglevel(int 0) ]

	local oldweight : word 1 of `varlist'
	local newweight : word 2 of `varlist'
	
	if `loglevel' < 2 local quietly quietly
	
	tempvar trimhi trimlo
	
	`quietly' generate byte `trimhi' = (`newweight' > `oldweight' * `trimhirel') | `newweight' > `trimhiabs'
	`quietly' generate byte `trimlo' = (`newweight' < `oldweight' * `trimlorel') | `newweight' < `trimloabs'
	`quietly' count if `trimhi' + `trimlo' > 0 & !missing( `trimhi' + `trimlo' )

	if r(N) {	
		// check ratios
		`quietly' replace `newweight' = `oldweight' * `trimhirel' if `newweight' > `oldweight' * `trimhirel'
		`quietly' replace `newweight' = `oldweight' * `trimlorel' if `newweight' < `oldweight' * `trimlorel'
		
		// check ranges
		`quietly' replace `newweight' = `trimhiabs' if `newweight' > `trimhiabs'
		`quietly' replace `newweight' = `trimloabs' if `newweight' < `trimloabs'
		
		// report the trimming categories
		if `loglevel' > 0 {
			local uniqover : list uniq over
			local uniqover : list uniqover - one
			tempvar groupover
			`quietly' egen `groupover' = group( `uniqover' )
			`quietly' replace `groupover' = `groupover' * ( `trimhi' | `trimlo' )
			quietly levelsof `groupover' if ( `trimhi' | `trimlo' ) , local( trimmedcells )
		
			// display the header
			display "{txt}{dup 31:{c -}}{c TT}{dup 12:{c -}}{c TT}{dup 12:{c -}}"
			display _col(32) "{txt}{c |}   Trimmed  {c |}  Trimmed"
			display _col(32) "{txt}{c |} from above {c |} from below"
			display "{txt}{dup 31:{c -}}{c +}{dup 12:{c -}}{c BT}{dup 12:{c -}}" _c
			
			foreach g in `trimmedcells' {
				foreach x of varlist `uniqover' {
					sum `x' if `groupover' == `g', mean
					display _n "{res}`x'" _col(20) "{txt} = {res}" r(mean) _col(32) "{txt}{c |}" _c
				}
				quietly count if `groupover' == `g' & `trimhi'
				display _col(36) "{res}" r(N) _col(45) "{txt}{c |}" _c
				quietly count if `groupover' == `g' & `trimlo'
				display _col(50) "{res}" r(N) 
				//////// display the divider or the last line
				// sum `groupover' if ( `trimhi' | `trimlo' ), meanonly
				// if `g' == r(max) {
					display "{txt}{dup 31:{c -}}{c BT}{dup 12:{c -}}{c BT}{dup 12:{c -}}" _c
				// }
				// else {
				//	display "{txt}{dup 31:{c -}}{c +}{dup 12:{c -}}{c +}{dup 12:{c -}}" _c
				// }
			}
			display _n
		}
	}
		
end // of TrimWeights

program define CheckConvergence, rclass

	syntax varlist(numeric min=2 max=2) [if] [in], [ tolerance(real 1e-6) ]

	local oldweight : word 1 of `varlist'
	local newweight : word 2 of `varlist'
	
	marksample touse
	
	tempvar reldif
	
	quietly generate double `reldif' = abs(`newweight'-`oldweight')/`oldweight' if `touse'
	
	quietly count if `reldif' > `tolerance' & !missing(`reldif')
	
	if r(N) return scalar converged = 0
	else return scalar converged = 1
	
	sum `reldif', meanonly
	return scalar maxreldif = r(max)
	
end // of CheckConvergence

program define DiagDisplay, rclass

	syntax varlist(numeric min=2 max=2) [if] [in] 

	marksample touse
	
	local oldweight : word 1 of `varlist'
	local newweight : word 2 of `varlist'

	tempvar wratio
	quietly generate double `wratio' = `newweight'/`oldweight' if `touse'
	
	// summary statistics
	quietly sum `oldweight' if `touse'
	local oldmean = r(mean)
	local oldsd   = r(sd)
	local oldmin  = r(min)
	local oldmax  = r(max)

	quietly sum `newweight' if `touse'
	local newmean = r(mean)
	local newsd   = r(sd)
	local newmin  = r(min)
	local newmax  = r(max)
	
	quietly sum `wratio' if `touse'
	local wrmean  = r(mean)
	local wrmin   = r(min)
	local wrmax   = r(max)
	local wrsd    = r(sd)

	local d = 6-floor( log10(`newmean' ) )
	
	display _n "{txt}   Summary of the weight changes" _n
	display _col(15) "{txt}{c |}    Mean    Std. dev.    Min        Max       CV"
	display "{txt}{dup 14:{c -}}{c +}{dup 50:{c -}} "
	
	display "{txt}Orig weights  {c |} " _c
	display _col(15) as res %8.`d'f `oldmean' _c
	display _col(28) as res %8.`d'f `oldsd' _c
	display _col(38) as res %8.`d'f `oldmin' _c
	display _col(49) as res %9.`d'f `oldmax' _c
	display _col(60) as res %6.4g `oldsd'/`oldmean'
	
	display "{txt}Raked weights {c |} " _c
	display _col(15) as res %8.`d'f `newmean' _c
	display _col(28) as res %8.`d'f `newsd' _c
	display _col(38) as res %8.`d'f `newmin' _c
	display _col(49) as res %9.`d'f `newmax' _c
	display _col(60) as res %6.4g `newsd'/`newmean'
	
	return scalar raked_mean = `newmean'
	return scalar raked_sd   = `newsd'
	return scalar raked_min  = `newmin'
	return scalar raked_max  = `newmax'
	return scalar raked_cv   = `newsd'/`newmean'
	
	display "{txt}Adjust factor {c |} " _c
	display _col(19) as res %6.4f `wrmean' _c
	display _col(40) as res %6.4f `wrmin' _c
	display _col(51) as res %7.4f `wrmax'
	
	return scalar factor_mean = `wrmean'
	return scalar factor_min  = `wrmin'
	return scalar factor_max  = `wrmax'
	return scalar factor_cv   = `wrmean'/`wrsd'
	
	// histograms
	tempname histnew histratio
	
	label variable `newweight' "Raked weights"
	quietly histogram `newweight', freq nodraw name( `histnew' )
	
	label variable `wratio' "Adjustment factor"
	quietly histogram `wratio', freq nodraw name( `histratio' )
	
	graph combine `histnew' `histratio'
	
end // of DiagDisplay


program define SelfCheck

	local cmore `c(more)'
	set more off

	tempname bb

	capture use nhanes2, clear
	if _rc webuse nhanes2, clear
	
	generate byte _one = 1
	total _one [pw=finalwgt], over(sex, nolab)
	matrix total_sex = e(b)
	matrix total_sex[1,1] = total_sex[1,1] + 10000
	matrix total_sex[1,2] = total_sex[1,2] + 10000
	matrix rownames total_sex = sex

	// 1. raking with a single margine
	ipfraking [pw=finalwgt] , ctotal( total_sex ) generate( rweight1 )
	assert r(converged)   == 1
	assert r(badcontrols) == 0

	total _one [pw=rweight1], over(sex, nolab)
	matrix `bb' = e(b)
	assert mreldif( `bb',total_sex ) < c(epsfloat)

	// 2. raking with two margins
	total _one [pw=finalwgt], over(race, nolab)
	matrix total_race = e(b)
	matrix total_race[1,1] = total_race[1,1] + 15000
	matrix total_race[1,2] = total_race[1,2] + 4000
	matrix total_race[1,3] = total_race[1,3] + 1000
	matrix rownames total_race = race

	ipfraking [pw=finalwgt] , ctotal( total_sex total_race ) generate( rweight2 )

	assert r(converged)   == 1
	assert r(badcontrols) == 0

	total _one [pw=rweight2], over(sex, nolab)
	matrix `bb' = e(b)
	assert mreldif( `bb',total_sex ) < c(epsfloat)

	total _one [pw=rweight2], over(race, nolab)
	matrix `bb' = e(b)
	assert mreldif( `bb',total_race ) < c(epsfloat)

	
	// somewhat unbalanced sample
	set seed 12345
	sample 500, count by(region)
	
	// 3. regular raking without constraints
	ipfraking [pw=finalwgt] , ctotal( total_sex total_race ) generate( rweight3 )

	assert r(converged)   == 1
	assert r(badcontrols) == 0

	total _one [pw=rweight3], over(sex, nolab)
	matrix `bb' = e(b)
	assert mreldif( `bb',total_sex ) < c(epsfloat)

	total _one [pw=rweight3], over(race, nolab)
	matrix `bb' = e(b)
	assert mreldif( `bb',total_race ) < c(epsfloat)
	
	// 4. raking with constraints on adjustment factors
	ipfraking [pw=finalwgt] , ctotal( total_sex total_race ) generate( rweight4 ) trimhirel( 5.5 ) tol(1e-10)
	
	assert r(converged)   == 1
	assert r(badcontrols) == 1

	total _one [pw=rweight4], over(sex, nolab)
	matrix `bb' = e(b)
	capture noisily assert mreldif( `bb',total_sex ) < c(epsfloat)

	total _one [pw=rweight4], over(race, nolab)
	matrix `bb' = e(b)
	capture noisily assert mreldif( `bb',total_race ) < c(epsfloat)
	
	// 5. raking with constraints on absolute values of weights
	ipfraking [pw=finalwgt] , ctotal( total_sex total_race ) generate( rweight5 ) trimhirel( 5.5 ) trimhiabs(200000)

	assert r(converged)   == 1
	assert r(badcontrols) == 1
	
	total _one [pw=rweight5], over(sex, nolab)
	matrix `bb' = e(b)
	capture noisily assert mreldif( `bb',total_sex ) < c(epsfloat)

	total _one [pw=rweight5], over(race, nolab)
	matrix `bb' = e(b)
	capture noisily assert mreldif( `bb',total_race ) < c(epsfloat)
	
	// 6. this must fail to converge
	capture noisily ipfraking [pw=finalwgt] , ctotal( total_sex total_race ) generate( rweight6 ) trimhiabs(100000) trimloabs(50000)
	
	set more `cmore'
	
end // of SelfCheck
