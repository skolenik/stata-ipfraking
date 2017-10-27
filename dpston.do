*** Automatically created on 27 Oct 2017 at 12:52:41
* Source syntax: wgtcellcollapse collapse , variables(daypart board_id) mincellsize(20)         generate(dpston) saving(dpston.do) replace run

generate long dpston = (daypart)*1000000 + board_id

label variable dpston "Long ID of the interaction"
format dpston %12.0f
char dpston[sources] daypart board_id
char dpston[max] 324200673
replace dpston = 2023639 if inlist(dpston, 2000036, 2000039)
char dpston[rule1] 2000036:2000039=2023639
replace dpston = 2025256 if inlist(dpston, 2000052, 2000056)
char dpston[rule2] 2000052:2000056=2025256
replace dpston = 2035259 if inlist(dpston, 2000059, 2025256)
char dpston[rule3] 2000059:2025256=2035259
replace dpston = 3023639 if inlist(dpston, 3000036, 3000039)
char dpston[rule4] 3000036:3000039=3023639
replace dpston = 4043242 if inlist(dpston, 4000032, 4000036, 4000039, 4000042)
char dpston[rule5] 4000032:4000036:4000039:4000042=4043242
replace dpston = 4073252 if inlist(dpston, 4043242, 4024649, 4000052)
char dpston[rule6] 4043242:4024649:4000052=4073252
replace dpston = 5021721 if inlist(dpston, 5000017, 5000021)
char dpston[rule7] 5000017:5000021=5021721
replace dpston = 5023942 if inlist(dpston, 5000039, 5000042)
char dpston[rule8] 5000039:5000042=5023942
replace dpston = 5053952 if inlist(dpston, 5023942, 5024649, 5000052)
char dpston[rule9] 5023942:5024649:5000052=5053952
replace dpston = 2033239 if inlist(dpston, 2000032, 2023639)
char dpston[rule10] 2000032:2023639=2033239
replace dpston = 5025659 if inlist(dpston, 5000056, 5000059)
char dpston[rule11] 5000056:5000059=5025659
replace dpston = 2062139 if inlist(dpston, 2000021, 2022528, 2033239)
char dpston[rule12] 2000021:2022528:2033239=2062139
replace dpston = 3033642 if inlist(dpston, 3000042, 3023639)
char dpston[rule13] 3000042:3023639=3033642
replace dpston = 4102152 if inlist(dpston, 4000021, 4022528, 4073252)
char dpston[rule14] 4000021:4022528:4073252=4102152
replace dpston = 5020306 if inlist(dpston, 5000003, 5000006)
char dpston[rule15] 5000003:5000006=5020306
replace dpston = 5055670 if inlist(dpston, 5025659, 5026366, 5000070)
char dpston[rule16] 5025659:5026366:5000070=5055670
replace dpston = 2020306 if inlist(dpston, 2000003, 2000006)
char dpston[rule17] 2000003:2000006=2020306
replace dpston = 2091039 if inlist(dpston, 2000010, 2021317, 2062139)
char dpston[rule18] 2000010:2021317:2062139=2091039
replace dpston = 3024952 if inlist(dpston, 3000049, 3000052)
char dpston[rule19] 3000049:3000052=3024952
replace dpston = 4031725 if inlist(dpston, 4000017, 4000021, 4000025)
char dpston[rule20] 4000017:4000021:4000025=4031725
replace dpston = 1023639 if inlist(dpston, 1000036, 1000039)
char dpston[rule21] 1000036:1000039=1023639
replace dpston = 2050317 if inlist(dpston, 2020306, 2021013, 2000017)
char dpston[rule22] 2020306:2021013:2000017=2050317
replace dpston = 3054963 if inlist(dpston, 3024952, 3025659, 3000063)
char dpston[rule23] 3024952:3025659:3000063=3054963
replace dpston = 5031725 if inlist(dpston, 5000025, 5021721)
char dpston[rule24] 5000025:5021721=5031725
replace dpston = 5103970 if inlist(dpston, 5053952, 5055670)
char dpston[rule25] 5053952:5055670=5103970
replace dpston = 2065270 if inlist(dpston, 2035259, 2026366, 2000070)
char dpston[rule26] 2035259:2026366:2000070=2065270
replace dpston = 4020306 if inlist(dpston, 4000003, 4000006)
char dpston[rule27] 4000003:4000006=4020306
replace dpston = 4112156 if inlist(dpston, 4000056, 4102152)
char dpston[rule28] 4000056:4102152=4112156
replace dpston = 4074666 if inlist(dpston, 4000046, 4000049, 4000052, 4000056, 4000059, 4000063, 4000066)
char dpston[rule29] 4000046:4000049:4000052:4000056:4000059:4000063:4000066=4074666
replace dpston = 1025963 if inlist(dpston, 1000059, 1000063)
char dpston[rule30] 1000059:1000063=1025963
replace dpston = 4041728 if inlist(dpston, 4000028, 4031725)
char dpston[rule31] 4000028:4031725=4041728
replace dpston = 5030310 if inlist(dpston, 5000010, 5020306)
char dpston[rule32] 5000010:5020306=5030310
replace dpston = 2111046 if inlist(dpston, 2091039, 2000042, 2000046)
char dpston[rule33] 2091039:2000042:2000046=2111046
replace dpston = 3020306 if inlist(dpston, 3000003, 3000006)
char dpston[rule34] 3000003:3000006=3020306
replace dpston = 4084670 if inlist(dpston, 4000070, 4074666)
char dpston[rule35] 4000070:4074666=4084670
replace dpston = 5041728 if inlist(dpston, 5000028, 5031725)
char dpston[rule36] 5000028:5031725=5041728

* skipping dpston == 2065270; 
* no good collapsing rule found for board_id == 65270
* however rule(s) 1 3 4 may be used for daypart

replace dpston = 3062542 if inlist(dpston, 3000025, 3022832, 3033642)
char dpston[rule37] 3000025:3022832:3033642=3062542
replace dpston = 1025256 if inlist(dpston, 1000052, 1000056)
char dpston[rule38] 1000052:1000056=1025256
replace dpston = 2070325 if inlist(dpston, 2050317, 2000021, 2000025)
char dpston[rule39] 2050317:2000021:2000025=2070325
replace dpston = 4030310 if inlist(dpston, 4000010, 4020306)
char dpston[rule40] 4000010:4020306=4030310
replace dpston = 4131356 if inlist(dpston, 4000013, 4000017, 4112156)
char dpston[rule41] 4000013:4000017:4112156=4131356
replace dpston = 5053246 if inlist(dpston, 5000032, 5000036, 5000039, 5000042, 5000046)
char dpston[rule42] 5000032:5000036:5000039:5000042:5000046=5053246
replace dpston = 3025659 if inlist(dpston, 3000056, 3000059)
char dpston[rule43] 3000056:3000059=3025659

* skipping dpston == 5103970; 
* no good collapsing rule found for board_id == 103970

replace dpston = 5161366 if inlist(dpston, 5000013, 5000017, 5000021, 5000025, 5000028, 5000032, 5000036, 5000039, 5000042, 5000046, 5000049, 5000052, 5000056, 5000059, 5000063, 5000066)
char dpston[rule44] 5000013:5000017:5000021:5000025:5000028:5000032:5000036:5000039:5000042:5000046:5000049:5000052:5000056:5000059:5000063:5000066=5161366
replace dpston = 2122866 if inlist(dpston, 2000028, 2000032, 2000036, 2000039, 2000042, 2000046, 2000049, 2000052, 2000056, 2000059, 2000063, 2000066)
char dpston[rule45] 2000028:2000032:2000036:2000039:2000042:2000046:2000049:2000052:2000056:2000059:2000063:2000066=2122866
replace dpston = 3064966 if inlist(dpston, 3000066, 3054963)
char dpston[rule46] 3000066:3054963=3064966

char dpston[nrules] 46

