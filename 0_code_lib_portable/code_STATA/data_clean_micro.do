******************************************************************************
*无形资产：子女锻炼与家庭环境:来自CFPS的证据*
*                                                                            *
*By Yi Chen, Ziyin Fan, Xiaomin Gu, and LiAn Zhou. American Economic Review. *
******************************************************************************
/*
这个do-file清理了论文中使用的微观层面的数据。

CFPS 包含:个人库、家庭成员库、家庭经济库、跨年核心变量库和少儿家长代答库

Input data files:


1.cfps2018儿童代答

6.县级数据，包括SDY信息（county_data.dta）。

Output files:
1.census_1990_clean.dta
2.census_1982_clean.dta
3.census_2000_clean.dta
4.census_2010_clean.dta
5.CFPS_2010_clean.dta
*/


/* 基本思路
第一，将 CFPS 少儿代答库与成人库、家庭库匹配，包含家庭信息
第二，围绕子女数量计算一些在未来研究中可能用到的变量，如成年子女数量、未成年子女数量、男孩数量、女孩数量、 0-3 岁子女数量等。


他在合并数据后：完善变量标签、单变量清洗、多变量清洗、定义研究样本、变量调整   我在合并数据后：（没有完善变量标签，因为大部分是已存在）、单变量清洗（特殊值转缺失值）、（定义研究样本放在之后）、变量调整
*/
    

	

 


*************************
*	变量计算：因变量      *
*************************



*************************
*	变量计算：人口信息    *
*************************
*cohort
rename qa1y_best year_birth
replace year_birth = 2010 - qa1age if year_birth<0 

*gender
rename gender male

*ethnic
gen han_ethn = [qa5==1] if qa5<.


rename provcd prov

merge m:1 countyid using "$path2B\CFPS_county.dta", nogenerate
drop countyid provcd
rename city region2010

*************************
*	变量计算：人口信息    *
*************************
*cohort
rename qa1y_best year_birth
replace year_birth = 2010 - qa1age if year_birth<0 

*gender
rename gender male

*ethnic
gen han_ethn = [qa5==1] if qa5<.

*************************
*	变量计算：教育成就    *
*************************
gen yedu = (qc105>0)*qc105+(qc205>0)*qc205+(qc305>0&qc301==1)*qc305+(qc405>0&qc401==1)*qc405+ /// 
                     (qc503>0&qc501==1)*qc503+(qc603>0&qc601==1)*qc603+(qc703>0&qc701==1)*qc703
		 
*************************
*	变量计算：控制的焦点  *
*************************
label define agree 1 "Strongly Disagree" 2 "Disagree" 3 "Neither Agree nor Disagree" 4 "Agree" 5 "Strongly Agree" 

foreach i in 704 705 707  {
	replace qm`i' = . if qm`i' == -8 | qm`i' == 6
	recode qm`i' (5=3)(3=4)(4=5)

	label values qm`i' agree
}

forvalues i =501/507 {
	replace qn`i' = . if qn`i' == -8 | qn`i' == 6
	recode qn`i' (5=3)(3=4)(4=5)

	label values qn`i' agree
}


rename (qm704 qm705 qm707 qn501 qn502 qn503 qn504 qn505 qn506 qn507 ) /// 
 (LOC_hard_work LOC_intellect LOC_connection LOC_F_SES LOC_F_wealth LOC_education LOC_talent LOC_effort LOC_luck LOC_F_connection)

foreach var in hard_work intellect connection F_SES F_wealth education talent effort luck F_connection {
	quietly summ LOC_`var'

	gen z_`var' = (LOC_`var' - r(mean))/r(sd)
	if inlist("`var'","luck","F_SES","F_wealth","F_connection","connection") replace z_`var' = -z_`var'
}

egen LOC = rowtotal(z_*)
egen n_miss = rowmiss(z_*)
drop if n_miss > 0 // only keep sample with complete answers

drop z_* n_miss

******************
*Sample Selection*
******************
*drop Beijing/Tianjin/Shanghai
drop if prov==11 | prov==12 | prov==31 

*keep relevant cohorts
keep if inrange(year_birth,1946,1969) 

*keep rural sample
keep if qa2 == 1

*drop sample with missing education information
drop if qc1==.|qc1<0 // 
drop qc1

*keep relevant variables
keep prov male han_ethn region2010 year_birth yedu LOC LOC_*

*keep counties with information on SDY density
merge m:1 region2010 using "$path1A\SDY_2010_match.dta", nogenerate keep(3)
drop if sdy_density == .

*generate harmonized county ID to replace the original ID
merge m:1 region1990 using "$path1A\census_1990_edubase.dta", nogenerate
compress

drop if region2010==.

sort region2010
egen region2010_h = group(region2010)
drop region2010 region1990 primary_base_older junior_base_older edu_base


********************
*Labeling Variables*
********************
label variable prov "province"
label variable male "male=1"
label variable han_ethn "Han=1"
label variable yedu "imputed years of education"
label variable region2010_h "harmonized county ID"
label variable year_birth "birth cohort"

label variable LOC "Locus of Control index"
label variable LOC_hard_work "hard work is rewarded"
label variable LOC_intellect "intellect is rewarded"
label variable LOC_connection "having social connections is more important than individual capability"
label variable LOC_F_SES "the higher a family's social status is, the greater the child's future achievement"
label variable LOC_F_wealth "a child from a rich family has a better chance of success"
label variable LOC_education "the more education one receives, the higher the probability of success"
label variable LOC_talent "the most important factor for one's future success is talent"
label variable LOC_effort "the most important factor for one's future success is effort"
label variable LOC_luck "the most important factor for one's future success is luck"
label variable LOC_F_connection "the most important factor for one's future success is family connection"

label variable primary_base "%primary school graduation (cohorts 1946-1955)"
label variable junior_base  "%junior high graduation (cohorts 1946-1955)"

label define prov 13 "Hebei" 14 "Shanxi" 15 "Inner Mongolia" 21 "Liaoning" 22 "Jilin" ///
23 "Heilongjiang" 32 "Jiangsu" 33 "Zhejiang" 34 "Anhui" 35 "Fujian" 36 "Jiangxi" ///
37 "Shandong" 41 "Henan" 42 "Hubei" 43 "Hunan" 44 "Guangdong" 45 "Guangxi" 46 "Hainan" 50 "Chongqing" ///
51 "Sichuan" 52 "Guizhou" 53 "Yunnan" 54 "Tibet" 61 "Shaanxi" 62 "Gansu" 63 "Qinghai" 64 "Ningxia" 65 "Xinjiang", replace
label value prov prov

save "$path1B\CFPS_2010_clean.dta", replace









********************************************************************************
*                                                                              *
*                        Step 1: Clean Census 1990                             *
*                                                                              *
********************************************************************************
use "$path2A\1990\1990raw.dta", clear

gen region1990 = prov*10000+prefect*100+county

*************************
*Demographic Information*
*************************
*cohort
gen year_birth = floor(age/100)+1000

*gender
gen male = [sex==1] if sex<.

*ethnic
gen han_ethn = [nation==1] if nation<.

*hukou
drop if houstype == 0 
gen rural = [houstype == 1] if houstype<.
gen local_1985 = [usuresid==1] if usuresid<.
gen hukou_transit = inrange(edulevel,5,7)&(edustat==2)

**************************
*Labor Market Information*
**************************
*merge harmonized occ & ind from IPUMS
rename occu occ
gen year = 1990
merge m:1 year occ using "$path2A\IPUMS_OCC_CODE.dta", nogenerate keep(3)
drop year

gen teacher = inrange(occ,111,119)
gen laborforce = !inrange(nworksta,1,7)

*************************
*Educational Achievement*
*************************
gen primary_graduate = inrange(edulevel,3,7)|(edulevel==2 & edustat==2)
gen junior_graduate  = inrange(edulevel,4,7)|(edulevel==3 & edustat==2)

*years of education
gen yedu = .
replace yedu = 0 if edulevel==1

replace yedu=3  if edulevel==2 &  edustat!=2 & edustat!=3
replace yedu=6  if edulevel==2 & (edustat==2 | edustat==3) // primary school
replace yedu=7  if edulevel==3 &  edustat!=2 & edustat!=3 
replace yedu=9  if edulevel==3 & (edustat==2 | edustat==3) // junior high
replace yedu=10 if edulevel==4 &  edustat!=2 & edustat!=3
replace yedu=12 if edulevel==4 & (edustat==2 | edustat==3) // senior high
replace yedu=10 if edulevel==5 &  edustat!=2 & edustat!=3
replace yedu=12 if edulevel==5 & (edustat==2 | edustat==3) // technical secondary
replace yedu=13 if edulevel==6 &  edustat!=2 & edustat!=3
replace yedu=15 if edulevel==6 & (edustat==2 | edustat==3) // associate degree
replace yedu=14 if edulevel==7 &  edustat!=2 & edustat!=3
replace yedu=16 if edulevel==7 & (edustat==2 | edustat==3) // bachelor degree

******************
*Sample Selection*
******************
*drop Beijing/Tianjin/Shanghai
drop if prov==11 | prov==12 | prov==31 

*keep people with local hukou
keep if regstat == 1

*keep relevant cohorts
keep if inrange(year_birth,1941,1969) 

*keep relevant variables
keep prov male han_ethn local_1985 hukou_transit region1990 /*
	*/ year_birth rural yedu primary_graduate junior_graduate /*
 	*/ teacher laborforce occisco

*keep counties with information on SDY density
preserve
use "$path1B\county_data.dta", clear
drop if region1990 == .
drop region1982 region2000 region2010 district
save "$path1A\SDY_1990_match.dta", replace
restore

merge m:1 region1990 using "$path1A\SDY_1990_match.dta", nogenerate keep(3)
drop if sdy_density == .

compress

********************
*Labeling Variables*
********************
label variable prov "province"
label variable male "male=1"
label variable han_ethn "Han=1"
label variable local_1985 "local resident in 1985=1"
label variable hukou_transit "education eligible for hukou transition"
label variable yedu "imputed years of education"
label variable primary_graduate "primary school graduate=1"
label variable junior_graduate  "junior high graduate=1"
label variable region1990 "county ID in 1990"
label variable year_birth "birth cohort"
label variable rural "rural hukou=1"
label variable occisco "occupation code (ISCO-88)"
label variable teacher "teacher as an occupation=1"
label variable laborforce"labor force participation=1"

label define prov 13 "Hebei" 14 "Shanxi" 15 "Inner Mongolia" 21 "Liaoning" 22 "Jilin" ///
	23 "Heilongjiang" 32 "Jiangsu" 33 "Zhejiang" 34 "Anhui" 35 "Fujian" 36 "Jiangxi" ///
	37 "Shandong" 41 "Henan" 42 "Hubei" 43 "Hunan" 44 "Guangdong" 45 "Guangxi" 46 "Hainan" ///
	51 "Sichuan" 52 "Guizhou" 53 "Yunnan" 61 "Shaanxi" 62 "Gansu" 63 "Qinghai" 64 "Ningxia" 65 "Xinjiang", replace
label value prov prov


*baseline county-level education (1946-1955)
gen edu_temp     = yedu             if inrange(year_birth,1946,1955) & rural == 1
gen primary_temp = primary_graduate if inrange(year_birth,1946,1955) & rural == 1
gen junior_temp  = junior_graduate  if inrange(year_birth,1946,1955) & rural == 1

bysort region1990: egen edu_base = mean(edu_temp)
bysort region1990: egen primary_base = mean(primary_temp)
bysort region1990: egen junior_base = mean(junior_temp)
drop edu_temp primary_temp junior_temp

*baseline county-level education for older cohorts (1941-1945)
gen primary_temp = primary_graduate if inrange(year_birth,1941,1945) & rural == 1
gen junior_temp  = junior_graduate  if inrange(year_birth,1941,1945) & rural == 1

bysort region1990: egen primary_base_older = mean(primary_temp)
bysort region1990: egen junior_base_older = mean(junior_temp)
drop primary_temp junior_temp

*extract data for base education
preserve
keep region1990 edu_base* primary_base* junior_base*
duplicates drop
save "$path1A\census_1990_edubase.dta", replace
restore

label variable edu_base "average schooling years (cohorts 1946--1955)"
label variable primary_base "%primary school graduation (cohorts 1946--1955)"
label variable junior_base  "%junior high graduation (cohorts 1946--1955)"
label variable primary_base_older "%primary school graduation (cohorts 1941--1945)"
label variable junior_base_older  "%junior high graduation (cohorts 1941--1945)"

save "$path1B\census_1990_clean.dta", replace





********************************************************************************
*                                                                              *
*                        Step 2: Clean Census 1982                             *
*                                                                              *
********************************************************************************
use "$path2A\1982\1982dta.dta", clear

gen region1982 = province+prefec+county
destring region1982 province, replace
rename province prov

*************************
*Demographic Information*
*************************
*cohort
drop if age == .
gen year_birth = 1982 - age

*gender
gen male = [sex==1] if sex<.

*ethnic
gen han_ethn = [nation==1] if nation<.

*************************
*Educational Achievement*
*************************
recode edulevel (1=16)(2=14)(3=12)(4=9)(5=6)(6=0), gen(yedu)

******************
*Sample Selection*
******************
*drop Beijing/Tianjin/Shanghai
drop if prov==11 | prov==12 | prov==31 

*keep people with local hukou
keep if registat == 1

*keep relevant cohorts
keep if inrange(year_birth,1941,1962) 

*keep rural sample
keep if rural==1

*keep relevant variables
keep prov male han_ethn region1982 year_birth yedu

*keep counties with information on SDY density
preserve
use "$path1B\county_data.dta", clear
drop if region1982 == .
keep region1982 region1990 sdy_density
save "$path1A\SDY_1982_match.dta", replace
restore

merge m:1 region1982 using "$path1A\SDY_1982_match.dta", nogenerate keep(3)
drop if sdy_density == .

compress

********************
*Labeling Variables*
********************
label variable prov "province"
label variable male "male=1"
label variable han_ethn "Han=1"
label variable yedu "imputed years of education"
label variable region1982 "county ID in 1982"
label variable year_birth "birth cohort"

label define prov 13 "Hebei" 14 "Shanxi" 15 "Inner Mongolia" 21 "Liaoning" 22 "Jilin" ///
23 "Heilongjiang" 32 "Jiangsu" 33 "Zhejiang" 34 "Anhui" 35 "Fujian" 36 "Jiangxi" ///
37 "Shandong" 41 "Henan" 42 "Hubei" 43 "Hunan" 44 "Guangdong" 45 "Guangxi" 46 "Hainan" ///
51 "Sichuan" 52 "Guizhou" 53 "Yunnan" 54 "Tibet" 61 "Shaanxi" 62 "Gansu" 63 "Qinghai" 64 "Ningxia" 65 "Xinjiang", replace
label value prov prov

merge m:1 region1990 using "$path1A\census_1990_edubase.dta", keep(1 3) nogenerate keepusing(primary_base_older junior_base_older)

label variable primary_base "%primary school graduation (cohorts 1946--1955)"
label variable junior_base  "%junior high graduation (cohorts 1946--1955)"
label variable primary_base_older "%primary school graduation (cohorts 1941--1945)"
label variable junior_base_older  "%junior high graduation (cohorts 1941--1945)"
drop region1990
save "$path1B\census_1982_clean.dta", replace





********************************************************************************
*                                                                              *
*                        Step 3: Clean Census 2000                             *
*                                                                              *
********************************************************************************
use "$path2A\2000\2000rawnew.dta", clear

gen region2000 = substr(id,1,6)
drop id region
destring region2000, replace

gen prov = floor(region2000/10000)

*************************
*Demographic Information*
*************************
*cohort
drop if age == .
gen year_birth = 2000 - age

*gender
gen male = [sex==1] if sex<.

*ethnic
gen han_ethn = [nation==1] if nation<.

*marriage and children
replace marryy1st = . if marryy1st < 1900
gen age_marry1st = marryy1st - year_birth
gen n_child = numbirm + numbirf // only available to female aged 15--50

*************************
*Educational Achievement*
*************************
recode schooling (0 1=0)(2=3)(3=6)(4=9)(5 6=12)(7=15)(8=16)(9=19), gen(yedu)

******************
*Sample Selection*
******************
*drop Beijing/Tianjin/Shanghai
drop if prov==11 | prov==12 | prov==31 

*keep relevant cohorts
keep if inrange(year_birth,1941,1979) 

*keep rural sample
keep if hukou == 1 & hktype == 1

*keep relevant variables
keep prov male han_ethn region2000 year_birth yedu age_marry1st n_child

*keep counties with information on SDY density
preserve
use "$path1B\county_data.dta", clear
drop if region2000 == .
keep region2000 region1990 sdy_density
save "$path1A\SDY_2000_match.dta", replace
restore

merge m:1 region2000 using "$path1A\SDY_2000_match.dta", nogenerate keep(3)
drop if sdy_density == .

compress

********************
*Labeling Variables*
********************
label variable prov "province"
label variable male "male=1"
label variable han_ethn "Han=1"
label variable yedu "imputed years of education"
label variable region2000 "county ID in 2000"
label variable year_birth "birth cohort"
label variable age_marry1st "age at first marriage"
label variable n_child "number of children ever born"

label define prov 13 "Hebei" 14 "Shanxi" 15 "Inner Mongolia" 21 "Liaoning" 22 "Jilin" ///
	23 "Heilongjiang" 32 "Jiangsu" 33 "Zhejiang" 34 "Anhui" 35 "Fujian" 36 "Jiangxi" ///
	37 "Shandong" 41 "Henan" 42 "Hubei" 43 "Hunan" 44 "Guangdong" 45 "Guangxi" 46 "Hainan" 50 "Chongqing" ///
	51 "Sichuan" 52 "Guizhou" 53 "Yunnan" 61 "Shaanxi" 62 "Gansu" 63 "Qinghai" 64 "Ningxia" 65 "Xinjiang", replace

label value prov prov

merge m:1 region1990 using "$path1A\census_1990_edubase.dta", keep(1 3) nogenerate
drop edu_base

label variable primary_base "%primary school graduation (cohorts 1946--1955)"
label variable junior_base  "%junior high graduation (cohorts 1946--1955)"
label variable primary_base_older "%primary school graduation (cohorts 1941--1945)"
label variable junior_base_older  "%junior high graduation (cohorts 1941--1945)"
drop region1990

save "$path1B\census_2000_clean.dta", replace





********************************************************************************
*                                                                              *
*                        Step 4: Clean Census 2010                             *
*                                                                              *
********************************************************************************
use "$path2A\2010\2010.dta", clear

rename address region2010
gen prov = floor(region2010/10000)

*************************
*Demographic Information*
*************************
*cohort
rename r4_1 year_birth

*gender
gen male = [r3==1] if r3<.

*ethnic
gen han_ethn = [r5==1] if r5<.

*hukou
drop if r11 == . 
gen rural = [r11 == 1] if r11!=.

*************************
*Educational Achievement*
*************************
gen yedu=0 if r15==1
replace yedu=6  if r15==2 & (r16==2 | r16==3)
replace yedu=3  if r15==2 &  r16!=2 & r16!=3
replace yedu=9  if r15==3 & (r16==2 | r16==3)
replace yedu=7  if r15==3 &  r16!=2 & r16!=3
replace yedu=12 if r15==4 & (r16==2 | r16==3)
replace yedu=10 if r15==4 &  r16!=2 & r16!=3
replace yedu=15 if r15==5 & (r16==2 | r16==3)
replace yedu=13 if r15==5 &  r16!=2 & r16!=3
replace yedu=16 if r15==6 & (r16==2 | r16==3)
replace yedu=14 if r15==6 &  r16!=2 & r16!=3
replace yedu=19 if r15==7 & (r16==2 | r16==3)
replace yedu=17 if r15==7 &  r16!=2 & r16!=3

*****************************
*Generate Parent-child Pairs*
*****************************
rename r2 relation

*extract parent treatment status
preserve
keep if relation == 0
gen treat_p = inrange(year_birth,1956,1969) if inrange(year_birth,1946,1969)
keep h1 treat_p

tempfile temp
save `temp', replace
restore

*merge to children
keep if relation == 2
merge m:1 h1 using `temp', nogenerate keep(3)

******************
*Sample Selection*
******************
*drop Beijing/Tianjin/Shanghai
drop if prov==11 | prov==12 | prov==31 

*keep relevant cohorts
keep if treat_p!=. // parents belong to cohorts 1946--1969

*keep rural sample
keep if rural == 1

*keep relevant variables
keep prov male han_ethn region2010 year_birth yedu treat_p

*keep counties with information on SDY density
preserve
use "$path1B\county_data.dta", clear
drop if region2010 == .
keep region2010 region1990 sdy_density
save "$path1A\SDY_2010_match.dta", replace
restore

merge m:1 region2010 using "$path1A\SDY_2010_match.dta", nogenerate keep(3)
drop if sdy_density == .

compress

********************
*Labeling Variables*
********************
label variable prov "province"
label variable male "male=1"
label variable han_ethn "Han=1"
label variable yedu "imputed years of education"
label variable region2010 "county ID in 2010"
label variable year_birth "birth cohort"
label variable treat_p "parental treatment status"

label define prov 13 "Hebei" 14 "Shanxi" 15 "Inner Mongolia" 21 "Liaoning" 22 "Jilin" ///
	23 "Heilongjiang" 32 "Jiangsu" 33 "Zhejiang" 34 "Anhui" 35 "Fujian" 36 "Jiangxi" ///
	37 "Shandong" 41 "Henan" 42 "Hubei" 43 "Hunan" 44 "Guangdong" 45 "Guangxi" 46 "Hainan" 50 "Chongqing" ///
	51 "Sichuan" 52 "Guizhou" 53 "Yunnan" 61 "Shaanxi" 62 "Gansu" 63 "Qinghai" 64 "Ningxia" 65 "Xinjiang", replace

label value prov prov

merge m:1 region1990 using "$path1A\census_1990_edubase.dta", keep(1 3) nogenerate keepusing(primary_base junior_base)

label variable primary_base "%primary school graduation (cohorts 1946--1955)"
label variable junior_base  "%junior high graduation (cohorts 1946--1955)"
drop region1990
save "$path1B\census_2010_clean.dta", replace




erase "$path1A\SDY_1982_match.dta"
erase "$path1A\SDY_1990_match.dta"
erase "$path1A\SDY_2000_match.dta"
erase "$path1A\SDY_2010_match.dta"
erase "$path1A\census_1990_edubase.dta"
