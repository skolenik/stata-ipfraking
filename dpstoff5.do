*** Automatically created on 13 Nov 2017 at 11:51:57
* Source syntax: wgtcellcollapse collapse , variables(daypart alight_id) mincellsize(1)         zeroes(2 40 49 50 60) greedy maxcategory(99)         generate(dpstoff5) saving(dpstoff5.do) replace run

generate long dpstoff5 = (daypart)*1000000 + alight_id

label variable dpstoff5 "Long ID of the interaction"
format dpstoff5 %12.0f
char dpstoff5[sources] daypart alight_id
char dpstoff5[max] 324200269
replace dpstoff5 = 1023940 if inlist(dpstoff5, 1000039, 1000040)
char dpstoff5[rule1] 1000039:1000040=1023940
replace dpstoff5 = 2030108 if inlist(dpstoff5, 2000001, 2000002, 2000008)
char dpstoff5[rule2] 2000001:2000002:2000008=2030108
replace dpstoff5 = 2053044 if inlist(dpstoff5, 2000030, 2000036, 2000039, 2000040, 2000044)
char dpstoff5[rule3] 2000030:2000036:2000039:2000040:2000044=2053044
replace dpstoff5 = 2055062 if inlist(dpstoff5, 2000050, 2000053, 2000055, 2000060, 2000062)
char dpstoff5[rule4] 2000050:2000053:2000055:2000060:2000062=2055062
replace dpstoff5 = 3030108 if inlist(dpstoff5, 3000001, 3000002, 3000008)
char dpstoff5[rule5] 3000001:3000002:3000008=3030108
replace dpstoff5 = 3025560 if inlist(dpstoff5, 3000055, 3000060)
char dpstoff5[rule6] 3000055:3000060=3025560
replace dpstoff5 = 4040111 if inlist(dpstoff5, 4000001, 4000002, 4000008, 4000011)
char dpstoff5[rule7] 4000001:4000002:4000008:4000011=4040111
replace dpstoff5 = 4043644 if inlist(dpstoff5, 4000036, 4000039, 4000040, 4000044)
char dpstoff5[rule8] 4000036:4000039:4000040:4000044=4043644
replace dpstoff5 = 4024950 if inlist(dpstoff5, 4000049, 4000050)
char dpstoff5[rule9] 4000049:4000050=4024950
replace dpstoff5 = 4025560 if inlist(dpstoff5, 4000055, 4000060)
char dpstoff5[rule10] 4000055:4000060=4025560
replace dpstoff5 = 5030108 if inlist(dpstoff5, 5000001, 5000002, 5000008)
char dpstoff5[rule11] 5000001:5000002:5000008=5030108
replace dpstoff5 = 5033640 if inlist(dpstoff5, 5000036, 5000039, 5000040)
char dpstoff5[rule12] 5000036:5000039:5000040=5033640
replace dpstoff5 = 5024950 if inlist(dpstoff5, 5000049, 5000050)
char dpstoff5[rule13] 5000049:5000050=5024950
replace dpstoff5 = 5054960 if inlist(dpstoff5, 5000049, 5000050, 5000053, 5000055, 5000060)
char dpstoff5[rule14] 5000049:5000050:5000053:5000055:5000060=5054960

char dpstoff5[nrules] 14

*** Automatically created on 13 Nov 2017 at 11:52:11
* Source syntax: wgtcellcollapse collapse if daypart==5 & inrange(alight_id,1,30),         variables(daypart alight_id) mincellsize(20)         strict feed(dpstoff5) saving(dpstoff5.do) append run

confirm variable dpstoff5

replace dpstoff5 = 5022426 if inlist(dpstoff5, 5000024, 5000026)
char dpstoff5[rule15] 5000024:5000026=5022426
replace dpstoff5 = 5040111 if inlist(dpstoff5, 5000011, 5030108)
char dpstoff5[rule16] 5000011:5030108=5040111
replace dpstoff5 = 5031826 if inlist(dpstoff5, 5000018, 5022426)
char dpstoff5[rule17] 5000018:5022426=5031826
replace dpstoff5 = 5070126 if inlist(dpstoff5, 5040111, 5031826)
char dpstoff5[rule18] 5040111:5031826=5070126
replace dpstoff5 = 5080130 if inlist(dpstoff5, 5000030, 5070126)
char dpstoff5[rule19] 5000030:5070126=5080130

char dpstoff5[nrules] 19

*** Automatically created on 13 Nov 2017 at 11:52:15
* Source syntax: wgtcellcollapse collapse if daypart==5 & inrange(alight_id,36,68),         variables(daypart alight_id) mincellsize(20)         strict feed(dpstoff5) saving(dpstoff5.do) append run

confirm variable dpstoff5

replace dpstoff5 = 5034750 if inlist(dpstoff5, 5000047, 5024950)
char dpstoff5[rule20] 5000047:5024950=5034750
replace dpstoff5 = 5043644 if inlist(dpstoff5, 5000044, 5033640)
char dpstoff5[rule21] 5000044:5033640=5043644
replace dpstoff5 = 5064962 if inlist(dpstoff5, 5000062, 5054960)
char dpstoff5[rule22] 5000062:5054960=5064962
replace dpstoff5 = 5073650 if inlist(dpstoff5, 5043644, 5034750)
char dpstoff5[rule23] 5043644:5034750=5073650
replace dpstoff5 = 5074968 if inlist(dpstoff5, 5000068, 5064962)
char dpstoff5[rule24] 5000068:5064962=5074968

* skipping dpstoff5 == 5073650; 
* no good collapsing rule found for alight_id == 73650


* skipping dpstoff5 == 5074968; 
* no good collapsing rule found for alight_id == 74968


char dpstoff5[nrules] 24

*** Automatically created on 13 Nov 2017 at 11:52:20
* Source syntax: wgtcellcollapse collapse , variables(daypart alight_id) mincellsize(20)         strict feed(dpstoff5) saving(dpstoff5.do) append run

confirm variable dpstoff5

replace dpstoff5 = 1020208 if inlist(dpstoff5, 1000002, 1000008)
char dpstoff5[rule25] 1000002:1000008=1020208
replace dpstoff5 = 2021118 if inlist(dpstoff5, 2000011, 2000018)
char dpstoff5[rule26] 2000011:2000018=2021118
replace dpstoff5 = 2022426 if inlist(dpstoff5, 2000024, 2000026)
char dpstoff5[rule27] 2000024:2000026=2022426
replace dpstoff5 = 2064962 if inlist(dpstoff5, 2000049, 2055062)
char dpstoff5[rule28] 2000049:2055062=2064962
replace dpstoff5 = 2050118 if inlist(dpstoff5, 2030108, 2021118)
char dpstoff5[rule29] 2030108:2021118=2050118
replace dpstoff5 = 3023940 if inlist(dpstoff5, 3000039, 3000040)
char dpstoff5[rule30] 3000039:3000040=3023940
replace dpstoff5 = 3024950 if inlist(dpstoff5, 3000049, 3000050)
char dpstoff5[rule31] 3000049:3000050=3024950
replace dpstoff5 = 3040111 if inlist(dpstoff5, 3000011, 3030108)
char dpstoff5[rule32] 3000011:3030108=3040111
replace dpstoff5 = 4021824 if inlist(dpstoff5, 4000018, 4000024)
char dpstoff5[rule33] 4000018:4000024=4021824
replace dpstoff5 = 4031826 if inlist(dpstoff5, 4000026, 4021824)
char dpstoff5[rule34] 4000026:4021824=4031826
replace dpstoff5 = 4035360 if inlist(dpstoff5, 4000053, 4025560)
char dpstoff5[rule35] 4000053:4025560=4035360
replace dpstoff5 = 1024950 if inlist(dpstoff5, 1000049, 1000050)
char dpstoff5[rule36] 1000049:1000050=1024950
replace dpstoff5 = 2074968 if inlist(dpstoff5, 2000068, 2064962)
char dpstoff5[rule37] 2000068:2064962=2074968
replace dpstoff5 = 3022426 if inlist(dpstoff5, 3000024, 3000026)
char dpstoff5[rule38] 3000024:3000026=3022426
replace dpstoff5 = 3033944 if inlist(dpstoff5, 3000044, 3023940)
char dpstoff5[rule39] 3000044:3023940=3033944
replace dpstoff5 = 3034953 if inlist(dpstoff5, 3000053, 3024950)
char dpstoff5[rule40] 3000053:3024950=3034953
replace dpstoff5 = 4054960 if inlist(dpstoff5, 4024950, 4035360)
char dpstoff5[rule41] 4024950:4035360=4054960
replace dpstoff5 = 4053647 if inlist(dpstoff5, 4000047, 4043644)
char dpstoff5[rule42] 4000047:4043644=4053647
replace dpstoff5 = 1033640 if inlist(dpstoff5, 1000036, 1023940)
char dpstoff5[rule43] 1000036:1023940=1033640
replace dpstoff5 = 2070126 if inlist(dpstoff5, 2050118, 2022426)
char dpstoff5[rule44] 2050118:2022426=2070126
replace dpstoff5 = 4026268 if inlist(dpstoff5, 4000062, 4000068)
char dpstoff5[rule45] 4000062:4000068=4026268
replace dpstoff5 = 2063047 if inlist(dpstoff5, 2000047, 2053044)
char dpstoff5[rule46] 2000047:2053044=2063047
replace dpstoff5 = 3043644 if inlist(dpstoff5, 3000036, 3033944)
char dpstoff5[rule47] 3000036:3033944=3043644
replace dpstoff5 = 4070126 if inlist(dpstoff5, 4040111, 4031826)
char dpstoff5[rule48] 4040111:4031826=4070126
replace dpstoff5 = 1025560 if inlist(dpstoff5, 1000055, 1000060)
char dpstoff5[rule49] 1000055:1000060=1025560
replace dpstoff5 = 1034953 if inlist(dpstoff5, 1000053, 1024950)
char dpstoff5[rule50] 1000053:1024950=1034953
replace dpstoff5 = 2133068 if inlist(dpstoff5, 2063047, 2074968)
char dpstoff5[rule51] 2063047:2074968=2133068
replace dpstoff5 = 3054960 if inlist(dpstoff5, 3034953, 3025560)
char dpstoff5[rule52] 3034953:3025560=3054960
replace dpstoff5 = 2200168 if inlist(dpstoff5, 2070126, 2133068)
char dpstoff5[rule53] 2070126:2133068=2200168
replace dpstoff5 = 4103660 if inlist(dpstoff5, 4053647, 4054960)
char dpstoff5[rule54] 4053647:4054960=4103660
replace dpstoff5 = 4123668 if inlist(dpstoff5, 4103660, 4026268)
char dpstoff5[rule55] 4103660:4026268=4123668
replace dpstoff5 = 3031826 if inlist(dpstoff5, 3000018, 3022426)
char dpstoff5[rule56] 3000018:3022426=3031826
replace dpstoff5 = 3053044 if inlist(dpstoff5, 3000030, 3043644)
char dpstoff5[rule57] 3000030:3043644=3053044
replace dpstoff5 = 4080130 if inlist(dpstoff5, 4000030, 4070126)
char dpstoff5[rule58] 4000030:4070126=4080130
replace dpstoff5 = 1054960 if inlist(dpstoff5, 1034953, 1025560)
char dpstoff5[rule59] 1034953:1025560=1054960
replace dpstoff5 = 5150150 if inlist(dpstoff5, 5080130, 5073650)
char dpstoff5[rule60] 5080130:5073650=5150150
replace dpstoff5 = 1030211 if inlist(dpstoff5, 1000011, 1020208)
char dpstoff5[rule61] 1000011:1020208=1030211
replace dpstoff5 = 1043644 if inlist(dpstoff5, 1000044, 1033640)
char dpstoff5[rule62] 1000044:1033640=1043644
replace dpstoff5 = 1022426 if inlist(dpstoff5, 1000024, 1000026)
char dpstoff5[rule63] 1000024:1000026=1022426
replace dpstoff5 = 3070126 if inlist(dpstoff5, 3040111, 3031826)
char dpstoff5[rule64] 3040111:3031826=3070126
replace dpstoff5 = 3064962 if inlist(dpstoff5, 3000062, 3054960)
char dpstoff5[rule65] 3000062:3054960=3064962
replace dpstoff5 = 5084969 if inlist(dpstoff5, 5000069, 5074968)
char dpstoff5[rule66] 5000069:5074968=5084969

char dpstoff5[nrules] 66

