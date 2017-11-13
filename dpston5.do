*** Automatically created on 13 Nov 2017 at 14:21:49
* Source syntax: wgtcellcollapse collapse , variables(daypart board_id) mincellsize(1)         zeroes(39 44 49 60) greedy maxcategory(99)         generate(dpston5) saving(dpston5.do) replace run

generate long dpston5 = (daypart)*1000000 + board_id

label variable dpston5 "Long ID of the interaction"
format dpston5 %12.0f
char dpston5[sources] daypart board_id
char dpston5[max] 324200269
replace dpston5 = 1024950 if inlist(dpston5, 1000049, 1000050)
char dpston5[rule1] 1000049:1000050=1024950
replace dpston5 = 2024044 if inlist(dpston5, 2000040, 2000044)
char dpston5[rule2] 2000040:2000044=2024044
replace dpston5 = 2024950 if inlist(dpston5, 2000049, 2000050)
char dpston5[rule3] 2000049:2000050=2024950
replace dpston5 = 2025560 if inlist(dpston5, 2000055, 2000060)
char dpston5[rule4] 2000055:2000060=2025560
replace dpston5 = 4033640 if inlist(dpston5, 4000036, 4000039, 4000040)
char dpston5[rule5] 4000036:4000039:4000040=4033640
replace dpston5 = 4024950 if inlist(dpston5, 4000049, 4000050)
char dpston5[rule6] 4000049:4000050=4024950
replace dpston5 = 4054960 if inlist(dpston5, 4000049, 4000050, 4000053, 4000055, 4000060)
char dpston5[rule7] 4000049:4000050:4000053:4000055:4000060=4054960
replace dpston5 = 5023940 if inlist(dpston5, 5000039, 5000040)
char dpston5[rule8] 5000039:5000040=5023940
replace dpston5 = 5024950 if inlist(dpston5, 5000049, 5000050)
char dpston5[rule9] 5000049:5000050=5024950
replace dpston5 = 5025560 if inlist(dpston5, 5000055, 5000060)
char dpston5[rule10] 5000055:5000060=5025560

char dpston5[nrules] 10

*** Automatically created on 13 Nov 2017 at 14:21:58
* Source syntax: wgtcellcollapse collapse , variables(daypart board_id) mincellsize(20)         strict feed(dpston5) saving(dpston5.do) append run

confirm variable dpston5

replace dpston5 = 2033944 if inlist(dpston5, 2000039, 2024044)
char dpston5[rule11] 2000039:2024044=2033944
replace dpston5 = 2034953 if inlist(dpston5, 2000053, 2024950)
char dpston5[rule12] 2000053:2024950=2034953
replace dpston5 = 2054960 if inlist(dpston5, 2034953, 2025560)
char dpston5[rule13] 2034953:2025560=2054960
replace dpston5 = 3023940 if inlist(dpston5, 3000039, 3000040)
char dpston5[rule14] 3000039:3000040=3023940
replace dpston5 = 4043644 if inlist(dpston5, 4000044, 4033640)
char dpston5[rule15] 4000044:4033640=4043644
replace dpston5 = 4034750 if inlist(dpston5, 4000047, 4024950)
char dpston5[rule16] 4000047:4024950=4034750
replace dpston5 = 5021824 if inlist(dpston5, 5000018, 5000024)
char dpston5[rule17] 5000018:5000024=5021824
replace dpston5 = 5033944 if inlist(dpston5, 5000044, 5023940)
char dpston5[rule18] 5000044:5023940=5033944
replace dpston5 = 5034953 if inlist(dpston5, 5000053, 5024950)
char dpston5[rule19] 5000053:5024950=5034953
replace dpston5 = 2043644 if inlist(dpston5, 2000036, 2033944)
char dpston5[rule20] 2000036:2033944=2043644
replace dpston5 = 4073650 if inlist(dpston5, 4043644, 4034750)
char dpston5[rule21] 4043644:4034750=4073650
replace dpston5 = 5054960 if inlist(dpston5, 5034953, 5025560)
char dpston5[rule22] 5034953:5025560=5054960
replace dpston5 = 2021824 if inlist(dpston5, 2000018, 2000024)
char dpston5[rule23] 2000018:2000024=2021824
replace dpston5 = 3033944 if inlist(dpston5, 3000044, 3023940)
char dpston5[rule24] 3000044:3023940=3033944
replace dpston5 = 4021824 if inlist(dpston5, 4000018, 4000024)
char dpston5[rule25] 4000018:4000024=4021824
replace dpston5 = 5020102 if inlist(dpston5, 5000001, 5000002)
char dpston5[rule26] 5000001:5000002=5020102
replace dpston5 = 5026268 if inlist(dpston5, 5000062, 5000068)
char dpston5[rule27] 5000062:5000068=5026268
replace dpston5 = 2020102 if inlist(dpston5, 2000001, 2000002)
char dpston5[rule28] 2000001:2000002=2020102
replace dpston5 = 2030108 if inlist(dpston5, 2000008, 2020102)
char dpston5[rule29] 2000008:2020102=2030108
replace dpston5 = 2053044 if inlist(dpston5, 2000030, 2043644)
char dpston5[rule30] 2000030:2043644=2053044
replace dpston5 = 3024950 if inlist(dpston5, 3000049, 3000050)
char dpston5[rule31] 3000049:3000050=3024950
replace dpston5 = 5043947 if inlist(dpston5, 5000047, 5033944)
char dpston5[rule32] 5000047:5033944=5043947
replace dpston5 = 1023940 if inlist(dpston5, 1000039, 1000040)
char dpston5[rule33] 1000039:1000040=1023940
replace dpston5 = 3025560 if inlist(dpston5, 3000055, 3000060)
char dpston5[rule34] 3000055:3000060=3025560
replace dpston5 = 4031826 if inlist(dpston5, 4000026, 4021824)
char dpston5[rule35] 4000026:4021824=4031826
replace dpston5 = 5031826 if inlist(dpston5, 5000026, 5021824)
char dpston5[rule36] 5000026:5021824=5031826
replace dpston5 = 2026268 if inlist(dpston5, 2000062, 2000068)
char dpston5[rule37] 2000062:2000068=2026268
replace dpston5 = 2074968 if inlist(dpston5, 2054960, 2026268)
char dpston5[rule38] 2054960:2026268=2074968
replace dpston5 = 4020102 if inlist(dpston5, 4000001, 4000002)
char dpston5[rule39] 4000001:4000002=4020102
replace dpston5 = 4064962 if inlist(dpston5, 4000062, 4054960)
char dpston5[rule40] 4000062:4054960=4064962
replace dpston5 = 2031826 if inlist(dpston5, 2000026, 2021824)
char dpston5[rule41] 2000026:2021824=2031826
replace dpston5 = 5093960 if inlist(dpston5, 5043947, 5054960)
char dpston5[rule42] 5043947:5054960=5093960
replace dpston5 = 1025560 if inlist(dpston5, 1000055, 1000060)
char dpston5[rule43] 1000055:1000060=1025560
replace dpston5 = 4083050 if inlist(dpston5, 4000030, 4073650)
char dpston5[rule44] 4000030:4073650=4083050
replace dpston5 = 5030108 if inlist(dpston5, 5000008, 5020102)
char dpston5[rule45] 5000008:5020102=5030108
replace dpston5 = 3020102 if inlist(dpston5, 3000001, 3000002)
char dpston5[rule46] 3000001:3000002=3020102
replace dpston5 = 4074968 if inlist(dpston5, 4000068, 4064962)
char dpston5[rule47] 4000068:4064962=4074968
replace dpston5 = 5041830 if inlist(dpston5, 5000030, 5031826)
char dpston5[rule48] 5000030:5031826=5041830
replace dpston5 = 2040111 if inlist(dpston5, 2000011, 2030108)
char dpston5[rule49] 2000011:2030108=2040111
replace dpston5 = 3043644 if inlist(dpston5, 3000036, 3033944)
char dpston5[rule50] 3000036:3033944=3043644
replace dpston5 = 4041126 if inlist(dpston5, 4000011, 4031826)
char dpston5[rule51] 4000011:4031826=4041126
replace dpston5 = 1034953 if inlist(dpston5, 1000053, 1024950)
char dpston5[rule52] 1000053:1024950=1034953
replace dpston5 = 3034953 if inlist(dpston5, 3000053, 3024950)
char dpston5[rule53] 3000053:3024950=3034953
replace dpston5 = 4030108 if inlist(dpston5, 4000008, 4020102)
char dpston5[rule54] 4000008:4020102=4030108
replace dpston5 = 5051836 if inlist(dpston5, 5000036, 5041830)
char dpston5[rule55] 5000036:5041830=5051836
replace dpston5 = 3035562 if inlist(dpston5, 3000062, 3025560)
char dpston5[rule56] 3000062:3025560=3035562

char dpston5[nrules] 56

