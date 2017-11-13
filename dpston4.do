*** Automatically created on 13 Nov 2017 at 14:20:29
* Source syntax: wgtcellcollapse collapse , variables(daypart board_id) mincellsize(1)         zeroes(39 44 49 60) greedy maxcategory(99)         generate(dpston4) saving(dpston4.do) replace run

generate long dpston4 = (daypart)*1000000 + board_id

label variable dpston4 "Long ID of the interaction"
format dpston4 %12.0f
char dpston4[sources] daypart board_id
char dpston4[max] 324200269
replace dpston4 = 1024950 if inlist(dpston4, 1000049, 1000050)
char dpston4[rule1] 1000049:1000050=1024950
replace dpston4 = 2024044 if inlist(dpston4, 2000040, 2000044)
char dpston4[rule2] 2000040:2000044=2024044
replace dpston4 = 2024950 if inlist(dpston4, 2000049, 2000050)
char dpston4[rule3] 2000049:2000050=2024950
replace dpston4 = 2025560 if inlist(dpston4, 2000055, 2000060)
char dpston4[rule4] 2000055:2000060=2025560
replace dpston4 = 4033640 if inlist(dpston4, 4000036, 4000039, 4000040)
char dpston4[rule5] 4000036:4000039:4000040=4033640
replace dpston4 = 4024950 if inlist(dpston4, 4000049, 4000050)
char dpston4[rule6] 4000049:4000050=4024950
replace dpston4 = 4054960 if inlist(dpston4, 4000049, 4000050, 4000053, 4000055, 4000060)
char dpston4[rule7] 4000049:4000050:4000053:4000055:4000060=4054960
replace dpston4 = 5023940 if inlist(dpston4, 5000039, 5000040)
char dpston4[rule8] 5000039:5000040=5023940
replace dpston4 = 5024950 if inlist(dpston4, 5000049, 5000050)
char dpston4[rule9] 5000049:5000050=5024950
replace dpston4 = 5025560 if inlist(dpston4, 5000055, 5000060)
char dpston4[rule10] 5000055:5000060=5025560

char dpston4[nrules] 10

*** Automatically created on 13 Nov 2017 at 14:20:38
* Source syntax: wgtcellcollapse collapse , variables(daypart board_id) mincellsize(20)         strict feed(dpston4) saving(dpston4.do) append run

confirm variable dpston4

replace dpston4 = 2033944 if inlist(dpston4, 2000039, 2024044)
char dpston4[rule11] 2000039:2024044=2033944
replace dpston4 = 2034953 if inlist(dpston4, 2000053, 2024950)
char dpston4[rule12] 2000053:2024950=2034953
replace dpston4 = 2054960 if inlist(dpston4, 2034953, 2025560)
char dpston4[rule13] 2034953:2025560=2054960
replace dpston4 = 3023940 if inlist(dpston4, 3000039, 3000040)
char dpston4[rule14] 3000039:3000040=3023940
replace dpston4 = 4043644 if inlist(dpston4, 4000044, 4033640)
char dpston4[rule15] 4000044:4033640=4043644
replace dpston4 = 4034750 if inlist(dpston4, 4000047, 4024950)
char dpston4[rule16] 4000047:4024950=4034750
replace dpston4 = 5021824 if inlist(dpston4, 5000018, 5000024)
char dpston4[rule17] 5000018:5000024=5021824
replace dpston4 = 5033944 if inlist(dpston4, 5000044, 5023940)
char dpston4[rule18] 5000044:5023940=5033944
replace dpston4 = 5034953 if inlist(dpston4, 5000053, 5024950)
char dpston4[rule19] 5000053:5024950=5034953
replace dpston4 = 2043644 if inlist(dpston4, 2000036, 2033944)
char dpston4[rule20] 2000036:2033944=2043644
replace dpston4 = 4073650 if inlist(dpston4, 4043644, 4034750)
char dpston4[rule21] 4043644:4034750=4073650
replace dpston4 = 5054960 if inlist(dpston4, 5034953, 5025560)
char dpston4[rule22] 5034953:5025560=5054960
replace dpston4 = 2021824 if inlist(dpston4, 2000018, 2000024)
char dpston4[rule23] 2000018:2000024=2021824
replace dpston4 = 3033944 if inlist(dpston4, 3000044, 3023940)
char dpston4[rule24] 3000044:3023940=3033944
replace dpston4 = 4021824 if inlist(dpston4, 4000018, 4000024)
char dpston4[rule25] 4000018:4000024=4021824
replace dpston4 = 5020102 if inlist(dpston4, 5000001, 5000002)
char dpston4[rule26] 5000001:5000002=5020102
replace dpston4 = 5026268 if inlist(dpston4, 5000062, 5000068)
char dpston4[rule27] 5000062:5000068=5026268
replace dpston4 = 2020102 if inlist(dpston4, 2000001, 2000002)
char dpston4[rule28] 2000001:2000002=2020102
replace dpston4 = 2030108 if inlist(dpston4, 2000008, 2020102)
char dpston4[rule29] 2000008:2020102=2030108
replace dpston4 = 2053044 if inlist(dpston4, 2000030, 2043644)
char dpston4[rule30] 2000030:2043644=2053044
replace dpston4 = 3024950 if inlist(dpston4, 3000049, 3000050)
char dpston4[rule31] 3000049:3000050=3024950
replace dpston4 = 5043947 if inlist(dpston4, 5000047, 5033944)
char dpston4[rule32] 5000047:5033944=5043947
replace dpston4 = 1023940 if inlist(dpston4, 1000039, 1000040)
char dpston4[rule33] 1000039:1000040=1023940
replace dpston4 = 3025560 if inlist(dpston4, 3000055, 3000060)
char dpston4[rule34] 3000055:3000060=3025560
replace dpston4 = 4031826 if inlist(dpston4, 4000026, 4021824)
char dpston4[rule35] 4000026:4021824=4031826
replace dpston4 = 5031826 if inlist(dpston4, 5000026, 5021824)
char dpston4[rule36] 5000026:5021824=5031826
replace dpston4 = 2026268 if inlist(dpston4, 2000062, 2000068)
char dpston4[rule37] 2000062:2000068=2026268
replace dpston4 = 2074968 if inlist(dpston4, 2054960, 2026268)
char dpston4[rule38] 2054960:2026268=2074968
replace dpston4 = 4020102 if inlist(dpston4, 4000001, 4000002)
char dpston4[rule39] 4000001:4000002=4020102
replace dpston4 = 4064962 if inlist(dpston4, 4000062, 4054960)
char dpston4[rule40] 4000062:4054960=4064962
replace dpston4 = 2031826 if inlist(dpston4, 2000026, 2021824)
char dpston4[rule41] 2000026:2021824=2031826
replace dpston4 = 5093960 if inlist(dpston4, 5043947, 5054960)
char dpston4[rule42] 5043947:5054960=5093960
replace dpston4 = 1025560 if inlist(dpston4, 1000055, 1000060)
char dpston4[rule43] 1000055:1000060=1025560
replace dpston4 = 4083050 if inlist(dpston4, 4000030, 4073650)
char dpston4[rule44] 4000030:4073650=4083050
replace dpston4 = 5030108 if inlist(dpston4, 5000008, 5020102)
char dpston4[rule45] 5000008:5020102=5030108
replace dpston4 = 3020102 if inlist(dpston4, 3000001, 3000002)
char dpston4[rule46] 3000001:3000002=3020102
replace dpston4 = 4074968 if inlist(dpston4, 4000068, 4064962)
char dpston4[rule47] 4000068:4064962=4074968
replace dpston4 = 5041830 if inlist(dpston4, 5000030, 5031826)
char dpston4[rule48] 5000030:5031826=5041830
replace dpston4 = 2040111 if inlist(dpston4, 2000011, 2030108)
char dpston4[rule49] 2000011:2030108=2040111
replace dpston4 = 3043644 if inlist(dpston4, 3000036, 3033944)
char dpston4[rule50] 3000036:3033944=3043644
replace dpston4 = 4041126 if inlist(dpston4, 4000011, 4031826)
char dpston4[rule51] 4000011:4031826=4041126
replace dpston4 = 1034953 if inlist(dpston4, 1000053, 1024950)
char dpston4[rule52] 1000053:1024950=1034953
replace dpston4 = 3034953 if inlist(dpston4, 3000053, 3024950)
char dpston4[rule53] 3000053:3024950=3034953
replace dpston4 = 4030108 if inlist(dpston4, 4000008, 4020102)
char dpston4[rule54] 4000008:4020102=4030108
replace dpston4 = 5051836 if inlist(dpston4, 5000036, 5041830)
char dpston4[rule55] 5000036:5041830=5051836
replace dpston4 = 3035562 if inlist(dpston4, 3000062, 3025560)
char dpston4[rule56] 3000062:3025560=3035562

char dpston4[nrules] 56

