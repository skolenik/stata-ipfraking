*** wgtcellcollapse example

clear


* stations
input str16 station_name
	"Alewife"
	"Brookline"
	"Carmenton"
	"Dogville"
	"East End"
	"Framington"
	"Grand Junction"
	"High Point"
	"Irvingtown"
	"Johnsville"
	"King Street"
	"Limerick"
	"Moscow City"
	"Ninth Street"
	"Ontario Lake"
	"Picadilly Square"
	"Queens Zoo"
	"Redline Circle"
	"Silver Spring"
	"Toledo Town"
	"Union Station"
end

set seed 135042
gen byte station_id = sum(3+1.3*uniform())

* labels
sum station_id, mean
forvalues i=1/`=r(max)' {
	qui {
		count if station_id == `i'
		if r(N) == 1 {
			qui levelsof station_name if station_id == `i', clean
			lab def station_lbl `i' "`r(levels)'", modify
		}
	}
}
lab val station_id station_lbl
numlabel station_lbl, add

* general attraction potential
gen int size = 5 + 100*exp(rnormal()*1.6)
* everybody exits at the end of the line
replace size = size + 2345 in l


save stations, replace

sjlog using ipfr.trip.sta, replace
use stations, clear
list station_id, sep(0)
sjlog close, replace

* dayparts
expand 5
bysort station_id : gen byte daypart = _n
lab def daypart_lbl 1 "AM Peak" 2 "Midday" 3 "PM Reverse Peak" 4 "Night" 5 "Weekend"
lab val daypart daypart_lbl

* boardings are proportonal to size, with some modifications
gen int geton = size * exp( rnormal()*0.6 + 3*(daypart==1) + 2*(daypart==3) )

* alightings are proproprtional to size conditional on boarding
rename station_id board_id
drop size
drop station_name

cross using stations
rename station_id alight_id
drop station_name

* must leave at a subsequent station only
keep if alight_id > board_id

egen totsize = total(size), by(board_id daypart)
gen int trip_getoff = geton*size/totsize*(0.6+0.3*(daypart>=4))

egen t_getoff = total(trip_getoff), by(board_id daypart)
bysort board_id daypart (alight_id) : replace trip_getoff = trip_getoff + geton - t_getoff if _n == _N
drop t_getoff

* total alightings by daypart
egen getoff = total(trip_getoff), by(alight_id daypart)

* population
drop size totsize 

sort board_id daypart alight_id
list, sepby(board_id daypart)

sort alight_id daypart board_id 
list, sepby(alight_id daypart)

sum trip_getoff
di r(sum)

* control totals basic interaction
gen dpston_main = daypart*100 + board_id
total geton if alight_id == 73, over(dpston_main)
matrix dpston_main = e(b)
mat coleq dpston_main = _one
mat rowname dpston_main = dpston

gen dpstoff_main = daypart*100 + alight_id
total trip_getoff, over(dpstoff_main)
matrix dpstoff_main = e(b)
mat coleq dpstoff_main = _one
mat rowname dpstoff_main = dpstoff

mata : sum(st_matrix("dpston_main"))
mata : sum(st_matrix("dpstoff_main"))

save trip_population, replace

file open towr using pop.size.tex, text write replace
sum trip_getoff
file write towr %5.0f (`=r(sum)')
file close towr


sjlog using ipfr.trip.pop, replace
use trip_population, clear
table board_id daypart if alight_id == 73, c(mean geton) cellwidth(10)
table alight_id daypart if board_id==3, c(mean getoff) cellwidth(10)
sjlog close, replace

* sample
keep board_id alight_id daypart trip_getoff
expand trip_getoff 
drop if trip_getoff == 0
drop trip_getoff

gen propensity = 0.06 ///
	- 0.015*(daypart==1) /// less likely to fill in rush hour
	- 0.1/sqrt(40+alight_id-board_id) /// trip duration -- easier to fill on longer trips

gen response = uniform() < propensity

tab board_id daypart if response
tab alight_id daypart if response

save response_propensity, replace

keep if response == 1
keep board_id alight_id daypart
gen int personid = _n

save trip_sample, replace

file open towr using sample.size.tex, text write replace
count
file write towr %4.0f (`=r(N)')
file close towr

sjlog using ipfr.trip.samp, replace
use trip_sample, clear
tab board_id daypart
tab alight_id daypart
sjlog close, replace

* this raking won't work
gen byte _one = 1
gen int dpston = daypart*100 + board_id
gen int dpstoff= daypart*100 + alight_id
cap noi ipfraking [pw=_one], ctotal(dpston_main dpstoff_main) gen(raked_weight)
cap noi ipfraking [pw=_one], ctotal(dpstoff_main dpston_main) gen(raked_weight)

* wgtcelladjust example: naive run just trying to get everything to the cell size of 20

* define collapsing rules
sjlog using ipfr.trip.rule, replace
use trip_sample, clear
wgtcellcollapse sequence , var(daypart) from(2 3 4) depth(3)
levelsof board_id, local(stations_on)
levelsof alight_id, local(stations_off)
local all_stations : list stations_on | stations_off
wgtcellcollapse sequence , var(board_id alight_id) from(`all_stations') depth(20)
sjlog close, replace

file open towr using station.nrules.tex, text write replace
file write towr %6.0f (`: char board_id[nrules]')
file close towr

* collapse: attempt 1
cap drop dpston
cap drop dpstoff
sjlog using ipfr.trip.att1, replace
wgtcellcollapse collapse, variables(daypart board_id) mincellsize(20) ///
	generate(dpston) saving(dpston.do) replace run
return list
wgtcellcollapse collapse, variables(daypart alight_id) mincellsize(20) ///
	generate(dpstoff) saving(dpstoff.do) replace run
return list
sjlog close, replace

* raking
	
exit
