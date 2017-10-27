*** Automatically created on 27 Oct 2017 at 12:53:14
* Source syntax: wgtcellcollapse collapse , variables(daypart alight_id) mincellsize(20)         generate(dpstoff) saving(dpstoff.do) replace run

generate long dpstoff = (daypart)*1000000 + alight_id

label variable dpstoff "Long ID of the interaction"
format dpstoff %12.0f
char dpstoff[sources] daypart alight_id
char dpstoff[max] 324200673
replace dpstoff = 1020610 if inlist(dpstoff, 1000006, 1000010)
char dpstoff[rule1] 1000006:1000010=1020610
replace dpstoff = 2021013 if inlist(dpstoff, 2000010, 2000013)
char dpstoff[rule2] 2000010:2000013=2021013
replace dpstoff = 2021721 if inlist(dpstoff, 2000017, 2000021)
char dpstoff[rule3] 2000017:2000021=2021721
replace dpstoff = 2034956 if inlist(dpstoff, 2000049, 2000052, 2000056)
char dpstoff[rule4] 2000049:2000052:2000056=2034956
replace dpstoff = 3021013 if inlist(dpstoff, 3000010, 3000013)
char dpstoff[rule5] 3000010:3000013=3021013
replace dpstoff = 3023639 if inlist(dpstoff, 3000036, 3000039)
char dpstoff[rule6] 3000036:3000039=3023639
replace dpstoff = 3024952 if inlist(dpstoff, 3000049, 3000052)
char dpstoff[rule7] 3000049:3000052=3024952
replace dpstoff = 4021721 if inlist(dpstoff, 4000017, 4000021)
char dpstoff[rule8] 4000017:4000021=4021721
replace dpstoff = 4031725 if inlist(dpstoff, 4000025, 4021721)
char dpstoff[rule9] 4000025:4021721=4031725
replace dpstoff = 4025659 if inlist(dpstoff, 4000056, 4000059)
char dpstoff[rule10] 4000056:4000059=4025659
replace dpstoff = 5021013 if inlist(dpstoff, 5000010, 5000013)
char dpstoff[rule11] 5000010:5000013=5021013
replace dpstoff = 5022125 if inlist(dpstoff, 5000021, 5000025)
char dpstoff[rule12] 5000021:5000025=5022125
replace dpstoff = 5025256 if inlist(dpstoff, 5000052, 5000056)
char dpstoff[rule13] 5000052:5000056=5025256
replace dpstoff = 1024952 if inlist(dpstoff, 1000049, 1000052)
char dpstoff[rule14] 1000049:1000052=1024952
replace dpstoff = 2031725 if inlist(dpstoff, 2000025, 2021721)
char dpstoff[rule15] 2000025:2021721=2031725
replace dpstoff = 2051025 if inlist(dpstoff, 2021013, 2031725)
char dpstoff[rule16] 2021013:2031725=2051025
replace dpstoff = 2044656 if inlist(dpstoff, 2000046, 2034956)
char dpstoff[rule17] 2000046:2034956=2044656
replace dpstoff = 3022125 if inlist(dpstoff, 3000021, 3000025)
char dpstoff[rule18] 3000021:3000025=3022125
replace dpstoff = 3033642 if inlist(dpstoff, 3000042, 3023639)
char dpstoff[rule19] 3000042:3023639=3033642
replace dpstoff = 3034956 if inlist(dpstoff, 3000056, 3024952)
char dpstoff[rule20] 3000056:3024952=3034956
replace dpstoff = 4053246 if inlist(dpstoff, 4000032, 4000036, 4000039, 4000042, 4000046)
char dpstoff[rule21] 4000032:4000036:4000039:4000042:4000046=4053246
replace dpstoff = 4055266 if inlist(dpstoff, 4000052, 4000056, 4000059, 4000063, 4000066)
char dpstoff[rule22] 4000052:4000056:4000059:4000063:4000066=4055266
replace dpstoff = 5043242 if inlist(dpstoff, 5000032, 5000036, 5000039, 5000042)
char dpstoff[rule23] 5000032:5000036:5000039:5000042=5043242
replace dpstoff = 1023236 if inlist(dpstoff, 1000032, 1000036)
char dpstoff[rule24] 1000032:1000036=1023236
replace dpstoff = 2132870 if inlist(dpstoff, 2000028, 2000032, 2000036, 2000039, 2000042, 2000046, 2000049, 2000052, 2000056, 2000059, 2000063, 2000066, 2000070)
char dpstoff[rule25] 2000028:2000032:2000036:2000039:2000042:2000046:2000049:2000052:2000056:2000059:2000063:2000066:2000070=2132870
replace dpstoff = 5031725 if inlist(dpstoff, 5000017, 5022125)
char dpstoff[rule26] 5000017:5022125=5031725
replace dpstoff = 5044656 if inlist(dpstoff, 5000046, 5000049, 5025256)
char dpstoff[rule27] 5000046:5000049:5025256=5044656
replace dpstoff = 3043242 if inlist(dpstoff, 3000032, 3033642)
char dpstoff[rule28] 3000032:3033642=3043242
replace dpstoff = 4055670 if inlist(dpstoff, 4025659, 4000063, 4000066, 4000070)
char dpstoff[rule29] 4025659:4000063:4000066:4000070=4055670
replace dpstoff = 4041325 if inlist(dpstoff, 4000013, 4031725)
char dpstoff[rule30] 4000013:4031725=4041325
replace dpstoff = 5052842 if inlist(dpstoff, 5000028, 5043242)
char dpstoff[rule31] 5000028:5043242=5052842
replace dpstoff = 1054963 if inlist(dpstoff, 1024952, 1025659, 1000063)
char dpstoff[rule32] 1024952:1025659:1000063=1054963
replace dpstoff = 3044959 if inlist(dpstoff, 3000059, 3034956)
char dpstoff[rule33] 3000059:3034956=3044959
replace dpstoff = 4075273 if inlist(dpstoff, 4055266, 4000070, 4000073)
char dpstoff[rule34] 4055266:4000070:4000073=4075273
replace dpstoff = 1025659 if inlist(dpstoff, 1000056, 1000059)
char dpstoff[rule35] 1000056:1000059=1025659
replace dpstoff = 2181070 if inlist(dpstoff, 2051025, 2132870)
char dpstoff[rule36] 2051025:2132870=2181070
replace dpstoff = 5051025 if inlist(dpstoff, 5021013, 5031725)
char dpstoff[rule37] 5021013:5031725=5051025
replace dpstoff = 5026670 if inlist(dpstoff, 5000066, 5000070)
char dpstoff[rule38] 5000066:5000070=5026670

* skipping dpstoff == 2044656; 
* no good collapsing rule found for alight_id == 44656
* however rule(s) 1 3 4 may be used for daypart

replace dpstoff = 4062846 if inlist(dpstoff, 4000028, 4053246)
char dpstoff[rule39] 4000028:4053246=4062846
replace dpstoff = 5092856 if inlist(dpstoff, 5052842, 5044656)
char dpstoff[rule40] 5052842:5044656=5092856
replace dpstoff = 1064966 if inlist(dpstoff, 1000066, 1054963)
char dpstoff[rule41] 1000066:1054963=1064966
replace dpstoff = 3031725 if inlist(dpstoff, 3000017, 3022125)
char dpstoff[rule42] 3000017:3022125=3031725
replace dpstoff = 3052842 if inlist(dpstoff, 3000028, 3043242)
char dpstoff[rule43] 3000028:3043242=3052842
replace dpstoff = 4101346 if inlist(dpstoff, 4041325, 4062846)
char dpstoff[rule44] 4041325:4062846=4101346

* skipping dpstoff == 4055670; 
* no good collapsing rule found for alight_id == 55670
* however rule(s) 2 3 5 may be used for daypart

replace dpstoff = 1050621 if inlist(dpstoff, 1020610, 1021317, 1000021)
char dpstoff[rule45] 1020610:1021317:1000021=1050621
replace dpstoff = 1043242 if inlist(dpstoff, 1023236, 1000039, 1000042)
char dpstoff[rule46] 1023236:1000039:1000042=1043242
replace dpstoff = 2191073 if inlist(dpstoff, 2000073, 2181070)
char dpstoff[rule47] 2000073:2181070=2191073
replace dpstoff = 5141056 if inlist(dpstoff, 5051025, 5092856)
char dpstoff[rule48] 5051025:5092856=5141056
replace dpstoff = 1060625 if inlist(dpstoff, 1000025, 1050621)
char dpstoff[rule49] 1000025:1050621=1060625
replace dpstoff = 3051025 if inlist(dpstoff, 3021013, 3031725)
char dpstoff[rule50] 3021013:3031725=3051025
replace dpstoff = 3064966 if inlist(dpstoff, 3044959, 3000063, 3000066)
char dpstoff[rule51] 3044959:3000063:3000066=3064966
replace dpstoff = 5036673 if inlist(dpstoff, 5000073, 5026670)
char dpstoff[rule52] 5000073:5026670=5036673

char dpstoff[nrules] 52

