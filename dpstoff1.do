*** Automatically created on 13 Nov 2017 at 14:15:56
* Source syntax: wgtcellcollapse collapse , variables(daypart alight_id) mincellsize(20)         generate(dpstoff1) saving(dpstoff1.do) replace run

generate long dpstoff1 = (daypart)*1000000 + alight_id

label variable dpstoff1 "Long ID of the interaction"
format dpstoff1 %12.0f
char dpstoff1[sources] daypart alight_id
char dpstoff1[max] 324200269
replace dpstoff1 = 1020208 if inlist(dpstoff1, 1000002, 1000008)
char dpstoff1[rule1] 1000002:1000008=1020208
replace dpstoff1 = 2020811 if inlist(dpstoff1, 2000008, 2000011)
char dpstoff1[rule2] 2000008:2000011=2020811
replace dpstoff1 = 2021824 if inlist(dpstoff1, 2000018, 2000024)
char dpstoff1[rule3] 2000018:2000024=2021824
replace dpstoff1 = 2034953 if inlist(dpstoff1, 2000049, 2000050, 2000053)
char dpstoff1[rule4] 2000049:2000050:2000053=2034953
replace dpstoff1 = 3020811 if inlist(dpstoff1, 3000008, 3000011)
char dpstoff1[rule5] 3000008:3000011=3020811
replace dpstoff1 = 3023940 if inlist(dpstoff1, 3000039, 3000040)
char dpstoff1[rule6] 3000039:3000040=3023940
replace dpstoff1 = 3024950 if inlist(dpstoff1, 3000049, 3000050)
char dpstoff1[rule7] 3000049:3000050=3024950
replace dpstoff1 = 4021824 if inlist(dpstoff1, 4000018, 4000024)
char dpstoff1[rule8] 4000018:4000024=4021824
replace dpstoff1 = 4031826 if inlist(dpstoff1, 4000026, 4021824)
char dpstoff1[rule9] 4000026:4021824=4031826
replace dpstoff1 = 4025355 if inlist(dpstoff1, 4000053, 4000055)
char dpstoff1[rule10] 4000053:4000055=4025355
replace dpstoff1 = 5020811 if inlist(dpstoff1, 5000008, 5000011)
char dpstoff1[rule11] 5000008:5000011=5020811
replace dpstoff1 = 5022426 if inlist(dpstoff1, 5000024, 5000026)
char dpstoff1[rule12] 5000024:5000026=5022426
replace dpstoff1 = 5025053 if inlist(dpstoff1, 5000050, 5000053)
char dpstoff1[rule13] 5000050:5000053=5025053
replace dpstoff1 = 1024950 if inlist(dpstoff1, 1000049, 1000050)
char dpstoff1[rule14] 1000049:1000050=1024950
replace dpstoff1 = 2031826 if inlist(dpstoff1, 2000026, 2021824)
char dpstoff1[rule15] 2000026:2021824=2031826
replace dpstoff1 = 2050826 if inlist(dpstoff1, 2020811, 2031826)
char dpstoff1[rule16] 2020811:2031826=2050826
replace dpstoff1 = 2044753 if inlist(dpstoff1, 2000047, 2034953)
char dpstoff1[rule17] 2000047:2034953=2044753
replace dpstoff1 = 3022426 if inlist(dpstoff1, 3000024, 3000026)
char dpstoff1[rule18] 3000024:3000026=3022426
replace dpstoff1 = 3033944 if inlist(dpstoff1, 3000044, 3023940)
char dpstoff1[rule19] 3000044:3023940=3033944
replace dpstoff1 = 3034953 if inlist(dpstoff1, 3000053, 3024950)
char dpstoff1[rule20] 3000053:3024950=3034953
replace dpstoff1 = 4053647 if inlist(dpstoff1, 4000036, 4000039, 4000040, 4000044, 4000047)
char dpstoff1[rule21] 4000036:4000039:4000040:4000044:4000047=4053647
replace dpstoff1 = 4055062 if inlist(dpstoff1, 4000050, 4000053, 4000055, 4000060, 4000062)
char dpstoff1[rule22] 4000050:4000053:4000055:4000060:4000062=4055062
replace dpstoff1 = 5043644 if inlist(dpstoff1, 5000036, 5000039, 5000040, 5000044)
char dpstoff1[rule23] 5000036:5000039:5000040:5000044=5043644
replace dpstoff1 = 1023639 if inlist(dpstoff1, 1000036, 1000039)
char dpstoff1[rule24] 1000036:1000039=1023639
replace dpstoff1 = 2133068 if inlist(dpstoff1, 2000030, 2000036, 2000039, 2000040, 2000044, 2000047, 2000049, 2000050, 2000053, 2000055, 2000060, 2000062, 2000068)
char dpstoff1[rule25] 2000030:2000036:2000039:2000040:2000044:2000047:2000049:2000050:2000053:2000055:2000060:2000062:2000068=2133068
replace dpstoff1 = 5031826 if inlist(dpstoff1, 5000018, 5022426)
char dpstoff1[rule26] 5000018:5022426=5031826
replace dpstoff1 = 5044753 if inlist(dpstoff1, 5000047, 5000049, 5025053)
char dpstoff1[rule27] 5000047:5000049:5025053=5044753
replace dpstoff1 = 3043644 if inlist(dpstoff1, 3000036, 3033944)
char dpstoff1[rule28] 3000036:3033944=3043644
replace dpstoff1 = 4055368 if inlist(dpstoff1, 4025355, 4000060, 4000062, 4000068)
char dpstoff1[rule29] 4025355:4000060:4000062:4000068=4055368
replace dpstoff1 = 4041126 if inlist(dpstoff1, 4000011, 4031826)
char dpstoff1[rule30] 4000011:4031826=4041126
replace dpstoff1 = 5053044 if inlist(dpstoff1, 5000030, 5043644)
char dpstoff1[rule31] 5000030:5043644=5053044
replace dpstoff1 = 1054960 if inlist(dpstoff1, 1024950, 1025355, 1000060)
char dpstoff1[rule32] 1024950:1025355:1000060=1054960
replace dpstoff1 = 3044955 if inlist(dpstoff1, 3000055, 3034953)
char dpstoff1[rule33] 3000055:3034953=3044955
replace dpstoff1 = 4075069 if inlist(dpstoff1, 4055062, 4000068, 4000069)
char dpstoff1[rule34] 4055062:4000068:4000069=4075069
replace dpstoff1 = 1025355 if inlist(dpstoff1, 1000053, 1000055)
char dpstoff1[rule35] 1000053:1000055=1025355
replace dpstoff1 = 2180868 if inlist(dpstoff1, 2050826, 2133068)
char dpstoff1[rule36] 2050826:2133068=2180868
replace dpstoff1 = 5050826 if inlist(dpstoff1, 5020811, 5031826)
char dpstoff1[rule37] 5020811:5031826=5050826
replace dpstoff1 = 5026268 if inlist(dpstoff1, 5000062, 5000068)
char dpstoff1[rule38] 5000062:5000068=5026268

* skipping dpstoff1 == 2044753; 
* no good collapsing rule found for alight_id == 44753
* however rule(s) 1 3 4 may be used for daypart

replace dpstoff1 = 4063047 if inlist(dpstoff1, 4000030, 4053647)
char dpstoff1[rule39] 4000030:4053647=4063047
replace dpstoff1 = 5093053 if inlist(dpstoff1, 5053044, 5044753)
char dpstoff1[rule40] 5053044:5044753=5093053
replace dpstoff1 = 1064962 if inlist(dpstoff1, 1000062, 1054960)
char dpstoff1[rule41] 1000062:1054960=1064962
replace dpstoff1 = 3031826 if inlist(dpstoff1, 3000018, 3022426)
char dpstoff1[rule42] 3000018:3022426=3031826
replace dpstoff1 = 3053044 if inlist(dpstoff1, 3000030, 3043644)
char dpstoff1[rule43] 3000030:3043644=3053044
replace dpstoff1 = 4101147 if inlist(dpstoff1, 4041126, 4063047)
char dpstoff1[rule44] 4041126:4063047=4101147

* skipping dpstoff1 == 4055368; 
* no good collapsing rule found for alight_id == 55368
* however rule(s) 2 3 5 may be used for daypart

replace dpstoff1 = 1050224 if inlist(dpstoff1, 1020208, 1021118, 1000024)
char dpstoff1[rule45] 1020208:1021118:1000024=1050224
replace dpstoff1 = 1043644 if inlist(dpstoff1, 1023639, 1000040, 1000044)
char dpstoff1[rule46] 1023639:1000040:1000044=1043644
replace dpstoff1 = 2190869 if inlist(dpstoff1, 2000069, 2180868)
char dpstoff1[rule47] 2000069:2180868=2190869
replace dpstoff1 = 5140853 if inlist(dpstoff1, 5050826, 5093053)
char dpstoff1[rule48] 5050826:5093053=5140853
replace dpstoff1 = 1060226 if inlist(dpstoff1, 1000026, 1050224)
char dpstoff1[rule49] 1000026:1050224=1060226
replace dpstoff1 = 3050826 if inlist(dpstoff1, 3020811, 3031826)
char dpstoff1[rule50] 3020811:3031826=3050826
replace dpstoff1 = 3064962 if inlist(dpstoff1, 3044955, 3000060, 3000062)
char dpstoff1[rule51] 3044955:3000060:3000062=3064962
replace dpstoff1 = 5036269 if inlist(dpstoff1, 5000069, 5026268)
char dpstoff1[rule52] 5000069:5026268=5036269

char dpstoff1[nrules] 52

