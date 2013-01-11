*! v.1.1.20 iterative proportional fitting (raking) by Stas Kolenikov skolenik at gmail dot com
program define ipfraking, rclass

	version 10

	syntax [pw/] [if] [in] , [ CTOTal( namelist )  ///
		GENerate(name) quietly replace ITERate(int 2000) TOLerance(passthru) CTRLTOLerance(passthru) loglevel(int 0) meta double nograph ///
		trimhirel(passthru) trimhiabs(passthru) trimlorel(passthru) trimloabs(passthru) TRIMFREQuency(string) trace ///
		selfcheck maxentropy from(varname) noDIVergence alpha(passthru) * ]

	// syntax:
	//   [pw=original weight variable]
	//   ctotal        is the list of matrix names, each matrix is a e(b) of an appropriate -total y, over()- command
	//   generate()    is the name of the variable to be created
	//   replace       indicates that the weight variable is to be overwritten
	//   trimrel       is the upper bound on the relative weight adjustment ratio
	//   trimabs       is the maximum weight allowed
	//   iterate       is the maximum number of iterations
	//   tolerance     is the difference in weight adjustment ratios over an iteration cycle

	if "`exp'"=="" & "`selfcheck'" == "" {
		display as error "pweight is required"
		exit 198
	}

	if "`replace'" != "" {
		capture confirm numeric variable `exp'
		if _rc {
			di "{err}`exp' is not a numeric variable; cannot replace"
			exit 198
		}
	}
	
	
	if "`selfcheck'" != "" {
		SelfCheck
		exit
	}
	else if "`ctotal'" == "" {
		display as error "ctotal() is required"
		exit 198
	}	

	CheckTrimOptions , `trimhiabs' `trimhirel' `trimloabs' `trimlorel' trimfrequency(`trimfrequency')
		
	tempvar oldweight currweight prevweight one
	
	marksample touse, zeroweight
	
	quietly generate byte `one' = 1
	
	if ("`generate'"!="") + ("`replace'"!= "") != 1 {
		display as error "one and only one of generate() or replace must be specified"
		exit 198
	}
	
	if "`generate'"!="" {
		capture confirm new variable `generate'
		// the following line will fail intentionally
		if _rc generate `double' `generate' = .
	}
	
	// finished checking input options
	
	display
	
	// parse and check the control totals
	ControlCheckParse `ctotal' , one( `one' ) loglevel(`loglevel')
	
	generate double `oldweight' = `exp' if `touse'
	generate double `prevweight' = `oldweight'
	if "`from'" == "" generate double `currweight' = `oldweight'
	else generate double `currweight' = `from'
	
	local nvars : word count `ctotal'

	local prevobj .
	
	if "`trace'" != "" {
		local traceplot traceplot(
		forvalues k=1/`nvars' {
			tempname mreldif`k'var
			
			CheckResults ,  target(`mat`k'') `ctrltolerance' loglevel(`loglevel') quietly : ///
				total `var`k'' if `touse' [pw=`currweight'] , over(`over`k'', nolab)			
			quietly generate double `mreldif`k'var' = r(mreldif) in 1
			label variable `mreldif`k'var' "`: word `k' of `ctotal''"
			local traceplot `traceplot' `mreldif`k'var'
		}
		local traceplot `traceplot' )
	}
	
	// choose the method
	if "`maxentropy'" == "" {
		// use iterative proportional fitting

		forvalues i=1/`iterate' {
			quietly replace `prevweight' = `currweight'
			forvalues k=1/`nvars' {
				PropAdjust `currweight' if `touse' , target(`mat`k'') control(`var`k'') over(`over`k'') loglevel(`loglevel') `alpha'
				if "`trimfrequency'" == "often" & "`trimopts'" != "" TrimWeights `oldweight' `currweight', `trimopts' one( `one' ) over( `over`k'' ) loglevel(`loglevel')
			}
			if "`trace'" != "" {
				forvalues k=1/`nvars' {
					CheckResults ,  target(`mat`k'') `ctrltolerance' loglevel(`loglevel') quietly : ///
						total `var`k'' if `touse' [pw=`currweight'] , over(`over`k'', nolab)
					quietly replace `mreldif`k'var' = r(mreldif) in `=`i'+1'
				}
				
			}
			if "`trimfrequency'" == "sometimes" & "`trimopts'"!="" TrimWeights `oldweight' `currweight', `trimopts' one( `one' ) over( `overlist' ) loglevel(`loglevel')
			CheckConvergence `prevweight' `currweight' if `touse', `tolerance'
			local currobj = r(maxreldif)
			if `loglevel' > 0 di _n
			display "{txt} Iteration `i', max rel difference of raked weights = {res}" `currobj'
			if r(converged) continue, break
			if `currobj' > `prevobj' & `i' > 2 {
				display "{err}Warning: raking procedure appears diverging"
				if "`divergence'" != "nodivergence" continue, break
			}
			local prevobj = `currobj'
		}
		
		if !r(converged) {
			display "{err}Warning: raking procedure did not converge"
		}
		
	}
	else {
		// use maxentropy
		if inlist("`trimfrequency'", "often", "sometimes") {
			display as error "Warning: only trimfrequency(once) is supported with maxentropy option"
		}
	
		// vectorize the control totals; label the matrix rows for later use to create tempvars
		FormMaxEntropyMatrix `ctotal'
		tempname maxentmatrix maxenttotal
		matrix `maxentmatrix' = r(M)
		scalar `maxenttotal' = r(total)
		
		forvalues k=1/`=rowsof(`maxentmatrix')' {
			tempvar ctrlvar`k'
			local ctrlvarlist `ctrlvarlist' `ctrlvar`k''
		}
		* create tempvars
		GenerateMaxEntropyVars `ctrlvarlist' if `touse', matrix( `maxentmatrix' )
		local ctrlvarlist_u `r(varlist)'

		maxentropy `ctrlvarlist_u' , matrix( `maxentmatrix' ) generate( `currweight', replace ) ///
			prior( `oldweight' ) total( `=`maxenttotal'' ) log
		return add

		return matrix maxentropy_mat = `maxentmatrix'
		return scalar maxentropy_tot = `maxenttotal'
			
	}

	if "`trimfrequency'" == "once" & "`trimopts'"!="" TrimWeights `oldweight' `currweight', `trimopts' one( `one' ) over( `overlist' )	
	return add

	// check if controls matched
	local badcontrols 0

	tempname pass
	local mrdmax = 0
	
	forvalues k=1/`nvars' {
		CheckResults ,  target(`mat`k'') `ctrltolerance' loglevel(`loglevel') : total `var`k'' if `touse' [pw=`currweight'] , over(`over`k'', nolab)
		matrix `pass' = r(target)
		matrix rowname `pass' = `over`k''
		return matrix target`k' = `pass'
		matrix `pass' = r(result)
		return matrix result`k' = `pass'
		return scalar mreldif`k' = r(mreldif)
		local mrdmax = max( `mrdmax', r(mreldif) )
		local badcontrols = `badcontrols' + r(badcontrols)
		local whicharebad `whicharebad' `mat`k''
	}
	/*
	if `badcontrols' {
		display "{err}Warning: control figures did not match"
	}
	*/
	return scalar maxctrl = `mrdmax'
	return scalar badcontrols = `badcontrols'

	DiagDisplay `oldweight' `currweight' , `graph' `traceplot' `options'
	return add
	
	// generate or replace the values
	if "`replace'" != "" {
		capture confirm numeric variable `exp'
		if _rc {
			di "{err}`exp' is not a numeric variable; cannot replace"
		}
		else {
			replace `exp' = `currweight'
			char `exp'[maxctrl] `mrdmax'
			char `exp'[objfcn] `currobj'
		}
	}
	else {
		generate `double' `generate' = `currweight' if `touse'
		label variable `generate' "Raked weights"
		if "`meta'" != "" {
		
			note `generate' : Raking controls used: `ctotal'
			forvalues k=1/`nvars' {
				char `generate'[`mat`k''] `=return(mreldif`k')'
			}
		}
		else char `generate'[maxctrl] `mrdmax'
		char `generate'[objfcn] `currobj'
		if `badcontrols' {
			note `generate' : `whicharebad' total(s) did not match when creating this variable
		}
		
		foreach trimpar in trimfrequency trimhiabs trimloabs trimhirel trimlorel {
			if "``trimpar''" != "" char `generate'[`trimpar'] ``trimpar''
		}
		
		if "`meta'" != "" {
			if length(`"`0'"')<240 char `generate'[command] `=itrim(`"`0'"')'
			else char `generate'[command] `0'
		}
	}

	return local ctotal `ctotal'
	
end // of ipfraking

program define CheckTrimOptions

	syntax , [trimhirel(passthru) trimhiabs(passthru) trimlorel(passthru) trimloabs(passthru) TRIMFREQuency(string)]
	
	if "`0'" == "" exit
	
	local trimopts `trimhirel' `trimhiabs' `trimlorel' `trimloabs'
	// dirty trick!!!
	c_local trimopts `trimopts'

	if "`trimfrequency'"!="" {
		if "`trimopts'" == "" {
			display "{err}Warning: trimfrequency() option is specified without numeric settings; will be ignored"
		}
		if !strpos("often sometimes once","`trimfrequency'") {
			display "{err}Warning: trimfrequency() option is specified incorrectly, assume default value (sometimes)"
			c_local trimfrequency sometimes
		}
	}
	if "`trimopts'" != "" & "`trimfrequency'" == "" {
		c_local trimfrequency sometimes
	}
	if "`trimopts'" != "" {
		foreach opt in trimhiabs trimhirel trimloabs trimlorel {
			if "``opt''" != "" {
				gettoken what rest : `opt', parse("(")
				gettoken par rest  : rest, parse("(")
				gettoken val rest  : rest, parse(")")
				capture confirm number `val'
				if _rc {			
					display "{err}`what' must be a positive number"
					exit 198
				}
				if `val' <= 0 {
					display "{err}`what' must be a positive number"
					exit 198
				}
				local `opt'_val `val'
			}
		}
		if "`trimhiabs'"!="" & "`trimloabs'" != "" {
			if `trimhiabs_val' <= `trimloabs_val' {
				display "{err}trimhiabs must be greater than trimloabs"
				exit 198
			}
		}
		if "`trimhirel'"!="" & "`trimlorel'" != "" {
			if `trimhirel_val' <= `trimlorel_val' {
				display "{err}trimhirel must be greater than trimlorel"
				exit 198
			}
		}
	}


end // of CheckTrimOptions

program define CheckResults, rclass

	gettoken cropt rest  : 0    , parse(":")
	gettoken colon torun : rest , parse(":")
	
	assert "`colon'" == ":"
	
	local 0 `cropt'
	syntax , target(name) [ ctrltolerance(real 1e-6) loglevel(int 0) quietly ]
	
	confirm matrix `target'
	
	quietly `torun'
	
	tempname bb
	matrix `bb' = e(b)
	
	local badcontrols = (mreldif(`bb',`target') > `ctrltolerance')
	
	return scalar badcontrols = `badcontrols'
	
	if `badcontrols' & "`quietly'" == "" {
		if `loglevel' > 0 di _n
		display as error "Warning: the controls `target' did not match"
		if `loglevel' > 0 {
			display "{txt}Target:" _c
			matrix list `target', noheader format(%12.0g)
			display "{txt}Realization:" _c
			matrix list `bb', noheader format(%12.0g)
		}
	}
	
	tempname mcopy
	matrix `mcopy' = `target'
	
	return scalar mreldif = mreldif(`bb',`target')
	return matrix target = `mcopy'
	return matrix result = `bb'
	

end // of CheckResults

program define PropAdjust

	syntax varname(numeric) [if] [in], target(namelist min=1 max=1) control(varname numeric) over(varname numeric) [alpha(real 1) loglevel(int 0)]
	
	local currweight `varlist'

	marksample touse
	
	capture total `control' [pw=`currweight'] if `touse', over( `over', nolab )
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
		if `loglevel' > 1 display "{txt}Control {res}`control'{txt}: " _c
		`quietly' replace `currweight' = `currweight' * `target'[1,1] / `bb'[1,1] if `touse' & `currweight' != 0 & `control' != 0
	}
	else {
		// cycle over categories
		forvalues k=1/`= colsof(`target')' {
			capture assert "`: word `k' of `: colnames `bb' ''" == "`: word `k' of `: colnames `target' ''"
			if _rc {
				// we've done the diagnostic before, so this should not be happening
				display as error "categories mismatch in PropAdjust"
				matrix list `bb'
				matrix list `target'
				exit 111
			}
			if `bb'[1,`k'] == 0 {
				display as error "Warning: division by zero weighted total encountered with `control' control with `over' == `k'"
			}
			
			if `loglevel' > 1 display "{txt}Control {res}`over'{txt}, category {res}`: word `k' of `: colnames `bb' ''{txt}: " _c
			`quietly' replace `currweight' = `currweight' * (`target'[1,`k'] / `bb'[1,`k'])^`alpha' if `touse' & `over' == `: word `k' of `: colnames `bb' '' & `currweight'!=0
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
			// this is an overall total
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
			tempname sum`k'
			scalar `sum`k'' = el( matrix(`mat`k''), 1, 1)
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
				display as error "categories of `over`k'' do not match in the control `mat`k'' and in the data (nolab option)"
				exit 111
			}
			
			quietly count if missing(`over`k'')
			if r(N) {
				display as error "Warning: `=r(N)' missing values of `over`k'' encountered; convergence will be impaired"
			}
			
			tempname sum`k'
			mata : st_numscalar("`sum`k''", sum( st_matrix("`mat`k''") ) )
			
			c_local var`k' `var`k''
			c_local over`k' `over`k''
			c_local mat`k'  `mat`k''
		}
		local overlist `overlist' `over`k''
	}
	c_local overlist `overlist'
	
	* check the sums
	tempname sumdif avesum
	scalar `sumdif' = 0
	scalar `avesum' = 0
	forvalues k=1/`nvars' {
		forvalues l=1/`k' {
			scalar `sumdif' = `sumdif' + abs( `sum`k'' - `sum`l'' )
		}
		scalar `avesum' = `avesum' + `sum`k''/`nvars'
	}
	if `sumdif' > 100*`avesum'*`nvars'*(`nvars'-1)*c(epsdouble) {
		display as err "Warning: the totals of the control matrices are different:"
		forvalues k=1/`nvars' {
			display _col(4) "{txt}Target {res}`k' {txt}({res}`mat`k''{txt}) total" _col(45) " = {res}" %20.10g `sum`k''
		}
		display
	}

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

	syntax varlist(numeric min=2 max=2) [if] [in] , [ nograph traceplot(varlist) * ]

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

	local d = min(6-floor( log10(`newmean' ) ), 6)
	
	display _n "{txt}   Summary of the weight changes" _n
	display _col(15) "{txt}{c |}    Mean    Std. dev.    Min        Max       CV"
	display "{txt}{dup 14:{c -}}{c +}{dup 50:{c -}} "
	
	display "{txt}Orig weights  {c |} " _c
	display _col(15) as res %8.`d'g `oldmean' _c
	display _col(28) as res %8.`d'g `oldsd' _c
	display _col(38) as res %8.`d'g `oldmin' _c
	display _col(49) as res %9.`d'g `oldmax' _c
	display _col(60) as res %6.4g `oldsd'/`oldmean'
	
	display "{txt}Raked weights {c |} " _c
	display _col(15) as res %8.`d'g `newmean' _c
	display _col(28) as res %8.`d'g `newsd' _c
	display _col(38) as res %8.`d'g `newmin' _c
	display _col(49) as res %9.`d'g `newmax' _c
	display _col(60) as res %6.4g `newsd'/`newmean'
	
	return scalar raked_mean = `newmean'
	return scalar raked_sd   = `newsd'
	return scalar raked_min  = `newmin'
	return scalar raked_max  = `newmax'
	return scalar raked_cv   = `newsd'/`newmean'
	
	display "{txt}Adjust factor {c |} " _c
	display _col(17) as res %8.4f `wrmean' _c
	display _col(38) as res %8.4f `wrmin' _c
	display _col(49) as res %9.4f `wrmax'
	
	return scalar factor_mean = `wrmean'
	return scalar factor_min  = `wrmin'
	return scalar factor_max  = `wrmax'
	return scalar factor_cv   = `wrmean'/`wrsd'
	
	if "`graph'" == "" {
		// histograms
		tempname histnew histratio histboth
		
		label variable `newweight' "Raked weights"
		quietly histogram `newweight', freq nodraw name( `histnew' )
		
		label variable `wratio' "Adjustment factor"
		quietly histogram `wratio', freq nodraw name( `histratio' )
		
*		if "`traceplot'" != "" local nameopt name(`histboth')
*		else local nameopt `name'
		
		// traceplot
		if "`traceplot'" != "" {
			tempvar obsno mindif maxdif
			tempname traceline logtraceline
			sum `traceplot', mean
			qui gen int `obsno' = _n-1 in 1/`=r(N)'
					
			// split the legend
			local k=0
			foreach x of varlist `traceplot' {
				local ++k
				if 2*`k' > `: word count `traceplot'' local order2 `order2' `k'
				else local order1 `order1' `k'
			}
			
			label variable `obsno' "Iteration"
			
			// the last raking margin should nearly always be zero
			local last : word `: word count `traceplot'' of `traceplot'
			local traceplotl : list traceplot - last
			
			// come up with neat labels on log scale
			qui egen float `mindif' = rowmin(`traceplotl')
			qui egen float `maxdif' = rowmax(`traceplot')
			sum `mindif', mean
			local logmin = floor( log10( r(min) ) )
			sum `maxdif', mean
			local logmax = ceil( log10( r(max) ) )
			local logstep = round( (`logmax'-`logmin')/5 )
			if `logstep' == 0 local logstep 1
			foreach d of numlist `logmin'(`logstep')`logmax' {
				local thelab `thelab' 1e`d'
			}		

			quietly line `traceplot' `obsno' , nodraw name( `traceline' ) legend( cols(1) order( `order2' ) )
			quietly line `traceplotl' `obsno' , nodraw name( `logtraceline' ) legend( cols(1) order( `order1' ) ) ///
				yscale( log ) ylab( `thelab', angle(horizontal) )
		}
		
		graph combine `histnew' `histratio' `traceline' `logtraceline', `options'

	}
	
end // of DiagDisplay


program define SelfCheck

	preserve

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

	di as inp _n ">> 1. raking with a single margin"
	ipfraking [pw=finalwgt] , ctotal( total_sex ) generate( rweight1 )
	return list
	assert r(converged)   == 1
	assert r(badcontrols) == 0

	total _one [pw=rweight1], over(sex, nolab)
	matrix `bb' = e(b)
	assert mreldif( `bb',total_sex ) < c(epsfloat)

	di as inp _n ">> 2. raking with two margins"
	total _one [pw=finalwgt], over(race, nolab)
	matrix total_race = e(b)
	matrix total_race[1,1] = total_race[1,1] + 15000
	matrix total_race[1,2] = total_race[1,2] + 4000
	matrix total_race[1,3] = total_race[1,3] + 1000
	matrix rownames total_race = race

	ipfraking [pw=finalwgt] , ctotal( total_sex total_race ) generate( rweight2 )
	return list

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
	
	di as inp _n ">> 3. regular raking without constraints"
	ipfraking [pw=finalwgt] , ctotal( total_sex total_race ) generate( rweight3 )
	return list

	assert r(converged)   == 1
	assert r(badcontrols) == 0

	total _one [pw=rweight3], over(sex, nolab)
	matrix `bb' = e(b)
	assert mreldif( `bb',total_sex ) < c(epsfloat)

	total _one [pw=rweight3], over(race, nolab)
	matrix `bb' = e(b)
	assert mreldif( `bb',total_race ) < c(epsfloat)
	
	di as inp _n ">> 4. raking with constraints on adjustment factors (control totals will be off)"
	ipfraking [pw=finalwgt] , ctotal( total_sex total_race ) generate( rweight4 ) trimhirel( 5.5 ) tol(1e-10)
	return list
	
	assert r(converged)   == 1
	assert r(badcontrols) > 0

	total _one [pw=rweight4], over(sex, nolab)
	matrix `bb' = e(b)
	display mreldif( `bb',total_sex )

	total _one [pw=rweight4], over(race, nolab)
	matrix `bb' = e(b)
	display mreldif( `bb',total_race )
	
	di as inp _n ">> 5. raking with constraints on absolute values of weights"
	ipfraking [pw=finalwgt] , ctotal( total_sex total_race ) generate( rweight5 ) trimhirel( 5.5 ) trimhiabs(200000)
	return list

	assert r(converged)   == 1
	assert r(badcontrols) > 0
	
	total _one [pw=rweight5], over(sex, nolab)
	matrix `bb' = e(b)
	capture noisily assert mreldif( `bb',total_sex ) < c(epsfloat)

	total _one [pw=rweight5], over(race, nolab)
	matrix `bb' = e(b)
	capture noisily assert mreldif( `bb',total_race ) < c(epsfloat)
	
	di as inp _n ">> 6. this will take longer to converge"
	capture noisily ipfraking [pw=finalwgt] , ctotal( total_sex total_race ) generate( rweight6 ) trimhiabs(100000) trimloabs(50000)
	return list
	
	assert r(converged)   == 1
	assert r(badcontrols) == 0

	di as inp _n ">> 7. test -replace- option"
	gen rweight7 = finalwgt
	capture noisily ipfraking [pw=rweight7] , ctotal( total_sex total_race ) replace trimhiabs(100000) trimloabs(50000)
	return list
	
	assert r(converged)   == 1
	assert r(badcontrols) == 0
	count if rweight7 != finalwgt
	assert r(N) > 0
	assert reldif( rweight7, rweight6 ) < c(epsfloat)
	
	di as inp _n ">> 8. test limited # of iterations"
	capture noisily ipfraking [pw=finalwgt] , ctotal( total_sex total_race ) generate( rweight8 ) trimhiabs(100000) trimloabs(50000) iter(5)
	return list
	
	assert r(converged)   == 0
	assert r(badcontrols) > 0
	
	di as inp _n ">> 9. intentional syntax errors"
	capture noisily ipfraking 
	assert _rc == 198
	capture noisily ipfraking [pw=finalwgt]
	assert _rc == 198
	capture noisily ipfraking [pw=finalwgt], ctotal( total_sex total_race )
	assert _rc == 198
	capture noisily ipfraking [pw=finalwgt], ctotal( total_sex total_race ) generate( rweight9 ) replace
	assert _rc == 198
	capture noisily ipfraking [pw=finalwgt], ctotal( total_sex total_race ) generate( rweight9 ) trimhiabs(0)
	assert _rc == 198
	capture noisily ipfraking [pw=finalwgt], ctotal( total_sex total_race ) generate( rweight9 ) trimhiabs(200) trimloabs(10000)
	assert _rc == 198
	
	
	
	// end of checks
	set more `cmore'
	
	restore
	
	di _n "{txt}ALL TESTS PASSED."
	
end // of SelfCheck


program define FormMaxEntropyMatrix, rclass
	// vectorize the control totals; label the matrix rows for later use to create tempvars
	syntax namelist

	tempname M curr_total ave_total
	
	local nt = 0
	scalar `ave_total' = 0
	
	local nvars : word count `namelist'
	forvalues k=1/`nvars' {
		local mat`k'  : word `k' of `namelist'
		local over`k' : rownames `mat`k''
		local val`k'  : colnames `mat`k''
			
		if colsof(`mat`k'') == 1 {
			// this is an overall total
			matrix `M' = nullmat(`M') \ `mat`k''
			local Mrnames `Mrnames' `over`k''
		}
		else {
			// this is -over()- something
			local cols`k' = colsof( `mat`k'' )

			mata : st_numscalar( "`curr_total'", sum( st_matrix( "`mat`k''") ) )
			scalar `ave_total' = `ave_total' + `curr_total'
			
			// omit the last category to avoid multicollinearity
			matrix `M' = nullmat( `M' ) \ (`mat`k''[1,1..`cols`k''-1]'/`curr_total')
			forvalues j=1/`=`cols`k''-1' {
				local Mrnames `Mrnames' `over`k'':`: word `j' of `val`k'''
			}
			
			local ++nt
		}
	}
	
	matrix rownames `M' = `Mrnames'
		
	return matrix M = `M'
	return scalar total = `ave_total' / `nt'

end // of FormMaxEntropyMatrix
	
program define GenerateMaxEntropyVars , rclass

	syntax newvarlist [if] [in], matrix( name )
	
	marksample touse, novarlist
	
	local thenames : rowfullnames `matrix'
	
	// each row of the matrix -> new variable
	
	forvalues k=1/`=rowsof(`matrix')' {
		local var`k' : word `k' of `varlist'
		
		// is this a single variable or a cagetory of a variable?
		local title : word `k' of `thenames'
		gettoken thevar rest : title, parse(":")
		if "`rest'" == "" {
			generate double `var`k'' = `thevar' if `touse'
		}
		else {
			gettoken colon value : rest , parse(":")
			assert "`colon'" == ":"
			generate byte `var`k'' = ( `thevar' == `value' ) if `touse'
		}
	}

	// remove the collinear variables and redefine the calibration matrix
	_rmcoll `varlist'
	if r(k_omitted) > 0 {
		local goodguys `r(varlist)'
		tempname M
		foreach x of varlist `goodguys' {
			// determine the position in the original list
			local row : list posof "`x'" in varlist
			assert `row' > 0
			matrix `M' = nullmat(`M') \ `matrix'[`row',1]
			local Mrownames `Mrownames' `: word `row' of `thenames''
		}
		// overwrite the original matrix
		matrix rowname `M' = `Mrownames'
		matrix `matrix' = `M'
	}
	
	return local varlist `goodguys'
	
end // of GenerateMaxEntropyVars












exit






/* History
1.1.8	added output of targets, controls and mismatches
		check that totals are the same
1.1.10	added support for maxentropy (which generally sucks)
1.1.11	-from()- option is added
1.1.12	all the reldifs are saved with -meta- option
		traceplot is added to the graphical output
		bugs with parameter transfer to -graph- are fixed
1.1.13 	when a continuous variable over(1) is specified,
		only correct the weights for non-zero values of the control
1.1.14	nodivergence option is added; control convergence <- iter() ?
		alpha() is the speed of adjustment
1.1.15  Nothing is done with ipfraking, but mat2do utility program
        is added to the package
1.1.16  Nothing is done with ipfraking, but Stata Journal insert
        was initiated
1.1.17  Cosmetic changes in output (2013-01-02)
        Fixed bug in -replace- option
1.1.18  Chars always contain the objective function and 
		the control accuracy on exit
1.1.19  Updated -selfcheck-
1.1.20	Cosmetic changes in output
*/
