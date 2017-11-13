*** Automatically created on 13 Nov 2017 at 14:21:06
* Source syntax: wgtcellcollapse collapse , variables(daypart alight_id) mincellsize(1)         zeroes(2 40 49 50 60) greedy maxcategory(99)         generate(dpstoff4) saving(dpstoff4.do) replace run

generate long dpstoff4 = (daypart)*1000000 + alight_id

label variable dpstoff4 "Long ID of the interaction"
format dpstoff4 %12.0f
char dpstoff4[sources] daypart alight_id
char dpstoff4[max] 324200269
replace dpstoff4 = 1023940 if inlist(dpstoff4, 1000039, 1000040)
char dpstoff4[rule1] 1000039:1000040=1023940
replace dpstoff4 = 2030108 if inlist(dpstoff4, 2000001, 2000002, 2000008)
char dpstoff4[rule2] 2000001:2000002:2000008=2030108
replace dpstoff4 = 2053044 if inlist(dpstoff4, 2000030, 2000036, 2000039, 2000040, 2000044)
char dpstoff4[rule3] 2000030:2000036:2000039:2000040:2000044=2053044
replace dpstoff4 = 2055062 if inlist(dpstoff4, 2000050, 2000053, 2000055, 2000060, 2000062)
char dpstoff4[rule4] 2000050:2000053:2000055:2000060:2000062=2055062
replace dpstoff4 = 3030108 if inlist(dpstoff4, 3000001, 3000002, 3000008)
char dpstoff4[rule5] 3000001:3000002:3000008=3030108
replace dpstoff4 = 3025560 if inlist(dpstoff4, 3000055, 3000060)
char dpstoff4[rule6] 3000055:3000060=3025560
replace dpstoff4 = 4040111 if inlist(dpstoff4, 4000001, 4000002, 4000008, 4000011)
char dpstoff4[rule7] 4000001:4000002:4000008:4000011=4040111
replace dpstoff4 = 4043644 if inlist(dpstoff4, 4000036, 4000039, 4000040, 4000044)
char dpstoff4[rule8] 4000036:4000039:4000040:4000044=4043644
replace dpstoff4 = 4024950 if inlist(dpstoff4, 4000049, 4000050)
char dpstoff4[rule9] 4000049:4000050=4024950
replace dpstoff4 = 4025560 if inlist(dpstoff4, 4000055, 4000060)
char dpstoff4[rule10] 4000055:4000060=4025560
replace dpstoff4 = 5030108 if inlist(dpstoff4, 5000001, 5000002, 5000008)
char dpstoff4[rule11] 5000001:5000002:5000008=5030108
replace dpstoff4 = 5033640 if inlist(dpstoff4, 5000036, 5000039, 5000040)
char dpstoff4[rule12] 5000036:5000039:5000040=5033640
replace dpstoff4 = 5024950 if inlist(dpstoff4, 5000049, 5000050)
char dpstoff4[rule13] 5000049:5000050=5024950
replace dpstoff4 = 5054960 if inlist(dpstoff4, 5000049, 5000050, 5000053, 5000055, 5000060)
char dpstoff4[rule14] 5000049:5000050:5000053:5000055:5000060=5054960

char dpstoff4[nrules] 14

*** Automatically created on 13 Nov 2017 at 14:21:17
* Source syntax: wgtcellcollapse collapse , variables(daypart alight_id) mincellsize(20)         strict feed(dpstoff4) saving(dpstoff4.do) append run

confirm variable dpstoff4

replace dpstoff4 = 1020208 if inlist(dpstoff4, 1000002, 1000008)
char dpstoff4[rule15] 1000002:1000008=1020208
replace dpstoff4 = 2021118 if inlist(dpstoff4, 2000011, 2000018)
char dpstoff4[rule16] 2000011:2000018=2021118
replace dpstoff4 = 2022426 if inlist(dpstoff4, 2000024, 2000026)
char dpstoff4[rule17] 2000024:2000026=2022426
replace dpstoff4 = 2064962 if inlist(dpstoff4, 2000049, 2055062)
char dpstoff4[rule18] 2000049:2055062=2064962
replace dpstoff4 = 2050118 if inlist(dpstoff4, 2030108, 2021118)
char dpstoff4[rule19] 2030108:2021118=2050118
replace dpstoff4 = 3023940 if inlist(dpstoff4, 3000039, 3000040)
char dpstoff4[rule20] 3000039:3000040=3023940
replace dpstoff4 = 3024950 if inlist(dpstoff4, 3000049, 3000050)
char dpstoff4[rule21] 3000049:3000050=3024950
replace dpstoff4 = 3040111 if inlist(dpstoff4, 3000011, 3030108)
char dpstoff4[rule22] 3000011:3030108=3040111
replace dpstoff4 = 4021824 if inlist(dpstoff4, 4000018, 4000024)
char dpstoff4[rule23] 4000018:4000024=4021824
replace dpstoff4 = 4031826 if inlist(dpstoff4, 4000026, 4021824)
char dpstoff4[rule24] 4000026:4021824=4031826
replace dpstoff4 = 4035360 if inlist(dpstoff4, 4000053, 4025560)
char dpstoff4[rule25] 4000053:4025560=4035360
replace dpstoff4 = 5022426 if inlist(dpstoff4, 5000024, 5000026)
char dpstoff4[rule26] 5000024:5000026=5022426
replace dpstoff4 = 5034750 if inlist(dpstoff4, 5000047, 5024950)
char dpstoff4[rule27] 5000047:5024950=5034750
replace dpstoff4 = 5040111 if inlist(dpstoff4, 5000011, 5030108)
char dpstoff4[rule28] 5000011:5030108=5040111
replace dpstoff4 = 1024950 if inlist(dpstoff4, 1000049, 1000050)
char dpstoff4[rule29] 1000049:1000050=1024950
replace dpstoff4 = 2074968 if inlist(dpstoff4, 2000068, 2064962)
char dpstoff4[rule30] 2000068:2064962=2074968
replace dpstoff4 = 3022426 if inlist(dpstoff4, 3000024, 3000026)
char dpstoff4[rule31] 3000024:3000026=3022426
replace dpstoff4 = 3033944 if inlist(dpstoff4, 3000044, 3023940)
char dpstoff4[rule32] 3000044:3023940=3033944
replace dpstoff4 = 3034953 if inlist(dpstoff4, 3000053, 3024950)
char dpstoff4[rule33] 3000053:3024950=3034953
replace dpstoff4 = 4054960 if inlist(dpstoff4, 4024950, 4035360)
char dpstoff4[rule34] 4024950:4035360=4054960
replace dpstoff4 = 4053647 if inlist(dpstoff4, 4000047, 4043644)
char dpstoff4[rule35] 4000047:4043644=4053647
replace dpstoff4 = 5043644 if inlist(dpstoff4, 5000044, 5033640)
char dpstoff4[rule36] 5000044:5033640=5043644
replace dpstoff4 = 5064962 if inlist(dpstoff4, 5000062, 5054960)
char dpstoff4[rule37] 5000062:5054960=5064962
replace dpstoff4 = 1033640 if inlist(dpstoff4, 1000036, 1023940)
char dpstoff4[rule38] 1000036:1023940=1033640
replace dpstoff4 = 2070126 if inlist(dpstoff4, 2050118, 2022426)
char dpstoff4[rule39] 2050118:2022426=2070126
replace dpstoff4 = 4026268 if inlist(dpstoff4, 4000062, 4000068)
char dpstoff4[rule40] 4000062:4000068=4026268
replace dpstoff4 = 5031826 if inlist(dpstoff4, 5000018, 5022426)
char dpstoff4[rule41] 5000018:5022426=5031826
replace dpstoff4 = 2063047 if inlist(dpstoff4, 2000047, 2053044)
char dpstoff4[rule42] 2000047:2053044=2063047
replace dpstoff4 = 3043644 if inlist(dpstoff4, 3000036, 3033944)
char dpstoff4[rule43] 3000036:3033944=3043644
replace dpstoff4 = 4070126 if inlist(dpstoff4, 4040111, 4031826)
char dpstoff4[rule44] 4040111:4031826=4070126
replace dpstoff4 = 5073650 if inlist(dpstoff4, 5043644, 5034750)
char dpstoff4[rule45] 5043644:5034750=5073650
replace dpstoff4 = 1025560 if inlist(dpstoff4, 1000055, 1000060)
char dpstoff4[rule46] 1000055:1000060=1025560
replace dpstoff4 = 1034953 if inlist(dpstoff4, 1000053, 1024950)
char dpstoff4[rule47] 1000053:1024950=1034953
replace dpstoff4 = 2133068 if inlist(dpstoff4, 2063047, 2074968)
char dpstoff4[rule48] 2063047:2074968=2133068
replace dpstoff4 = 3054960 if inlist(dpstoff4, 3034953, 3025560)
char dpstoff4[rule49] 3034953:3025560=3054960
replace dpstoff4 = 2200168 if inlist(dpstoff4, 2070126, 2133068)
char dpstoff4[rule50] 2070126:2133068=2200168
replace dpstoff4 = 4103660 if inlist(dpstoff4, 4053647, 4054960)
char dpstoff4[rule51] 4053647:4054960=4103660
replace dpstoff4 = 5070126 if inlist(dpstoff4, 5040111, 5031826)
char dpstoff4[rule52] 5040111:5031826=5070126
replace dpstoff4 = 5074968 if inlist(dpstoff4, 5000068, 5064962)
char dpstoff4[rule53] 5000068:5064962=5074968
replace dpstoff4 = 5083050 if inlist(dpstoff4, 5000030, 5073650)
char dpstoff4[rule54] 5000030:5073650=5083050
replace dpstoff4 = 4123668 if inlist(dpstoff4, 4103660, 4026268)
char dpstoff4[rule55] 4103660:4026268=4123668
replace dpstoff4 = 3031826 if inlist(dpstoff4, 3000018, 3022426)
char dpstoff4[rule56] 3000018:3022426=3031826
replace dpstoff4 = 3053044 if inlist(dpstoff4, 3000030, 3043644)
char dpstoff4[rule57] 3000030:3043644=3053044
replace dpstoff4 = 4080130 if inlist(dpstoff4, 4000030, 4070126)
char dpstoff4[rule58] 4000030:4070126=4080130
replace dpstoff4 = 1054960 if inlist(dpstoff4, 1034953, 1025560)
char dpstoff4[rule59] 1034953:1025560=1054960
replace dpstoff4 = 1030211 if inlist(dpstoff4, 1000011, 1020208)
char dpstoff4[rule60] 1000011:1020208=1030211
replace dpstoff4 = 1043644 if inlist(dpstoff4, 1000044, 1033640)
char dpstoff4[rule61] 1000044:1033640=1043644
replace dpstoff4 = 5150150 if inlist(dpstoff4, 5070126, 5083050)
char dpstoff4[rule62] 5070126:5083050=5150150
replace dpstoff4 = 1022426 if inlist(dpstoff4, 1000024, 1000026)
char dpstoff4[rule63] 1000024:1000026=1022426
replace dpstoff4 = 3070126 if inlist(dpstoff4, 3040111, 3031826)
char dpstoff4[rule64] 3040111:3031826=3070126
replace dpstoff4 = 3064962 if inlist(dpstoff4, 3000062, 3054960)
char dpstoff4[rule65] 3000062:3054960=3064962
replace dpstoff4 = 5084969 if inlist(dpstoff4, 5000069, 5074968)
char dpstoff4[rule66] 5000069:5074968=5084969

char dpstoff4[nrules] 66

