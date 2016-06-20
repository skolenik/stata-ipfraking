*! whatsmoe : margin of error : Stas Kolenikov skolenik at gmail.com
program define whatsmoe, rclass
	
	syntax anything(name = n), [p(numlist) df(real 0) level(real 0)]
	
	if "`p'" == "" local p 0.1 0.5
	
	confirm number `n'
	
	if `df' == 0 local df = `n' - 1
	
	if `level' == 0 local level = c(level)
	
	* header
	di _n "{txt}  Base p" _col(10) "{c |}   N"  _col(20) "{c |}  d.f."  _col(30) "{c |} MOE, {res}`level'{txt}%"
	di "{txt}{dup 9:{c -}}" _col(10) "{c +}{dup 9:{c -}}"  _col(20) "{c +}{dup 9:{c -}}"  _col(30) "{c +}{dup 9:{c -}}"
	foreach thisp of numlist `p' {
	
		local moe = invttail( `df', (1-`level'/100)*0.5 ) * sqrt( `thisp'*(1-`thisp')/`n' )
		
		di "{res}" %8s "0`thisp'" _col(10) "{txt}{c |}{res}" %8s string(`n',"%8.0g") _c 
		di _col(20) "{txt}{c |}{res}" %8s string(`df',"%8.0g")  _col(30) "{txt}{c |}{res}" %6.2f 100*`moe' "{txt}%"
		
		local sp = subinstr("`thisp'","0.","",.)
		local sp = subinstr("`sp'",".","",.)
		return scalar moep`sp' = `moe'
	}
	

end
