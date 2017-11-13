*** Automatically created on 13 Nov 2017 at 14:19:36
* Source syntax: wgtcellcollapse collapse , variables(daypart alight_id) mincellsize(1)         zeroes(2 8 36 39 40 44 47 49 50 55 60 62)         generate(dpstoff3) saving(dpstoff3.do) replace run

generate long dpstoff3 = (daypart)*1000000 + alight_id

label variable dpstoff3 "Long ID of the interaction"
format dpstoff3 %12.0f
char dpstoff3[sources] daypart alight_id
char dpstoff3[max] 324200269
replace dpstoff3 = 1023940 if inlist(dpstoff3, 1000039, 1000040)
char dpstoff3[rule1] 1000039:1000040=1023940
replace dpstoff3 = 2020208 if inlist(dpstoff3, 2000002, 2000008)
char dpstoff3[rule2] 2000002:2000008=2020208
replace dpstoff3 = 2023036 if inlist(dpstoff3, 2000030, 2000036)
char dpstoff3[rule3] 2000030:2000036=2023036
replace dpstoff3 = 2042639 if inlist(dpstoff3, 2000026, 2000030, 2000036, 2000039)
char dpstoff3[rule4] 2000026:2000030:2000036:2000039=2042639
replace dpstoff3 = 2062440 if inlist(dpstoff3, 2000024, 2000026, 2000030, 2000036, 2000039, 2000040)
char dpstoff3[rule5] 2000024:2000026:2000030:2000036:2000039:2000040=2062440
replace dpstoff3 = 2072444 if inlist(dpstoff3, 2000044, 2062440)
char dpstoff3[rule6] 2000044:2062440=2072444
replace dpstoff3 = 2024950 if inlist(dpstoff3, 2000049, 2000050)
char dpstoff3[rule7] 2000049:2000050=2024950
replace dpstoff3 = 2025355 if inlist(dpstoff3, 2000053, 2000055)
char dpstoff3[rule8] 2000053:2000055=2025355
replace dpstoff3 = 2035360 if inlist(dpstoff3, 2000060, 2025355)
char dpstoff3[rule9] 2000060:2025355=2035360
replace dpstoff3 = 2045362 if inlist(dpstoff3, 2000062, 2035360)
char dpstoff3[rule10] 2000062:2035360=2045362
replace dpstoff3 = 3020208 if inlist(dpstoff3, 3000002, 3000008)
char dpstoff3[rule11] 3000002:3000008=3020208
replace dpstoff3 = 3025560 if inlist(dpstoff3, 3000055, 3000060)
char dpstoff3[rule12] 3000055:3000060=3025560
replace dpstoff3 = 4030211 if inlist(dpstoff3, 4000002, 4000008, 4000011)
char dpstoff3[rule13] 4000002:4000008:4000011=4030211
replace dpstoff3 = 4023639 if inlist(dpstoff3, 4000036, 4000039)
char dpstoff3[rule14] 4000036:4000039=4023639
replace dpstoff3 = 4033640 if inlist(dpstoff3, 4000040, 4023639)
char dpstoff3[rule15] 4000040:4023639=4033640
replace dpstoff3 = 4043644 if inlist(dpstoff3, 4000044, 4033640)
char dpstoff3[rule16] 4000044:4033640=4043644
replace dpstoff3 = 4024950 if inlist(dpstoff3, 4000049, 4000050)
char dpstoff3[rule17] 4000049:4000050=4024950
replace dpstoff3 = 4025560 if inlist(dpstoff3, 4000055, 4000060)
char dpstoff3[rule18] 4000055:4000060=4025560
replace dpstoff3 = 5020208 if inlist(dpstoff3, 5000002, 5000008)
char dpstoff3[rule19] 5000002:5000008=5020208
replace dpstoff3 = 5023639 if inlist(dpstoff3, 5000036, 5000039)
char dpstoff3[rule20] 5000036:5000039=5023639
replace dpstoff3 = 5024044 if inlist(dpstoff3, 5000040, 5000044)
char dpstoff3[rule21] 5000040:5000044=5024044
replace dpstoff3 = 5024950 if inlist(dpstoff3, 5000049, 5000050)
char dpstoff3[rule22] 5000049:5000050=5024950
replace dpstoff3 = 5025355 if inlist(dpstoff3, 5000053, 5000055)
char dpstoff3[rule23] 5000053:5000055=5025355
replace dpstoff3 = 5054960 if inlist(dpstoff3, 5024950, 5000053, 5000055, 5000060)
char dpstoff3[rule24] 5024950:5000053:5000055:5000060=5054960

char dpstoff3[nrules] 24

*** Automatically created on 13 Nov 2017 at 14:19:58
* Source syntax: wgtcellcollapse collapse , variables(daypart alight_id) mincellsize(20)         strict feed(dpstoff3) saving(dpstoff3.do) append run

confirm variable dpstoff3

replace dpstoff3 = 1020208 if inlist(dpstoff3, 1000002, 1000008)
char dpstoff3[rule25] 1000002:1000008=1020208
replace dpstoff3 = 2021118 if inlist(dpstoff3, 2000011, 2000018)
char dpstoff3[rule26] 2000011:2000018=2021118
replace dpstoff3 = 2040218 if inlist(dpstoff3, 2020208, 2021118)
char dpstoff3[rule27] 2020208:2021118=2040218
replace dpstoff3 = 2064962 if inlist(dpstoff3, 2024950, 2045362)
char dpstoff3[rule28] 2024950:2045362=2064962
replace dpstoff3 = 2110244 if inlist(dpstoff3, 2040218, 2072444)
char dpstoff3[rule29] 2040218:2072444=2110244
replace dpstoff3 = 3023940 if inlist(dpstoff3, 3000039, 3000040)
char dpstoff3[rule30] 3000039:3000040=3023940
replace dpstoff3 = 3024950 if inlist(dpstoff3, 3000049, 3000050)
char dpstoff3[rule31] 3000049:3000050=3024950
replace dpstoff3 = 3030211 if inlist(dpstoff3, 3000011, 3020208)
char dpstoff3[rule32] 3000011:3020208=3030211
replace dpstoff3 = 4021824 if inlist(dpstoff3, 4000018, 4000024)
char dpstoff3[rule33] 4000018:4000024=4021824
replace dpstoff3 = 4031826 if inlist(dpstoff3, 4000026, 4021824)
char dpstoff3[rule34] 4000026:4021824=4031826
replace dpstoff3 = 4035360 if inlist(dpstoff3, 4000053, 4025560)
char dpstoff3[rule35] 4000053:4025560=4035360
replace dpstoff3 = 5022426 if inlist(dpstoff3, 5000024, 5000026)
char dpstoff3[rule36] 5000024:5000026=5022426
replace dpstoff3 = 5030211 if inlist(dpstoff3, 5000011, 5020208)
char dpstoff3[rule37] 5000011:5020208=5030211
replace dpstoff3 = 5064760 if inlist(dpstoff3, 5000047, 5054960)
char dpstoff3[rule38] 5000047:5054960=5064760
replace dpstoff3 = 1024950 if inlist(dpstoff3, 1000049, 1000050)
char dpstoff3[rule39] 1000049:1000050=1024950

* skipping dpstoff3 == 2042639; 
* no good collapsing rule found for alight_id == 42639
* however rule(s) 1 3 4 may be used for daypart

replace dpstoff3 = 2074968 if inlist(dpstoff3, 2000068, 2064962)
char dpstoff3[rule40] 2000068:2064962=2074968
replace dpstoff3 = 3022426 if inlist(dpstoff3, 3000024, 3000026)
char dpstoff3[rule41] 3000024:3000026=3022426
replace dpstoff3 = 3033944 if inlist(dpstoff3, 3000044, 3023940)
char dpstoff3[rule42] 3000044:3023940=3033944
replace dpstoff3 = 3034953 if inlist(dpstoff3, 3000053, 3024950)
char dpstoff3[rule43] 3000053:3024950=3034953
replace dpstoff3 = 4054960 if inlist(dpstoff3, 4024950, 4035360)
char dpstoff3[rule44] 4024950:4035360=4054960
replace dpstoff3 = 4053647 if inlist(dpstoff3, 4000047, 4043644)
char dpstoff3[rule45] 4000047:4043644=4053647
replace dpstoff3 = 5043644 if inlist(dpstoff3, 5023639, 5024044)
char dpstoff3[rule46] 5023639:5024044=5043644

* skipping dpstoff3 == 5025355; 
* no good collapsing rule found for alight_id == 25355

replace dpstoff3 = 1033640 if inlist(dpstoff3, 1000036, 1023940)
char dpstoff3[rule47] 1000036:1023940=1033640
replace dpstoff3 = 4026268 if inlist(dpstoff3, 4000062, 4000068)
char dpstoff3[rule48] 4000062:4000068=4026268
replace dpstoff3 = 5031826 if inlist(dpstoff3, 5000018, 5022426)
char dpstoff3[rule49] 5000018:5022426=5031826

* skipping dpstoff3 == 2023036; 
* no good collapsing rule found for alight_id == 23036
* however rule(s) 1 3 4 may be used for daypart

replace dpstoff3 = 2120247 if inlist(dpstoff3, 2000047, 2110244)
char dpstoff3[rule50] 2000047:2110244=2120247
replace dpstoff3 = 3043644 if inlist(dpstoff3, 3000036, 3033944)
char dpstoff3[rule51] 3000036:3033944=3043644
replace dpstoff3 = 4060226 if inlist(dpstoff3, 4030211, 4031826)
char dpstoff3[rule52] 4030211:4031826=4060226
replace dpstoff3 = 5103660 if inlist(dpstoff3, 5043644, 5064760)
char dpstoff3[rule53] 5043644:5064760=5103660
replace dpstoff3 = 1025560 if inlist(dpstoff3, 1000055, 1000060)
char dpstoff3[rule54] 1000055:1000060=1025560
replace dpstoff3 = 1034953 if inlist(dpstoff3, 1000053, 1024950)
char dpstoff3[rule55] 1000053:1024950=1034953
replace dpstoff3 = 2190268 if inlist(dpstoff3, 2120247, 2074968)
char dpstoff3[rule56] 2120247:2074968=2190268
replace dpstoff3 = 3054960 if inlist(dpstoff3, 3034953, 3025560)
char dpstoff3[rule57] 3034953:3025560=3054960
replace dpstoff3 = 4103660 if inlist(dpstoff3, 4053647, 4054960)
char dpstoff3[rule58] 4053647:4054960=4103660
replace dpstoff3 = 5060226 if inlist(dpstoff3, 5030211, 5031826)
char dpstoff3[rule59] 5030211:5031826=5060226
replace dpstoff3 = 5026268 if inlist(dpstoff3, 5000062, 5000068)
char dpstoff3[rule60] 5000062:5000068=5026268
replace dpstoff3 = 5113060 if inlist(dpstoff3, 5000030, 5103660)
char dpstoff3[rule61] 5000030:5103660=5113060
replace dpstoff3 = 4123668 if inlist(dpstoff3, 4103660, 4026268)
char dpstoff3[rule62] 4103660:4026268=4123668
replace dpstoff3 = 3031826 if inlist(dpstoff3, 3000018, 3022426)
char dpstoff3[rule63] 3000018:3022426=3031826
replace dpstoff3 = 3053044 if inlist(dpstoff3, 3000030, 3043644)
char dpstoff3[rule64] 3000030:3043644=3053044
replace dpstoff3 = 4070230 if inlist(dpstoff3, 4000030, 4060226)
char dpstoff3[rule65] 4000030:4060226=4070230
replace dpstoff3 = 1054960 if inlist(dpstoff3, 1034953, 1025560)
char dpstoff3[rule66] 1034953:1025560=1054960
replace dpstoff3 = 1030211 if inlist(dpstoff3, 1000011, 1020208)
char dpstoff3[rule67] 1000011:1020208=1030211
replace dpstoff3 = 1043644 if inlist(dpstoff3, 1000044, 1033640)
char dpstoff3[rule68] 1000044:1033640=1043644
replace dpstoff3 = 5170260 if inlist(dpstoff3, 5060226, 5113060)
char dpstoff3[rule69] 5060226:5113060=5170260
replace dpstoff3 = 1022426 if inlist(dpstoff3, 1000024, 1000026)
char dpstoff3[rule70] 1000024:1000026=1022426
replace dpstoff3 = 2200269 if inlist(dpstoff3, 2000069, 2190268)
char dpstoff3[rule71] 2000069:2190268=2200269
replace dpstoff3 = 3060226 if inlist(dpstoff3, 3030211, 3031826)
char dpstoff3[rule72] 3030211:3031826=3060226
replace dpstoff3 = 3064962 if inlist(dpstoff3, 3000062, 3054960)
char dpstoff3[rule73] 3000062:3054960=3064962
replace dpstoff3 = 5190268 if inlist(dpstoff3, 5170260, 5026268)
char dpstoff3[rule74] 5170260:5026268=5190268

char dpstoff3[nrules] 74

