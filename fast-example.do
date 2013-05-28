clear
set more off

mata

mata clear

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
	return(  )
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
	| string scalar tousename, string scalar qname, ///
	real scalar iter, real scalar tolerance, ///
	string scalar trimnames ///
) {

	real rowvector target, diff, delta, dtotal;
	real scalar p, converged;
	real matrix outer, invouter;
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

	for(k=1;k<=iter;k++) {
		
		if (method == "DS6") {
			diff = target - dtotal - phi( lambda, &F_DS6(), X, q, d, lower, upper, center)  // DS6
			outer  = quadcross( X, d :* dF_DS6_du( q, X*lambda', lower, upper, center ), X ) // DS6
		}
		else if (method == "DS2") {
			diff = target - dtotal - phi( lambda, &F_DS2(), X, q, d )  // DS2
			outer  = quadcross( X, d :* dF_DS2_du( q, X*lambda' ), X ) // DS2
		}
		invouter = invsym( outer )
		delta = diff * invouter'
		lambda = lambda + delta
		
		printf("{txt}Iteration {res}%2.0f{txt}, |delta| = {res}%9.6f{txt}, |lambda| = {res}%9.6f\n",k,norm(delta), norm(lambda) )
		lambda
		if ( method == "DS6" & norm( lambda ) > 0.5*ln(maxdouble()) ) {
			printf("{err}Warning: Lagrange multipliers are pusing the numerical accuracy; convergence may be impaired\n")
		}
		
		if ( norm( delta ) < tolerance * min( (1, norm( lambda ) ) ) ) {
			converged = 1
			break
		}
	}
	
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

	st_local( "converged", strofreal(converged) )
}


end // of Mata


sysuse auto, clear
keep if !mi( rep78 )
tab rep78, gen( rep78_ )
tab foreign, gen( for_ )

// targets
matrix T_foreign = (200, 100)
matrix colnames T_foreign = _one:0 _one:1
matrix rownames T_foreign = foreign
mat li T_foreign
matrix T_rep78 = (10, 40, 140, 60, 50 )
mat colnames T_rep78 = _one:1 _one:2 _one:3 _one:4 _one:5
mat rownames T_rep78 = rep78

// my raking
gen byte _one = 1
timer clear 16
timer on 16
ipfraking [pw=_one], ctotal( T_foreign T_rep78) gen( wgt ) nograph
timer off 16

// new raking
matrix T_all = T_rep78, T_foreign
gen cwgt2 = .
gen cwgt6 = .

timer clear 17
timer on 17
mata : calibrate( "_one", "cwgt2", "T_all", "rep78_1 rep78_2 rep78_3 rep78_4 rep78_5 for_1 for_2", "DS2" )
timer off 17

timer clear 18
timer on 18

sum cwgt2, det
gen center = r(mean)
/*
gen lower = r(p5)
gen upper = r(p95)
*/
gen lower = 2.5
gen upper = 6

mata : calibrate( "_one", "cwgt6", "T_all", "rep78_1 rep78_2 rep78_3 rep78_4 rep78_5 for_1 for_2", "DS6", "", "", ., ., "lower center upper")

timer off 18

timer list

sum *wgt*
compare wgt cwgt2

scatter cwgt* wgt, aspect(1) jitter(5 5) msize(small) || line wgt wgt, sort || , legend(off)

exit
