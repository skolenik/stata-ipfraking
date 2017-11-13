*** Automatically created on 12 Nov 2017 at 15:37:52
* Source syntax: wgtcellcollapse collapse , variables(daypart board_id) mincellsize(20)         zeroes(39 40 44 49 55 60)         generate(dpston) saving(dpston.do) replace run

generate long dpston = (daypart)*1000000 + board_id

label variable dpston "Long ID of the interaction"
format dpston %12.0f
char dpston[sources] daypart board_id
char dpston[max] 324200269
replace dpston = 1024950 if inlist(dpston, 1000049, 1000050)
char dpston[rule1] 1000049:1000050=1024950
replace dpston = 2024044 if inlist(dpston, 2000040, 2000044)
char dpston[rule2] 2000040:2000044=2024044
replace dpston = 2024950 if inlist(dpston, 2000049, 2000050)
char dpston[rule3] 2000049:2000050=2024950
replace dpston = 2025560 if inlist(dpston, 2000055, 2000060)
char dpston[rule4] 2000055:2000060=2025560
replace dpston = 4023639 if inlist(dpston, 4000036, 4000039)
char dpston[rule5] 4000036:4000039=4023639
replace dpston = 4024044 if inlist(dpston, 4000040, 4000044)
char dpston[rule6] 4000040:4000044=4024044
replace dpston = 4024950 if inlist(dpston, 4000049, 4000050)
char dpston[rule7] 4000049:4000050=4024950
replace dpston = 4025355 if inlist(dpston, 4000053, 4000055)
char dpston[rule8] 4000053:4000055=4025355
replace dpston = 4054960 if inlist(dpston, 4024950, 4000053, 4000055, 4000060)
char dpston[rule9] 4024950:4000053:4000055:4000060=4054960
replace dpston = 5023940 if inlist(dpston, 5000039, 5000040)
char dpston[rule10] 5000039:5000040=5023940
replace dpston = 5024950 if inlist(dpston, 5000049, 5000050)
char dpston[rule11] 5000049:5000050=5024950
replace dpston = 5054960 if inlist(dpston, 5024950, 5025355, 5000060)
char dpston[rule12] 5024950:5025355:5000060=5054960
replace dpston = 2033944 if inlist(dpston, 2000039, 2024044)
char dpston[rule13] 2000039:2024044=2033944
replace dpston = 2034953 if inlist(dpston, 2000053, 2024950)
char dpston[rule14] 2000053:2024950=2034953
replace dpston = 2054960 if inlist(dpston, 2034953, 2025560)
char dpston[rule15] 2034953:2025560=2054960
replace dpston = 3023940 if inlist(dpston, 3000039, 3000040)
char dpston[rule16] 3000039:3000040=3023940
replace dpston = 4043644 if inlist(dpston, 4023639, 4024044)
char dpston[rule17] 4023639:4024044=4043644
replace dpston = 4064760 if inlist(dpston, 4000047, 4054960)
char dpston[rule18] 4000047:4054960=4064760
replace dpston = 5021824 if inlist(dpston, 5000018, 5000024)
char dpston[rule19] 5000018:5000024=5021824
replace dpston = 5033944 if inlist(dpston, 5000044, 5023940)
char dpston[rule20] 5000044:5023940=5033944
replace dpston = 5064760 if inlist(dpston, 5000047, 5054960)
char dpston[rule21] 5000047:5054960=5064760
replace dpston = 2043644 if inlist(dpston, 2000036, 2033944)
char dpston[rule22] 2000036:2033944=2043644
replace dpston = 4072444 if inlist(dpston, 4000024, 4022630, 4043644)
char dpston[rule23] 4000024:4022630:4043644=4072444
replace dpston = 5025355 if inlist(dpston, 5000053, 5000055)
char dpston[rule24] 5000053:5000055=5025355
replace dpston = 2072444 if inlist(dpston, 2000024, 2022630, 2043644)
char dpston[rule25] 2000024:2022630:2043644=2072444
replace dpston = 3033944 if inlist(dpston, 3000044, 3023940)
char dpston[rule26] 3000044:3023940=3033944
replace dpston = 5020102 if inlist(dpston, 5000001, 5000002)
char dpston[rule27] 5000001:5000002=5020102
replace dpston = 5055368 if inlist(dpston, 5025355, 5026062, 5000068)
char dpston[rule28] 5025355:5026062:5000068=5055368
replace dpston = 2020102 if inlist(dpston, 2000001, 2000002)
char dpston[rule29] 2000001:2000002=2020102
replace dpston = 2100844 if inlist(dpston, 2000008, 2021118, 2072444)
char dpston[rule30] 2000008:2021118:2072444=2100844
replace dpston = 3024950 if inlist(dpston, 3000049, 3000050)
char dpston[rule31] 3000049:3000050=3024950
replace dpston = 4031826 if inlist(dpston, 4000018, 4000024, 4000026)
char dpston[rule32] 4000018:4000024:4000026=4031826
replace dpston = 5062644 if inlist(dpston, 5000026, 5023036, 5033944)
char dpston[rule33] 5000026:5023036:5033944=5062644
replace dpston = 1023940 if inlist(dpston, 1000039, 1000040)
char dpston[rule34] 1000039:1000040=1023940
replace dpston = 2050118 if inlist(dpston, 2020102, 2020811, 2000018)
char dpston[rule35] 2020102:2020811:2000018=2050118
replace dpston = 3054960 if inlist(dpston, 3024950, 3025355, 3000060)
char dpston[rule36] 3024950:3025355:3000060=3054960
replace dpston = 4132460 if inlist(dpston, 4072444, 4064760)
char dpston[rule37] 4072444:4064760=4132460
replace dpston = 5081844 if inlist(dpston, 5021824, 5062644)
char dpston[rule38] 5021824:5062644=5081844
replace dpston = 2026268 if inlist(dpston, 2000062, 2000068)
char dpston[rule39] 2000062:2000068=2026268
replace dpston = 2074968 if inlist(dpston, 2054960, 2026268)
char dpston[rule40] 2054960:2026268=2074968
replace dpston = 4020102 if inlist(dpston, 4000001, 4000002)
char dpston[rule41] 4000001:4000002=4020102
replace dpston = 4055368 if inlist(dpston, 4025355, 4026062, 4000068)
char dpston[rule42] 4025355:4026062:4000068=4055368
replace dpston = 4041830 if inlist(dpston, 4000030, 4031826)
char dpston[rule43] 4000030:4031826=4041830
replace dpston = 1025560 if inlist(dpston, 1000055, 1000060)
char dpston[rule44] 1000055:1000060=1025560
replace dpston = 5030108 if inlist(dpston, 5000008, 5020102)
char dpston[rule45] 5000008:5020102=5030108

* skipping dpston == 5055368; 
* no good collapsing rule found for board_id == 55368

replace dpston = 2110847 if inlist(dpston, 2000047, 2100844)
char dpston[rule46] 2000047:2100844=2110847
replace dpston = 3020102 if inlist(dpston, 3000001, 3000002)
char dpston[rule47] 3000001:3000002=3020102
replace dpston = 3062644 if inlist(dpston, 3000026, 3023036, 3033944)
char dpston[rule48] 3000026:3023036:3033944=3062644
replace dpston = 4142462 if inlist(dpston, 4000062, 4132460)
char dpston[rule49] 4000062:4132460=4142462
replace dpston = 5023036 if inlist(dpston, 5000030, 5000036)
char dpston[rule50] 5000030:5000036=5023036
replace dpston = 1034953 if inlist(dpston, 1000053, 1024950)
char dpston[rule51] 1000053:1024950=1034953
replace dpston = 2070126 if inlist(dpston, 2050118, 2000024, 2000026)
char dpston[rule52] 2050118:2000024:2000026=2070126
replace dpston = 4030108 if inlist(dpston, 4000008, 4020102)
char dpston[rule53] 4000008:4020102=4030108
replace dpston = 3025355 if inlist(dpston, 3000053, 3000055)
char dpston[rule54] 3000053:3000055=3025355
replace dpston = 5141860 if inlist(dpston, 5081844, 5064760)
char dpston[rule55] 5081844:5064760=5141860
replace dpston = 5151862 if inlist(dpston, 5000062, 5141860)
char dpston[rule56] 5000062:5141860=5151862
replace dpston = 3064962 if inlist(dpston, 3000062, 3054960)
char dpston[rule57] 3000062:3054960=3064962

* skipping dpston == 4055368; 
* no good collapsing rule found for board_id == 55368
* however rule(s) 2 3 5 may be used for daypart


char dpston[nrules] 57

