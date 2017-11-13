*** Automatically created on 13 Nov 2017 at 14:15:19
* Source syntax: wgtcellcollapse collapse , variables(daypart board_id) mincellsize(20)         generate(dpston1) saving(dpston1.do) replace run

generate long dpston1 = (daypart)*1000000 + board_id

label variable dpston1 "Long ID of the interaction"
format dpston1 %12.0f
char dpston1[sources] daypart board_id
char dpston1[max] 324200269
replace dpston1 = 2023940 if inlist(dpston1, 2000039, 2000040)
char dpston1[rule1] 2000039:2000040=2023940
replace dpston1 = 2025053 if inlist(dpston1, 2000050, 2000053)
char dpston1[rule2] 2000050:2000053=2025053
replace dpston1 = 2035055 if inlist(dpston1, 2000055, 2025053)
char dpston1[rule3] 2000055:2025053=2035055
replace dpston1 = 3023940 if inlist(dpston1, 3000039, 3000040)
char dpston1[rule4] 3000039:3000040=3023940
replace dpston1 = 4043644 if inlist(dpston1, 4000036, 4000039, 4000040, 4000044)
char dpston1[rule5] 4000036:4000039:4000040:4000044=4043644
replace dpston1 = 4073650 if inlist(dpston1, 4043644, 4024749, 4000050)
char dpston1[rule6] 4043644:4024749:4000050=4073650
replace dpston1 = 5021824 if inlist(dpston1, 5000018, 5000024)
char dpston1[rule7] 5000018:5000024=5021824
replace dpston1 = 5024044 if inlist(dpston1, 5000040, 5000044)
char dpston1[rule8] 5000040:5000044=5024044
replace dpston1 = 5054050 if inlist(dpston1, 5024044, 5024749, 5000050)
char dpston1[rule9] 5024044:5024749:5000050=5054050
replace dpston1 = 2033640 if inlist(dpston1, 2000036, 2023940)
char dpston1[rule10] 2000036:2023940=2033640
replace dpston1 = 5025355 if inlist(dpston1, 5000053, 5000055)
char dpston1[rule11] 5000053:5000055=5025355
replace dpston1 = 2062440 if inlist(dpston1, 2000024, 2022630, 2033640)
char dpston1[rule12] 2000024:2022630:2033640=2062440
replace dpston1 = 3033944 if inlist(dpston1, 3000044, 3023940)
char dpston1[rule13] 3000044:3023940=3033944
replace dpston1 = 4102450 if inlist(dpston1, 4000024, 4022630, 4073650)
char dpston1[rule14] 4000024:4022630:4073650=4102450
replace dpston1 = 5020102 if inlist(dpston1, 5000001, 5000002)
char dpston1[rule15] 5000001:5000002=5020102
replace dpston1 = 5055368 if inlist(dpston1, 5025355, 5026062, 5000068)
char dpston1[rule16] 5025355:5026062:5000068=5055368
replace dpston1 = 2020102 if inlist(dpston1, 2000001, 2000002)
char dpston1[rule17] 2000001:2000002=2020102
replace dpston1 = 2090840 if inlist(dpston1, 2000008, 2021118, 2062440)
char dpston1[rule18] 2000008:2021118:2062440=2090840
replace dpston1 = 3024950 if inlist(dpston1, 3000049, 3000050)
char dpston1[rule19] 3000049:3000050=3024950
replace dpston1 = 4031826 if inlist(dpston1, 4000018, 4000024, 4000026)
char dpston1[rule20] 4000018:4000024:4000026=4031826
replace dpston1 = 1023940 if inlist(dpston1, 1000039, 1000040)
char dpston1[rule21] 1000039:1000040=1023940
replace dpston1 = 2050118 if inlist(dpston1, 2020102, 2020811, 2000018)
char dpston1[rule22] 2020102:2020811:2000018=2050118
replace dpston1 = 3054960 if inlist(dpston1, 3024950, 3025355, 3000060)
char dpston1[rule23] 3024950:3025355:3000060=3054960
replace dpston1 = 5031826 if inlist(dpston1, 5000026, 5021824)
char dpston1[rule24] 5000026:5021824=5031826
replace dpston1 = 5104068 if inlist(dpston1, 5054050, 5055368)
char dpston1[rule25] 5054050:5055368=5104068
replace dpston1 = 2065068 if inlist(dpston1, 2035055, 2026062, 2000068)
char dpston1[rule26] 2035055:2026062:2000068=2065068
replace dpston1 = 4020102 if inlist(dpston1, 4000001, 4000002)
char dpston1[rule27] 4000001:4000002=4020102
replace dpston1 = 4112453 if inlist(dpston1, 4000053, 4102450)
char dpston1[rule28] 4000053:4102450=4112453
replace dpston1 = 4074762 if inlist(dpston1, 4000047, 4000049, 4000050, 4000053, 4000055, 4000060, 4000062)
char dpston1[rule29] 4000047:4000049:4000050:4000053:4000055:4000060:4000062=4074762
replace dpston1 = 4041830 if inlist(dpston1, 4000030, 4031826)
char dpston1[rule30] 4000030:4031826=4041830
replace dpston1 = 1025560 if inlist(dpston1, 1000055, 1000060)
char dpston1[rule31] 1000055:1000060=1025560
replace dpston1 = 5030108 if inlist(dpston1, 5000008, 5020102)
char dpston1[rule32] 5000008:5020102=5030108
replace dpston1 = 2110847 if inlist(dpston1, 2090840, 2000044, 2000047)
char dpston1[rule33] 2090840:2000044:2000047=2110847
replace dpston1 = 3020102 if inlist(dpston1, 3000001, 3000002)
char dpston1[rule34] 3000001:3000002=3020102
replace dpston1 = 4084768 if inlist(dpston1, 4000068, 4074762)
char dpston1[rule35] 4000068:4074762=4084768
replace dpston1 = 5041830 if inlist(dpston1, 5000030, 5031826)
char dpston1[rule36] 5000030:5031826=5041830

* skipping dpston1 == 2065068; 
* no good collapsing rule found for board_id == 65068
* however rule(s) 1 3 4 may be used for daypart

replace dpston1 = 3062644 if inlist(dpston1, 3000026, 3023036, 3033944)
char dpston1[rule37] 3000026:3023036:3033944=3062644
replace dpston1 = 1025053 if inlist(dpston1, 1000050, 1000053)
char dpston1[rule38] 1000050:1000053=1025053
replace dpston1 = 2070126 if inlist(dpston1, 2050118, 2000024, 2000026)
char dpston1[rule39] 2050118:2000024:2000026=2070126
replace dpston1 = 4030108 if inlist(dpston1, 4000008, 4020102)
char dpston1[rule40] 4000008:4020102=4030108
replace dpston1 = 4131153 if inlist(dpston1, 4000011, 4000018, 4112453)
char dpston1[rule41] 4000011:4000018:4112453=4131153
replace dpston1 = 5053647 if inlist(dpston1, 5000036, 5000039, 5000040, 5000044, 5000047)
char dpston1[rule42] 5000036:5000039:5000040:5000044:5000047=5053647
replace dpston1 = 3025355 if inlist(dpston1, 3000053, 3000055)
char dpston1[rule43] 3000053:3000055=3025355

* skipping dpston1 == 5104068; 
* no good collapsing rule found for board_id == 104068

replace dpston1 = 5161162 if inlist(dpston1, 5000011, 5000018, 5000024, 5000026, 5000030, 5000036, 5000039, 5000040, 5000044, 5000047, 5000049, 5000050, 5000053, 5000055, 5000060, 5000062)
char dpston1[rule44] 5000011:5000018:5000024:5000026:5000030:5000036:5000039:5000040:5000044:5000047:5000049:5000050:5000053:5000055:5000060:5000062=5161162
replace dpston1 = 2123062 if inlist(dpston1, 2000030, 2000036, 2000039, 2000040, 2000044, 2000047, 2000049, 2000050, 2000053, 2000055, 2000060, 2000062)
char dpston1[rule45] 2000030:2000036:2000039:2000040:2000044:2000047:2000049:2000050:2000053:2000055:2000060:2000062=2123062
replace dpston1 = 3064962 if inlist(dpston1, 3000062, 3054960)
char dpston1[rule46] 3000062:3054960=3064962

char dpston1[nrules] 46

