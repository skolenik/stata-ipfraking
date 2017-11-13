*** Automatically created on 12 Nov 2017 at 15:38:28
* Source syntax: wgtcellcollapse collapse , variables(daypart alight_id) mincellsize(20)         zeroes(2 8 36 39 40 44 47 49 50 55 60 62)         generate(dpstoff) saving(dpstoff.do) replace run

generate long dpstoff = (daypart)*1000000 + alight_id

label variable dpstoff "Long ID of the interaction"
format dpstoff %12.0f
char dpstoff[sources] daypart alight_id
char dpstoff[max] 324200269
replace dpstoff = 1023940 if inlist(dpstoff, 1000039, 1000040)
char dpstoff[rule1] 1000039:1000040=1023940
replace dpstoff = 2020208 if inlist(dpstoff, 2000002, 2000008)
char dpstoff[rule2] 2000002:2000008=2020208
replace dpstoff = 2023036 if inlist(dpstoff, 2000030, 2000036)
char dpstoff[rule3] 2000030:2000036=2023036
replace dpstoff = 2042639 if inlist(dpstoff, 2000026, 2000030, 2000036, 2000039)
char dpstoff[rule4] 2000026:2000030:2000036:2000039=2042639
replace dpstoff = 2062440 if inlist(dpstoff, 2000024, 2000026, 2000030, 2000036, 2000039, 2000040)
char dpstoff[rule5] 2000024:2000026:2000030:2000036:2000039:2000040=2062440
replace dpstoff = 2072444 if inlist(dpstoff, 2000044, 2062440)
char dpstoff[rule6] 2000044:2062440=2072444
replace dpstoff = 2024950 if inlist(dpstoff, 2000049, 2000050)
char dpstoff[rule7] 2000049:2000050=2024950
replace dpstoff = 2025355 if inlist(dpstoff, 2000053, 2000055)
char dpstoff[rule8] 2000053:2000055=2025355
replace dpstoff = 2035360 if inlist(dpstoff, 2000060, 2025355)
char dpstoff[rule9] 2000060:2025355=2035360
replace dpstoff = 2045362 if inlist(dpstoff, 2000062, 2035360)
char dpstoff[rule10] 2000062:2035360=2045362
replace dpstoff = 3020208 if inlist(dpstoff, 3000002, 3000008)
char dpstoff[rule11] 3000002:3000008=3020208
replace dpstoff = 3025560 if inlist(dpstoff, 3000055, 3000060)
char dpstoff[rule12] 3000055:3000060=3025560
replace dpstoff = 4030211 if inlist(dpstoff, 4000002, 4000008, 4000011)
char dpstoff[rule13] 4000002:4000008:4000011=4030211
replace dpstoff = 4023639 if inlist(dpstoff, 4000036, 4000039)
char dpstoff[rule14] 4000036:4000039=4023639
replace dpstoff = 4033640 if inlist(dpstoff, 4000040, 4023639)
char dpstoff[rule15] 4000040:4023639=4033640
replace dpstoff = 4043644 if inlist(dpstoff, 4000044, 4033640)
char dpstoff[rule16] 4000044:4033640=4043644
replace dpstoff = 4024950 if inlist(dpstoff, 4000049, 4000050)
char dpstoff[rule17] 4000049:4000050=4024950
replace dpstoff = 4025560 if inlist(dpstoff, 4000055, 4000060)
char dpstoff[rule18] 4000055:4000060=4025560
replace dpstoff = 5020208 if inlist(dpstoff, 5000002, 5000008)
char dpstoff[rule19] 5000002:5000008=5020208
replace dpstoff = 5023639 if inlist(dpstoff, 5000036, 5000039)
char dpstoff[rule20] 5000036:5000039=5023639
replace dpstoff = 5024044 if inlist(dpstoff, 5000040, 5000044)
char dpstoff[rule21] 5000040:5000044=5024044
replace dpstoff = 5024950 if inlist(dpstoff, 5000049, 5000050)
char dpstoff[rule22] 5000049:5000050=5024950
replace dpstoff = 5025355 if inlist(dpstoff, 5000053, 5000055)
char dpstoff[rule23] 5000053:5000055=5025355
replace dpstoff = 5054960 if inlist(dpstoff, 5024950, 5000053, 5000055, 5000060)
char dpstoff[rule24] 5024950:5000053:5000055:5000060=5054960
replace dpstoff = 1020208 if inlist(dpstoff, 1000002, 1000008)
char dpstoff[rule25] 1000002:1000008=1020208
replace dpstoff = 2021118 if inlist(dpstoff, 2000011, 2000018)
char dpstoff[rule26] 2000011:2000018=2021118
replace dpstoff = 2040218 if inlist(dpstoff, 2020208, 2021118)
char dpstoff[rule27] 2020208:2021118=2040218
replace dpstoff = 2064962 if inlist(dpstoff, 2024950, 2045362)
char dpstoff[rule28] 2024950:2045362=2064962
replace dpstoff = 2110244 if inlist(dpstoff, 2040218, 2072444)
char dpstoff[rule29] 2040218:2072444=2110244
replace dpstoff = 3023940 if inlist(dpstoff, 3000039, 3000040)
char dpstoff[rule30] 3000039:3000040=3023940
replace dpstoff = 3024950 if inlist(dpstoff, 3000049, 3000050)
char dpstoff[rule31] 3000049:3000050=3024950
replace dpstoff = 3050224 if inlist(dpstoff, 3020208, 3021118, 3000024)
char dpstoff[rule32] 3020208:3021118:3000024=3050224
replace dpstoff = 4021824 if inlist(dpstoff, 4000018, 4000024)
char dpstoff[rule33] 4000018:4000024=4021824
replace dpstoff = 4031826 if inlist(dpstoff, 4000026, 4021824)
char dpstoff[rule34] 4000026:4021824=4031826
replace dpstoff = 4035360 if inlist(dpstoff, 4000053, 4025560)
char dpstoff[rule35] 4000053:4025560=4035360
replace dpstoff = 5022426 if inlist(dpstoff, 5000024, 5000026)
char dpstoff[rule36] 5000024:5000026=5022426
replace dpstoff = 5030211 if inlist(dpstoff, 5000011, 5020208)
char dpstoff[rule37] 5000011:5020208=5030211
replace dpstoff = 5064760 if inlist(dpstoff, 5000047, 5054960)
char dpstoff[rule38] 5000047:5054960=5064760
replace dpstoff = 1024950 if inlist(dpstoff, 1000049, 1000050)
char dpstoff[rule39] 1000049:1000050=1024950
replace dpstoff = 2072647 if inlist(dpstoff, 2042639, 2000040, 2000044, 2000047)
char dpstoff[rule40] 2042639:2000040:2000044:2000047=2072647
replace dpstoff = 2074968 if inlist(dpstoff, 2000068, 2064962)
char dpstoff[rule41] 2000068:2064962=2074968
replace dpstoff = 3033944 if inlist(dpstoff, 3000044, 3023940)
char dpstoff[rule42] 3000044:3023940=3033944
replace dpstoff = 3034953 if inlist(dpstoff, 3000053, 3024950)
char dpstoff[rule43] 3000053:3024950=3034953
replace dpstoff = 4054960 if inlist(dpstoff, 4024950, 4035360)
char dpstoff[rule44] 4024950:4035360=4054960
replace dpstoff = 4053647 if inlist(dpstoff, 4000047, 4043644)
char dpstoff[rule45] 4000047:4043644=4053647
replace dpstoff = 5043644 if inlist(dpstoff, 5023639, 5024044)
char dpstoff[rule46] 5023639:5024044=5043644
replace dpstoff = 5055368 if inlist(dpstoff, 5025355, 5026062, 5000068)
char dpstoff[rule47] 5025355:5026062:5000068=5055368
replace dpstoff = 1033640 if inlist(dpstoff, 1000036, 1023940)
char dpstoff[rule48] 1000036:1023940=1033640
replace dpstoff = 3080236 if inlist(dpstoff, 3050224, 3022630, 3000036)
char dpstoff[rule49] 3050224:3022630:3000036=3080236
replace dpstoff = 4026268 if inlist(dpstoff, 4000062, 4000068)
char dpstoff[rule50] 4000062:4000068=4026268
replace dpstoff = 5031826 if inlist(dpstoff, 5000018, 5022426)
char dpstoff[rule51] 5000018:5022426=5031826

* skipping dpstoff == 2023036; 
* no good collapsing rule found for alight_id == 23036
* however rule(s) 1 3 4 may be used for daypart


* skipping dpstoff == 2110244; 
* no good collapsing rule found for alight_id == 110244
* however rule(s) 1 3 4 may be used for daypart

replace dpstoff = 4060226 if inlist(dpstoff, 4030211, 4031826)
char dpstoff[rule52] 4030211:4031826=4060226
replace dpstoff = 5103660 if inlist(dpstoff, 5043644, 5064760)
char dpstoff[rule53] 5043644:5064760=5103660
replace dpstoff = 1054960 if inlist(dpstoff, 1024950, 1025355, 1000060)
char dpstoff[rule54] 1024950:1025355:1000060=1054960
replace dpstoff = 2142668 if inlist(dpstoff, 2072647, 2074968)
char dpstoff[rule55] 2072647:2074968=2142668
replace dpstoff = 3054960 if inlist(dpstoff, 3034953, 3025560)
char dpstoff[rule56] 3034953:3025560=3054960
replace dpstoff = 1025355 if inlist(dpstoff, 1000053, 1000055)
char dpstoff[rule57] 1000053:1000055=1025355
replace dpstoff = 3110244 if inlist(dpstoff, 3080236, 3033944)
char dpstoff[rule58] 3080236:3033944=3110244
replace dpstoff = 4103660 if inlist(dpstoff, 4053647, 4054960)
char dpstoff[rule59] 4053647:4054960=4103660
replace dpstoff = 5060226 if inlist(dpstoff, 5030211, 5031826)
char dpstoff[rule60] 5030211:5031826=5060226
replace dpstoff = 3031826 if inlist(dpstoff, 3000018, 3000024, 3000026)
char dpstoff[rule61] 3000018:3000024:3000026=3031826
replace dpstoff = 5123062 if inlist(dpstoff, 5000030, 5000036, 5000039, 5000040, 5000044, 5000047, 5000049, 5000050, 5000053, 5000055, 5000060, 5000062)
char dpstoff[rule62] 5000030:5000036:5000039:5000040:5000044:5000047:5000049:5000050:5000053:5000055:5000060:5000062=5123062
replace dpstoff = 4123668 if inlist(dpstoff, 4103660, 4026268)
char dpstoff[rule63] 4103660:4026268=4123668
replace dpstoff = 5065369 if inlist(dpstoff, 5000069, 5055368)
char dpstoff[rule64] 5000069:5055368=5065369
replace dpstoff = 1064962 if inlist(dpstoff, 1000062, 1054960)
char dpstoff[rule65] 1000062:1054960=1064962
replace dpstoff = 4070230 if inlist(dpstoff, 4000030, 4060226)
char dpstoff[rule66] 4000030:4060226=4070230

* skipping dpstoff == 5103660; 
* no good collapsing rule found for alight_id == 103660

replace dpstoff = 1050224 if inlist(dpstoff, 1020208, 1021118, 1000024)
char dpstoff[rule67] 1020208:1021118:1000024=1050224
replace dpstoff = 1043644 if inlist(dpstoff, 1000044, 1033640)
char dpstoff[rule68] 1000044:1033640=1043644
replace dpstoff = 2152669 if inlist(dpstoff, 2000069, 2142668)
char dpstoff[rule69] 2000069:2142668=2152669
replace dpstoff = 3120247 if inlist(dpstoff, 3000047, 3110244)
char dpstoff[rule70] 3000047:3110244=3120247
replace dpstoff = 5180262 if inlist(dpstoff, 5060226, 5123062)
char dpstoff[rule71] 5060226:5123062=5180262
replace dpstoff = 3051130 if inlist(dpstoff, 3000011, 3000018, 3000024, 3000026, 3000030)
char dpstoff[rule72] 3000011:3000018:3000024:3000026:3000030=3051130
replace dpstoff = 1060226 if inlist(dpstoff, 1000026, 1050224)
char dpstoff[rule73] 1000026:1050224=1060226
replace dpstoff = 3064962 if inlist(dpstoff, 3000062, 3054960)
char dpstoff[rule74] 3000062:3054960=3064962

char dpstoff[nrules] 74

