*** Automatically created on 13 Nov 2017 at 10:49:04
* Source syntax: wgtcellcollapse collapse , variables(daypart board_id) mincellsize(1)         zeroes(39 40 44 49 55 60)         generate(dpston3) saving(dpston3.do) replace run

generate long dpston3 = (daypart)*1000000 + board_id

label variable dpston3 "Long ID of the interaction"
format dpston3 %12.0f
char dpston3[sources] daypart board_id
char dpston3[max] 324200269
replace dpston3 = 1024950 if inlist(dpston3, 1000049, 1000050)
char dpston3[rule1] 1000049:1000050=1024950
replace dpston3 = 2024044 if inlist(dpston3, 2000040, 2000044)
char dpston3[rule2] 2000040:2000044=2024044
replace dpston3 = 2024950 if inlist(dpston3, 2000049, 2000050)
char dpston3[rule3] 2000049:2000050=2024950
replace dpston3 = 2025560 if inlist(dpston3, 2000055, 2000060)
char dpston3[rule4] 2000055:2000060=2025560
replace dpston3 = 4023639 if inlist(dpston3, 4000036, 4000039)
char dpston3[rule5] 4000036:4000039=4023639
replace dpston3 = 4024044 if inlist(dpston3, 4000040, 4000044)
char dpston3[rule6] 4000040:4000044=4024044
replace dpston3 = 4024950 if inlist(dpston3, 4000049, 4000050)
char dpston3[rule7] 4000049:4000050=4024950
replace dpston3 = 4025355 if inlist(dpston3, 4000053, 4000055)
char dpston3[rule8] 4000053:4000055=4025355
replace dpston3 = 4054960 if inlist(dpston3, 4024950, 4000053, 4000055, 4000060)
char dpston3[rule9] 4024950:4000053:4000055:4000060=4054960
replace dpston3 = 5023940 if inlist(dpston3, 5000039, 5000040)
char dpston3[rule10] 5000039:5000040=5023940
replace dpston3 = 5024950 if inlist(dpston3, 5000049, 5000050)
char dpston3[rule11] 5000049:5000050=5024950
replace dpston3 = 5054960 if inlist(dpston3, 5024950, 5025355, 5000060)
char dpston3[rule12] 5024950:5025355:5000060=5054960

char dpston3[nrules] 12

*** Automatically created on 13 Nov 2017 at 10:49:16
* Source syntax: wgtcellcollapse collapse , variables(daypart board_id) mincellsize(20)         strict feed(dpston3) saving(dpston3.do) append run

confirm variable dpston3

replace dpston3 = 2033944 if inlist(dpston3, 2000039, 2024044)
char dpston3[rule13] 2000039:2024044=2033944
replace dpston3 = 2034953 if inlist(dpston3, 2000053, 2024950)
char dpston3[rule14] 2000053:2024950=2034953
replace dpston3 = 2054960 if inlist(dpston3, 2034953, 2025560)
char dpston3[rule15] 2034953:2025560=2054960
replace dpston3 = 3023940 if inlist(dpston3, 3000039, 3000040)
char dpston3[rule16] 3000039:3000040=3023940
replace dpston3 = 4043644 if inlist(dpston3, 4023639, 4024044)
char dpston3[rule17] 4023639:4024044=4043644
replace dpston3 = 4064760 if inlist(dpston3, 4000047, 4054960)
char dpston3[rule18] 4000047:4054960=4064760
replace dpston3 = 5021824 if inlist(dpston3, 5000018, 5000024)
char dpston3[rule19] 5000018:5000024=5021824
replace dpston3 = 5033944 if inlist(dpston3, 5000044, 5023940)
char dpston3[rule20] 5000044:5023940=5033944
replace dpston3 = 5064760 if inlist(dpston3, 5000047, 5054960)
char dpston3[rule21] 5000047:5054960=5064760
replace dpston3 = 2043644 if inlist(dpston3, 2000036, 2033944)
char dpston3[rule22] 2000036:2033944=2043644
replace dpston3 = 4103660 if inlist(dpston3, 4043644, 4064760)
char dpston3[rule23] 4043644:4064760=4103660
replace dpston3 = 5025355 if inlist(dpston3, 5000053, 5000055)
char dpston3[rule24] 5000053:5000055=5025355
replace dpston3 = 2021824 if inlist(dpston3, 2000018, 2000024)
char dpston3[rule25] 2000018:2000024=2021824
replace dpston3 = 3033944 if inlist(dpston3, 3000044, 3023940)
char dpston3[rule26] 3000044:3023940=3033944
replace dpston3 = 4021824 if inlist(dpston3, 4000018, 4000024)
char dpston3[rule27] 4000018:4000024=4021824
replace dpston3 = 5020102 if inlist(dpston3, 5000001, 5000002)
char dpston3[rule28] 5000001:5000002=5020102
replace dpston3 = 5026268 if inlist(dpston3, 5000062, 5000068)
char dpston3[rule29] 5000062:5000068=5026268
replace dpston3 = 2020102 if inlist(dpston3, 2000001, 2000002)
char dpston3[rule30] 2000001:2000002=2020102
replace dpston3 = 2030108 if inlist(dpston3, 2000008, 2020102)
char dpston3[rule31] 2000008:2020102=2030108
replace dpston3 = 2053044 if inlist(dpston3, 2000030, 2043644)
char dpston3[rule32] 2000030:2043644=2053044
replace dpston3 = 3024950 if inlist(dpston3, 3000049, 3000050)
char dpston3[rule33] 3000049:3000050=3024950
replace dpston3 = 5093960 if inlist(dpston3, 5033944, 5064760)
char dpston3[rule34] 5033944:5064760=5093960
replace dpston3 = 1023940 if inlist(dpston3, 1000039, 1000040)
char dpston3[rule35] 1000039:1000040=1023940
replace dpston3 = 3025560 if inlist(dpston3, 3000055, 3000060)
char dpston3[rule36] 3000055:3000060=3025560
replace dpston3 = 4031826 if inlist(dpston3, 4000026, 4021824)
char dpston3[rule37] 4000026:4021824=4031826
replace dpston3 = 5031826 if inlist(dpston3, 5000026, 5021824)
char dpston3[rule38] 5000026:5021824=5031826
replace dpston3 = 2026268 if inlist(dpston3, 2000062, 2000068)
char dpston3[rule39] 2000062:2000068=2026268
replace dpston3 = 2074968 if inlist(dpston3, 2054960, 2026268)
char dpston3[rule40] 2054960:2026268=2074968
replace dpston3 = 4020102 if inlist(dpston3, 4000001, 4000002)
char dpston3[rule41] 4000001:4000002=4020102

* skipping dpston3 == 4025355; 
* no good collapsing rule found for board_id == 25355
* however rule(s) 2 3 5 may be used for daypart


* skipping dpston3 == 5025355; 
* no good collapsing rule found for board_id == 25355

replace dpston3 = 2031826 if inlist(dpston3, 2000026, 2021824)
char dpston3[rule42] 2000026:2021824=2031826
replace dpston3 = 1025560 if inlist(dpston3, 1000055, 1000060)
char dpston3[rule43] 1000055:1000060=1025560
replace dpston3 = 4113662 if inlist(dpston3, 4000062, 4103660)
char dpston3[rule44] 4000062:4103660=4113662
replace dpston3 = 5030108 if inlist(dpston3, 5000008, 5020102)
char dpston3[rule45] 5000008:5020102=5030108
replace dpston3 = 3020102 if inlist(dpston3, 3000001, 3000002)
char dpston3[rule46] 3000001:3000002=3020102
replace dpston3 = 4123668 if inlist(dpston3, 4000068, 4113662)
char dpston3[rule47] 4000068:4113662=4123668
replace dpston3 = 5041830 if inlist(dpston3, 5000030, 5031826)
char dpston3[rule48] 5000030:5031826=5041830
replace dpston3 = 2040111 if inlist(dpston3, 2000011, 2030108)
char dpston3[rule49] 2000011:2030108=2040111
replace dpston3 = 3043644 if inlist(dpston3, 3000036, 3033944)
char dpston3[rule50] 3000036:3033944=3043644
replace dpston3 = 4041830 if inlist(dpston3, 4000030, 4031826)
char dpston3[rule51] 4000030:4031826=4041830
replace dpston3 = 1034953 if inlist(dpston3, 1000053, 1024950)
char dpston3[rule52] 1000053:1024950=1034953
replace dpston3 = 3034953 if inlist(dpston3, 3000053, 3024950)
char dpston3[rule53] 3000053:3024950=3034953
replace dpston3 = 4030108 if inlist(dpston3, 4000008, 4020102)
char dpston3[rule54] 4000008:4020102=4030108
replace dpston3 = 5103660 if inlist(dpston3, 5000036, 5093960)
char dpston3[rule55] 5000036:5093960=5103660
replace dpston3 = 3035562 if inlist(dpston3, 3000062, 3025560)
char dpston3[rule56] 3000062:3025560=3035562

char dpston3[nrules] 56

