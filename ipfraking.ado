*! v.1.2.36 iterative proportional fitting (raking) by Stas Kolenikov skolenik at gmail dot com
program define ipfraking, rclass

	version 10

	syntax [pw/] [if] [in] , [ CTOTal( namelist )  ///
		GENerate(name) quietly replace ITERate(int 2000) TOLerance(passthru) CTRLTOLerance(passthru) loglevel(int 0) meta double nograph ///
		trimhirel(passthru) trimhiabs(passthru) trimlorel(passthru) trimloabs(passthru) TRIMFREQuency(string) trace one(varlist min=1 max=1 numeric) ///
		selfcheck rapid from(varname) noDIVergence alpha(passthru) mstep(real 1) mataoptevaltype(string) ///
		/// KINKHIgh(passthru) KINKLOw(passthru) KINKFREQuency(passthru) kinkat(passthru) 
		KINKABSHIgh(passthru) KINKRELHIgh(passthru) KINKABSLOw(passthru) KINKRELLOw(passthru) KINKFREQuency(passthru) ///
		* ]

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

	// parse the trimming options
	// dirty tricks: pushes back 
	// local trimopts `trimhiabs' `trimhirel' `trimloabs' `trimlorel'
	// updates trimfrequency with the default "sometimes" value as needed
	CheckTrimOptions , `trimhiabs' `trimhirel' `trimloabs' `trimlorel' trimfrequency(`trimfrequency')
	
	tempvar oldweight currweight prevweight 
	
	marksample touse, zeroweight

	if "`one'" == "" {
		tempvar one
		quietly generate byte `one' = 1
	}
	
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
	ControlCheckParse `ctotal' , one( `one' ) loglevel(`loglevel') touse( `touse' )
	
	generate double `oldweight' = `exp' if `touse'
	generate double `prevweight' = `oldweight'
	if "`from'" == "" generate double `currweight' = `oldweight'
	else generate double `currweight' = `from'
	
	// parse the kink options
	if "`kinkabshigh'`kinkrelhigh'`kinkabslow'`kinkrellow'`kinkfrequency'" != "" {
		// check the ranges and such
		// dirty trick: push back updated kinkfreq as a single word; kinkat as a number
		tempvar atlow athigh
		qui gen double `atlow' = 0
		qui gen double `athigh' = .y
		CheckKinkOptions `atlow' `athigh' `oldweight', `kinkabshigh' `kinkrelhigh' `kinkabslow' `kinkrellow' `kinkfrequency' ///
			loglevel(`loglevel') trim("`trimopts'") 
	}
	
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
	
	if !inlist("`mataoptevaltype'","","d0","d1","d1debug","d2","d2debug") {
		di "{err}invalid mataoptevaltype(`mataoptevaltype')"
		exit 198
	}
	
	// choose the method
	if "`rapid'" == "" {
		// use iterative proportional fitting

		forvalues i=1/`iterate' {
			quietly replace `prevweight' = `currweight'
			if `loglevel' > 1 di
			forvalues k=1/`nvars' {
				PropAdjust `currweight' if `touse' , target(`mat`k'') control(`var`k'') over(`over`k'') loglevel(`loglevel') `alpha'
				if "`trimfrequency'" == "often" & "`trimopts'" != "" TrimWeights `oldweight' `currweight', `trimopts' one( `one' ) over( `over`k'' ) loglevel(`loglevel')
				if "`kinkfreq'" == "often" ProcessKink `oldweight' `currweight', `kinkrelhigh' `kinkrellow' loglevel(`loglevel')
			}
			if "`trace'" != "" {
				forvalues k=1/`nvars' {
					CheckResults ,  target(`mat`k'') `ctrltolerance' loglevel(`loglevel') quietly : ///
						total `var`k'' if `touse' [pw=`currweight'] , over(`over`k'', nolab)
					quietly replace `mreldif`k'var' = r(mreldif) in `=`i'+1'
				}
				
			}
			if "`trimfrequency'" == "sometimes" & "`trimopts'"!="" TrimWeights `oldweight' `currweight', `trimopts' one( `one' ) over( `overlist' ) loglevel(`loglevel')
			if "`kinkfreq'" == "sometimes" & "`kinkrelhigh'`kinkrellow'"!="" ///
				ProcessKink `oldweight' `currweight', `kinkrelhigh' `kinkrellow' loglevel(`loglevel')
			
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
		
		return scalar converged = r(converged)
				
	}
	else {
		// use Mata Newton-Raphson optimization

		if "`mataoptevaltype'"=="" local mataoptevaltype d0
		
		tempname prefix allctotals scale
		GenerateCalibVars , ctotal(`ctotal') prefix(`prefix')
		local ctrlvarlist_u `r(varlist)'
		
		if inlist("`trimfrequency'", "often") {
			display as error "Warning: only trimfrequency(once|sometimes) are supported with maxentropy option"
		}
	
		// vectorize the control totals; label the matrix rows for later use to create tempvars
		MergeCtotals `ctotal'
		matrix `allctotals' = r(Merged)
		scalar `scale' = r(scale)

		// what if trimming?
		if "`trimopts'" == "" {
			mata : calibrate( "`oldweight'", "`currweight'", "`allctotals'", "`ctrlvarlist_u'", "DS2", `=`scale'', `mstep', `loglevel' )
			DiagnoseMataDS `rc' `currweight' "`allctotals'" "`ctrlvarlist_u'"
			return scalar converged = `converged'
		}
		else {
			/* DS6 does not seem to work
			// create the trim maxima and minima
			tempvar lower center upper
			GenerateTrimLimits `lower' `center' `upper' if `touse' , ///
				`trimloabs' `trimlorel' `trimhiabs' `trimhirel' scale(`=`scale'') oldweight(`oldweight')
			mata : calibrate( "`oldweight'", "`currweight'", "`allctotals'", "`ctrlvarlist_u'", "DS6", `=`scale'', `mstep, `loglevel', "", "", ., ., "`lower' `center' `upper'")
			DiagnoseMataDS `rc' `currweight' "`allctotals'" "`ctrlvarlist_u'"
			*/	
			
			forvalues i=1/`iterate' {
				quietly replace `prevweight' = `currweight'
				mata : calibrate( "`prevweight'", "`currweight'", "`allctotals'", "`ctrlvarlist_u'", "DS2", `=`scale'', `mstep', `loglevel' )
				if "`trace'" != "" {
					forvalues k=1/`nvars' {
						CheckResults ,  target(`mat`k'') `ctrltolerance' loglevel(`loglevel') quietly : ///
							total `var`k'' if `touse' [pw=`currweight'] , over(`over`k'', nolab)
						quietly replace `mreldif`k'var' = r(mreldif) in `=`i'+1'
					}
					
				}
				if "`trimfrequency'" == "sometimes" & "`trimopts'"!="" {
					TrimWeights `oldweight' `currweight', `trimopts' one( `one' ) over( `overlist' ) loglevel(`loglevel')
				}
				local anytrim = `r(anytrim)'
				CheckConvergence `prevweight' `currweight' if `touse', `tolerance'
				local currobj = r(maxreldif)
				if `loglevel' > 0 di _n
				display "{txt} Meta-iteration `i', max rel difference of raked weights = {res}" `currobj'
				if r(converged) continue, break
				if `converged' & !`anytrim' continue, break
				if `currobj' > `prevobj' & `i' > 2 {
					display "{err}Warning: raking procedure appears diverging"
					if "`divergence'" != "nodivergence" continue, break
				}
				local prevobj = `currobj'
			}
			
			return scalar converged = r(converged) | (`converged' & !`anytrim')
			
		}
		
		* qui replace `currweight' = `currweight'*`scale'
	}

	if !return(converged) {
		display "{err}Warning: raking procedure did not converge; check the `generate' variable"
	}

	if "`trimfrequency'" == "once" & "`trimopts'"!="" TrimWeights `oldweight' `currweight', `trimopts' one( `one' ) over( `overlist' )	
	if "`kinkfreq'" == "once" ProcessKink `oldweight' `currweight', `kinkrelhigh' `kinkrellow' loglevel(`loglevel')
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
		matrix `pass' = r(reldif)
		return matrix reldif`k' = `pass'
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

	* DEBUGGING
	* set trace on	

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
		}
		local theweight `exp'
	}
	else {
		generate `double' `generate' = `currweight' if `touse'
		label variable `generate' "Raked weights"
		local theweight `generate'
	}

	if "`meta'" != "" {
	
		note `theweight' : Raking controls used: `ctotal'
		forvalues k=1/`nvars' {
			char `theweight'[`mat`k''] `=return(mreldif`k')'
			char `theweight'[totalof`k'] `var`k''
			char `theweight'[over`k'] `over`k''
			char `theweight'[mat`k'] `mat`k''
		}
		
		tempname hash1
		
		mata : st_view(w=.,.,"`theweight'")
		mata : st_numscalar("`hash1'",hash1(w,.,2) )
		
		char `theweight'[hash1] `=scalar(`hash1')'
		
		foreach trimpar in trimfrequency trimhiabs trimloabs trimhirel trimlorel kinkrelhigh kinkrellow kinkfrequency {
			if "``trimpar''" != "" char `theweight'[`trimpar'] ``trimpar''
		}
	
		if length(`"`0'"')<240 char `theweight'[command] `=itrim(`"`0'"')'
		else char `theweight'[command] `0'

	}
	char `theweight'[converged] `=return(converged)'
	char `theweight'[maxctrl] `mrdmax'
	char `theweight'[objfcn] `currobj'
	char `theweight'[source] `exp'
	
	if `badcontrols' {
		note `theweight' : `whicharebad' total(s) did not match when creating this variable
	}
		
	return local ctotal `ctotal'

	end // of ipfraking

// orphan?
program GenerateTrimLimits

	syntax namelist [if] , scale(real) oldweight(varname numeric) ////
		[trimhirel(real 1e100) trimhiabs(real 1e100) trimlorel(real 0) trimloabs(real 0)]

	marksample touse
	tokenize `namelist'
	local lower `1'
	local center `2'
	local upper `3'
	
	quietly {
		gen double `lower' = 0 if `touse'
		if "`trimloabs'" != "" replace `lower' = max(`lower',`trimloabs'/`scale') if `touse'
		if "`trimlorel'" != "" replace `lower' = max(`lower',`trimlorel'*`oldweight'/`scale') if `touse'
		gen double `upper' = 1e20 if `touse'
		if "`trimhiabs'" != "" replace `upper' = min(`upper',`trimhiabs'/`scale') if `touse'
		if "`trimhirel'" != "" replace `upper' = min(`upper',`trimhirel'*`oldweight'/`scale') if `touse'
		gen double `center' = sqrt((`lower'+1000*c(epsdouble))*`upper')
	}
	
	noi sum `lower' `center' `upper'

end // of GenerateTrimLimits

program define MergeCtotals, rclass
	tokenize `0'
	tempname merged
	while "`1'" != "" {
		mat `merged' = nullmat(`merged'), `1'
		mac shift
	}
	tempname scale
	mata : st_numscalar("`scale'",sum(st_matrix("`merged'")))
	scalar `scale' = `scale' / (_N * `: word count `0'')
	matrix `merged' = `merged' / `scale'
	return matrix Merged `merged'
	return scalar scale = `scale'
end // of MergeCtotals

program define DiagnoseMataDS
	args rc currweight allctotals ctrlvarlist_u
	
	if `rc'==0 exit
	else if `rc' == 5701 {
		// number of calibration targets is not the same as number of calibration variables\n")
		matrix list `allctotals'
		sum `ctrlvarlist_u'
		di "{txt}Number of control totals        = {res}`= colsof(`allctotals')'"
		di "{txt}Number of calibration variables = {res}`: word count `ctrlvarlist_u''"
	}

end

program define KinkError
	syntax , [high low range freq every abs rel]
	if "`high'`low'"!= "" di as err "kink`abs'`rel'`high'`low'() must be specified as kink`abs'`rel'`high'`low'(cutoff slope)"
	if "`range'"!="" di as err "where the cutoff > 0 and 0 < slope < 1"
	if "`freq'" != "" di as err `"kinkfrequency can be "often", "sometimes" or "once""'
	if "`every'" != "" di as err "kinkat must be a list of positive integers"
	exit 198
end // of KinkError

program define CheckKinkOptions

	syntax varlist(numeric min=3 max=3), [ ///
		kinkrelhigh(numlist min=2 max=2 >=0) ///
		kinkrellow(numlist min=2 max=2 >=0) ///
		kinkfrequency(string) trim(string) loglevel(integer 0) * ]
/*
		
		
*/
	
	local kinkhigh `kinkabshigh' `kinkrelhigh'
	local kinklow `kinkabslow' `kinkrellow'

	if `loglevel' < 2 local show2 quietly
	if `loglevel' < 1 local show1 quietly
	
	if "`kinkhigh'`kinklow'"!="" & trim("`trim'")!="" {
		di as err "kink and trim options cannot be specified together"
		exit 198
	}
	
	// check kinkfrequency
	if "`kinkfrequency'" == "" local kinkfrequency sometimes
	
	if !inlist("`kinkfrequency'","often","sometimes","once") KinkError, freq
	
	if "`kinkhigh'`kinklow'"=="" & "`kinkfrequency'"!="" {
		di as err "Warning: kinkfrequency is specified without any of kink*high() or kink*low() options; ignored"
		c_local kinkfreq
		exit 0
	}
	// dirty trick: push back kinkfrequency
	c_local kinkfreq `kinkfrequency'

	// the case-specific limits
	local atlow  : word 1 of `varlist'
	local athigh : word 2 of `varlist'
	local oldweight : word 3 of `varlist'

	// kink[abs|rel][high|low]high must be of the format # #
	// where the first # is the cutoff value
	// and the second # is the slope after it
	if "`kinkrelhigh'"!="" {
	
		tokenize `kinkrelhigh'
		
		local hicutoff `1'
		cap assert `hicutoff' > 0
		if _rc KinkError , high rel range
		
		// deal with the second argument = slope
		local hislope `2'
		cap confirm number `hislope'
		if _rc KinkError , high rel
		
		if !inrange(`hislope',0,1) {
			di as err "Warning: slope of kinkrelhigh is outside (0,1) range, results may be weird"
		}	
	}
	else {
		local hicutoff = .z
	}

	// kinklow must be of the format # #
	// where the first # is the cutoff value
	// and the second # is the slope after it
	if "`kinkrellow'"!="" {
		tokenize `kinkrellow'

		// deal with the first argument = cutoff
		local lowcutoff `1'

		cap confirm number `lowcutoff'
		if _rc KinkError , low rel
		cap assert `lowcutoff' > 0 
		if _rc KinkError , low rel range
		
		// deal with the second argument = slope
		local lowslope `2'
		cap confirm number `lowslope'
		if _rc KinkError , low rel
		
		if !inrange(`lowslope',0,1) {
			di as err "Warning: slope of kinkrellow is outside (0,1) range, results may be weird"
		}
		
		if `hicutoff' < `lowcutoff' {
			di as err "the cutoff of kinkrelhigh() is lower than the cutoff of kinkrellow() which is not allowed"
			exit 7
		}
		
	}

end // of CheckKinkOptions

program define ProcessKink, rclass

	syntax varlist(numeric min=2 max=2) [if] [in], ///
		[kinkrelhigh(numlist min=2 max=2 >=0) kinkrellow(numlist min=2 max=2 >=0) loglevel(real 0)]
	
	marksample touse, novarlist
	
	tokenize `varlist'
	local oldweight `1'
	local currweight `2'
	
	local kinkcount 0
	
	if `loglevel' == 0 local qui qui
	
	// parse the kinkhigh option
	if "`kinkrelhigh'"!="" {
		tokenize `kinkrelhigh'

		local hicutoff `1'
		local hislope `2'
		
		qui count if (`currweight' > `oldweight' * `hicutoff') & `touse'
		local kinkcount = `kinkcount' + r(N)
		
		if `loglevel' > 1 {
			di "{txt}Found {res}`=r(N)' {txt}observations to kink:"
			sum `currweight' (`currweight' > `oldweight' * `hicutoff') & `touse'
		}
		
		`qui' replace `currweight' = `oldweight'*`hicutoff' + (`currweight' - `oldweight'*`hicutoff')*`hislope' ///
			if (`currweight' > `oldweight' * `hicutoff') & `touse'

		if `loglevel' > 1 {
			di "{txt}Updated to:"
			sum `currweight' if `currweight' > `hicutoff' & `touse'
		}
		
	}

	if "`kinkrellow'"!="" {
		tokenize `kinkrellow'
		local lowcutoff `1'
		local lowslope `2'
		
		qui count if (`currweight' < `lowcutoff'*`oldweight') & `touse'
		local kinkcount = `kinkcount' + r(N)

		if `loglevel' > 1 {
			di "{txt}Found {res}`=r(N)' {txt}observations to kink:"
			sum `currweight' if `(`currweight' < `lowcutoff'*`oldweight') & `touse'
		}
		`qui' replace `currweight' = `lowcutoff'*`oldweight' - (`lowcutoff'*`oldweight' - `currweight')*`lowslope' ///
			if (`currweight' < `lowcutoff'*`oldweight') & `touse'
		if `loglevel' > 1 {
			di "{txt}Updated to:"
			sum `currweight' if `currweight' < `lowcutoff' & `touse'
		}
	}
	
	return scalar anykink = sign( `kinkcount' )
	
end // of ProcessKink

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
	
	tempname mcopy rd

	matrix `rd' = J(1,`=colsof(`target')',.)
	forvalues k=1/`=colsof(`target')' {
		matrix `rd'[1,`k'] = reldif( `bb'[1,`k'], `target'[1,`k'] )
	}
	matrix colnames `rd' = `: colfullnames `target''
	matrix rownames `rd' = `: rownames `target''
	matrix rownames `bb' = `: rownames `target''
	
	matrix `mcopy' = `target'

	return scalar mreldif = mreldif(`bb',`target')
	return matrix target = `mcopy'
	return matrix result = `bb'
	return matrix reldif = `rd'
	

end // of CheckResults

program define PropAdjust

	syntax varname(numeric) [if] [in], target(namelist min=1 max=1) control(varname numeric) over(varname numeric) [alpha(real 1) loglevel(int 0)]
	
	local currweight `varlist'

	marksample touse

	/*
	capture total `control' [pw=`currweight'] if `touse', over( `over', nolab )
	if _rc {
		display as error "cannot compute controls for `control' over `over' with the current weights"
		exit 301
	}
	tempname bb
	matrix `bb' = e(b)

	*/
	qui levelsof `over' if `touse', local( allover )
	forvalues k=1/`: word count `allover'' {
		sum `control' if `touse' & `over' == `: word `k' of `allover'' [aw=`currweight'], mean
		tempname ctrl`k'
		scalar `ctrl`k'' = r(sum)
	}
	
	if `loglevel' < 2 local quietly quietly
	
	if `: word count `allover'' == 1 {
		if scalar(`ctrl1') == 0 {
			display as error "Warning: division by zero weighted total encountered with `control' control"
		}
		if `loglevel' > 1 display "{txt}Control {res}`control'{txt}: {res}" %10.0g `=`target'[1,1]' "{txt}/{res}" %10.0g scalar(`ctrl1') " " _c
		`quietly' replace `currweight' = `currweight' * `target'[1,1] / scalar(`ctrl1') if `touse' & `currweight' != 0 & `control' != 0
	}
	else {
		// cycle over categories
		forvalues k=1/`= colsof(`target')' {
			capture assert "`: word `k' of `allover''" == "`: word `k' of `: colnames `target' ''"
			if _rc {
				// we've done the diagnostic before, so this should not be happening
				display as error "categories mismatch in PropAdjust"
				di "{txt}categories of {res}`over'{txt}: {res}`allover'"
				matrix list `target'
				exit 111
			}
			if scalar(`ctrl`k'') == 0 {
				display as error "Warning: division by zero weighted total encountered with `control' control with `over' == `k'"
			}
			
			if `loglevel' > 1 display "{txt}Control {res}`over'{txt}, category {res}`: word `k' of `allover''{txt}: {res}" ///
				%10.0g `=`target'[1,`k']' "{txt}/{res}" %10.0g scalar(`ctrl`k'') " " _c
			`quietly' replace `currweight' = `currweight' * (`target'[1,`k'] / scalar(`ctrl`k''))^`alpha' if `touse' & `over' == `: word `k' of `allover'' & `currweight'!=0
		}
	}
	
end // of PropAdjust


program define ControlCheckParse

	syntax namelist , one( varname ) [ touse(varname) loglevel(int 0) ]

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
			capture total `var`k'' if `touse', over( `over`k'', nolab )
			if _rc {
				display as error "`var`k'' and `over`k'' variables are not compatible"
				exit 111
			}
			matrix `b' = e(b)
			if "`: colfullnames `mat`k'''" != "`: colfullnames `b''" {
				display as error "categories of `over`k'' do not match in the control `mat`k'' and in the data (nolab option)"
				local matknames : colfullnames `mat`k''
				local bnames    : colfullnames `b'
				display as error "This is what `mat`k'' gives: "  _n as res "  `matknames'"
				display as error "This is what I found in data: " _n as res "  `bnames'"
				display as error "This is what `mat`k'' has that data don't: "  _n as res "  `: list matknames - bnames'"
				display as error "This is what data have that `mat`k'' doesn't: "  _n as res "  `: list bnames - matknames'"				
				exit 111
			}
			
			quietly count if missing(`over`k'') & `touse'
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

program define TrimWeights, rclass

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
		`quietly' replace `newweight' = `oldweight' * `trimhirel' if `newweight' > `oldweight' * `trimhirel' & !mi(`newweight')
		`quietly' replace `newweight' = `oldweight' * `trimlorel' if `newweight' < `oldweight' * `trimlorel'
		
		// check ranges
		`quietly' replace `newweight' = `trimhiabs' if `newweight' > `trimhiabs' & !mi(`newweight')
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
		return scalar anytrim = 1
	}
	else return scalar anytrim = 0
	
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
	capture noisily ipfraking [pw=finalwgt], ctotal( total_sex total_race ) generate( rweight9 ) kinkhigh(blah)
	assert _rc == 198
	capture noisily ipfraking [pw=finalwgt], ctotal( total_sex total_race ) generate( rweight9 ) kinkhigh(200)
	assert _rc == 198
	capture noisily ipfraking [pw=finalwgt], ctotal( total_sex total_race ) generate( rweight9 ) kinkhigh(-5 5)
	assert _rc == 198
	
	
	
	// end of checks
	set more `cmore'
	
	restore
	
	di _n "{txt}ALL TESTS PASSED."
	
end // of SelfCheck


	
program define GenerateCalibVars , rclass

	syntax [if] [in], ctotal( string ) prefix( string )
	
	marksample touse, novarlist

	* ctotal has been checked already, can be assumed good
	tokenize `ctotal'
	
	local k : word count `ctotal'
	
	forvalues i=1/`k' {
		local p = colsof(``i'')
		local thisvar : rownames ``i''
		local thesecats : colnames ``i''
		if `p' == 1 {
			* single continuous variable
			gen double `prefix'_`i' = `thisvar' if `touse'
			local calibvars `calibvars' `prefix'_`i'
		}
		else {
			forvalues j=1/`p' {
				local thisval : word `j' of `thesecats'
				gen byte `prefix'_`i'_`j' = (`thisvar'==`thisval') if `touse'
				local calibvars `calibvars' `prefix'_`i'_`j'
			}
		}	
	}
	
	// quality check
	foreach x of varlist `calibvars' {
		qui count if `x' != 0 & !mi(`x')
		assert r(N)>0
	}
	
	return local varlist `calibvars'
	
end // of GenerateCalibVars


mata

// D-S case 2: generalized raking
// distance function G(w,d)
real vector G_DS2( real vector w, real vector d) {
	return( w :* ln( w :/ d ) :- w :+ d )
}
// derivative g(w,d)
real vector g_DS2( real vector w, real vector d) {
	return( ln( w:/d ) )
}
// inverse to g(w,d) sans d
real vector F_DS2( real colvector q, real colvector u ) {
	return( exp( q:*u ) )
}
// derivative of F
real vector dF_DS2_du( real vector q, real vector u ) {
	return( q :* exp( q:*u ) )
}

// D-S case 6: with trimming
real vector F_DS6( real colvector q, real colvector u, real colvector lower, real colvector upper, real colvector center) {
	real vector midpoint, numer, denom;
	
	midpoint = ( upper :- lower ) :/ ( (center :- lower) :* (upper :- center) )
	numer = lower :* (upper:-center) + upper :* (center:-lower) :* exp( midpoint :* q :* u )
	denom = (upper:-center) + (center:-lower) :* exp( midpoint :* q :* u )

	assert( denom != 0 )
	
	return( numer :/ denom )
}
// derivative of F
real vector dF_DS6_du( real colvector q, real colvector u, real colvector lower, real colvector upper, real colvector center) {

	real vector midpoint, numer, denom, d_numer, d_denom;
	
	midpoint = ( upper :- lower ) :/ ( (center :- lower) :* (upper :- center) )
	
	numer = lower :* (upper:-center) + upper :* (center:-lower) :* exp( midpoint :* q :* u )
	denom = (upper:-center) + (center:-lower) :* exp( midpoint :* q :* u )
	d_numer = midpoint :* q :* upper :* (center:-lower) :* exp( midpoint :* q :* u )
	d_denom = midpoint :* q :*  (center:-lower) :* exp( midpoint :* q :* u )

	assert( denom != 0 )	
	
	return( ( (d_numer :* denom) :- (numer :* d_denom) ):/( denom :* denom ) )
}

real vector F_hyperb( real colvector q, real colvector u, real colvector upper) {
	// horizontal asymptote at upper
	// passes through (0,1)
	// O(x) at -infty
	return( 1 )
}

// phi function
real vector phi( real rowvector lambda, pointer(real vector function) F, ///
	real matrix X, real colvector q, real colvector d, ///
	| real matrix param1, real matrix param2, real matrix param3, real matrix param4) {
	
	real vector arg, phi;

	arg = X * lambda'
	
	if      ( rows(param1)==0 ) phi = ((*F)( q, arg ) :- 1) :* X
	else if ( rows(param2)==0 ) phi = ((*F)( q, arg, param1 ) :- 1) :* X
	else if ( rows(param3)==0 ) phi = ((*F)( q, arg, param1, param2 ) :- 1) :* X
	else if ( rows(param4)==0 ) phi = ((*F)( q, arg, param1, param2, param3 ) :- 1) :* X
	else                        phi = ((*F)( q, arg, param1, param2, param3, param4 ) :- 1) :* X
	
/*
	printf("{txt}In phi routine, phi must be n x p: \n")
	phi
*/
	
	return( quadcross(1, d, phi)  )
}

// main function
void calibrate( string scalar wgtname, string scalar newwgtname, ///
	string scalar targetname, string scalar varlist, string scalar method, ///
	real scalar scale, real scalar mstep, real scalar loglevel, ///
	| string scalar tousename, string scalar qname, ///
	real scalar iter, real scalar tolerance, ///
	string scalar trimnames ///
) {

	real rowvector target, diff, delta, dtotal;
	real scalar p, converged;
	real matrix outer, invouter, step;
	string vector varnames;

	// all the relevant views; use st_data as they should not change
	varnames = tokens( varlist )
	if ("tousename"!="") {
		X = st_data( ., varnames, tousename )
		d = st_data( ., wgtname,  tousename )
		if (qname!="") st_view( q=., ., qname,    tousename )
		else q=J(rows(X),1,1)
	}
	else {
		X = st_data( ., varnames)
		d = st_data( ., wgtname)
		if (qname!="") st_view( q=., ., qname)
		else q=J(rows(X),1,1)
	}
	d = d / scale
		
	// constant matrices
	target = st_matrix( targetname )
	dtotal = quadcolsum( d :* X )

	// check the calibration variables
	if ( cols( X ) != cols( target ) ) {
		printf("{err}number of calibration targets is not the same as number of calibration variables\n")
		st_local( "rc", "5701" )
		st_local( "converged", "0" )
		return
	};

	// check the trimming parameters for DS6 calibration
	method
	if (method == "DS6") {
		trimnames
		if (trimnames=="" ) {
			printf("{err}must specify trimming parameters with DS6\n")
			st_local( "rc", "5702" )
			st_local( "converged", "0" )
			return		
		}
		else {
			trimvars = tokens(trimnames)
			trimvars
			if (cols(trimvars)==3) {
				if ("tousename"!="") {
					lower  = st_data(.,trimvars[1], tousename)
					center = st_data(.,trimvars[2], tousename)
					upper  = st_data(.,trimvars[3], tousename)
				}
				else {
					lower  = st_data(.,trimvars[1])
					center = st_data(.,trimvars[2])
					upper  = st_data(.,trimvars[3])
				}
			}
			else {
				printf("{err}incorrect number of trimming parameters in DS6\n")
				st_local( "rc", "5703" )
				st_local( "converged", "0" )
				return		
			}
		}
	};

	// default values
	if ( iter == . | rows(iter)==0 ) iter=100;
	if ( tolerance == . | rows(tolerance)==0 ) tolerance = 1e-7;
	
	p = cols( varnames )
	converged = 0
	
	// initial value
	lambda = J(1,p,0)

	// for(k=1;k<=iter;k++) {
		
		tmtd = target-dtotal
		
		/*
		if (method == "DS6") {
			diff = target - dtotal - phi( lambda, &F_DS6(), X, q, d, lower, upper, center)  // DS6
			outer  = quadcross( X, d :* dF_DS6_du( q, X*lambda', lower, upper, center ), X ) // DS6
		}
		else if (method == "DS2") {
			diff = target - dtotal - phi( lambda, &F_DS2(), X, q, d )  // DS2
			outer  = quadcross( X, d :* dF_DS2_du( q, X*lambda' ), X ) // DS2
		}
		invouter = invsym( outer )
		delta = mstep * diff * invouter'
		lambda = lambda + delta
		
		printf("{txt}Iteration {res}%2.0f{txt}, |delta| = {res}%9.6f{txt}, |lambda| = {res}%9.6f\n",k,norm(delta), norm(lambda) )
		if (loglevel>0) lambda
		if ( method == "DS6" & norm( lambda ) > 0.5*ln(maxdouble()) ) {
			printf("{err}Warning: Lagrange multipliers are pusing the numerical accuracy; convergence may be impaired\n")
		}
		
		if ( norm( delta ) < tolerance * min( (1, norm( lambda ) ) ) ) {
			converged = 1
			break
		}
		*/
		
		if (method == "DS6") {
			// not implemented
		}
		else if (method == "DS2") {
			S = optimize_init()
			optimize_init_evaluator(S, &obj_DS2() )
			optimize_init_which(S, "min")
			evaltype = st_local( "mataoptevaltype" )
			optimize_init_evaluatortype(S, evaltype)
			/*
			if (evaltype=="d1debug") {
				optimize_init_tracelevel(S, "gradient")
			};
			*/
			optimize_init_technique(S, "nr")
			optimize_init_params(S, lambda)
			optimize_init_narguments(S,4)
			optimize_init_argument(S,1,tmtd)
			optimize_init_argument(S,2,X)
			optimize_init_argument(S,3,q)
			optimize_init_argument(S,4,d)
			optimize_init_conv_ptol(S,1e-14)
			optimize_init_conv_vtol(S,1e-24)
			optimize_init_conv_ignorenrtol(S, "on")
			optimize_init_singularHmethod(S, "hybrid")
			optimize_evaluate(S)
			if (_optimize(S)==0) {
				lambda = optimize_result_params(S)
				lambda
				converged = 1
			}
			else {
				converged = 0
			}
		}
		
	// }
	
	// the only thing that is to be changed are the new weights; hence view rather than st_data
	st_view( w=., ., newwgtname, tousename )
	if (converged) {	
		if (method == "DS6") {
			if ( norm(lambda) < ln( maxdouble() ) ) {
				w[,] = d :* F_DS6( q, X*lambda', lower, upper, center  )
			}
			else {
				printf("{err}The procedure resulted in numeric overflow; missing weights will be returned.\n")
				w[,] = J( rows(w), 1, . )
			}
		}
		else if (method == "DS2") {
			w[,] = d :* F_DS2( q, X*lambda' )
		};
	}
	else {
		printf("{err}The procedure did not seem to have converged; missing weights will be returned.\n")
		w[,] = J( rows(w), 1, . )
	}

	w[,] = w*scale
	
	st_local( "converged", strofreal(converged) )
	st_local( "rc", "0" )
}


void obj_DS2(todo, lambda, tmtd, X, q, d, v, g, H) 
{

	phi = (F_DS2( q, X * lambda' ) :- 1) :* X

	// this is a row vector
	diff = (tmtd - quadcross(1, d, phi)) // DS2
	
	v = norm( diff )^2

	if (todo >= 1) {
		// return the derivative
		
		// this must be a colvector
		term1 = - X * diff' 
		assert( (rows(term1) == rows(X)) & (cols(term1) == 1) )
		
		// this must be a colvector
		term2 = dF_DS2_du( q, X*lambda' )
		assert( (rows(term2) == rows(X)) & (cols(term2) == 1) )
		
		g = quadcolsum( 2 :* d :* term1 :* term2 :* X )
		
	}
}


end // of Mata




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
1.1.21  -xls2row- is added to the package
1.1.22  xls2row.sthlp is written
1.1.23  utility programs -xls2row- and -mat2do- are documented
1.1.24	some additional information on convergence is being stored
1.1.25	raking through Mata optimization of the D-S objective function Case 2
1.1.26	trimming is added to fast implementation via trimming the converged Case 2 weights and cycling over
1.1.27	check for missing values in trimming high values; mstep added to slow down the algorithm
1.1.28	total computation rewritten in terms of a much faster -sum- than -total-
1.1.29	r(reldif#) matrix is returned
1.1.30	mat2do allows -append- option
1.1.31  -meta- better interacts with -replace-
        Stata Journal R&R is completed
1.1.33	-kink- options are being added
1.1.34	-kink- scheme is rewritten as kink[abs|rel][high|low], but it seems like only kinkrel* makes sense
1.1.34.22	debugging kink options (the numbering system reflects commits in 5878 project)
1.1.34.23	better meta data for ipfraking_report
1.2.35	-rapid- options are being tinkered with
		-touse- is passed to ControlCheckParse
1.2.36	-one()- variable is passed through to ControlCheckParse; otherewise report breaks down :(
1.1.xx	-trim- options are refactored through -kink- options

*/
