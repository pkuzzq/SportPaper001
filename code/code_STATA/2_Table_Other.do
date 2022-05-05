******************************************************************************
*Arrival of Young Talent: The Send-down Movement and Rural Education in China*
*                                                                            *
*By Yi Chen, Ziyin Fan, Xiaomin Gu, and LiAn Zhou. American Economic Review. *
******************************************************************************
/*
This do-file carries out the analysis using data other than the 1990 census, 
including 1982/2000/2010 censuses, the 2010 wave of CFPS, and our county-by-year data.

Input data files:
census_1982_clean.dta
census_2000_clean.dta
census_2010_clean.dta
county_year_data.dta
CFPS_2010_clean.dta

Output files:
Table 3.txt Column (8) (The Effect of SDYs on the Educational Attainment of Rural Children)
Table 5.txt (Effects of SDYs on the Supply of Local Teachers and Educational Fiscal Expenses, 1955--1977)
Table 7.txt (The Effect of SDYs on Local People's Locus of Control)
Table 8.txt Columns (8)--(10) (The Lasting Effect of SDYs on Outcomes other than Education)

Figure 3.txt, census 1982/2010 
*/





********************************************************************************
*                                                                              *
*                    Step 1: Analysis using the 1982 Census                    *
*                                                                              *
********************************************************************************
global var_abs_cohort2 "region1982 prov#year_birth c.primary_base_older#year_birth c.junior_base_older#year_birth"

use "$path1B\census_1982_clean.dta", clear


****************************************************************************************
*Inputs for Figure 3: Effect of SDYs on the Educational Attainment of Different Cohorts*
*Panel A: Census 1982                                                                  *
****************************************************************************************
forvalues y = 1946/1962 {
	gen I`y' = sdy_density*[year_birth==`y']
}

reghdfe yedu I1946-I1962 male han_ethn, absorb($var_abs_cohort2) cluster(region1982)
outreg2 using "$path4\Figure3.txt", append sideway noparen se nonotes nocons noaster nolabel text keep(I1946-I1962) sortvar(I1946-I1962)





********************************************************************************
*                                                                              *
*                    Step 2: Analysis using the 2000 Census                    *
*                                                                              *
********************************************************************************
global var_abs_cohort  "region2000 prov#year_birth c.primary_base#year_birth c.junior_base#year_birth"
global var_abs_cohort2 "region2000 prov#year_birth c.primary_base_older#year_birth c.junior_base_older#year_birth"

use "$path1B\census_2000_clean.dta", clear


*****************************************************************************
*Table 3: The Effect of SDYs on the Educational Attainment of Rural Children*
*Columns (8)                                                                *
*****************************************************************************
gen treat_placebo = inrange(year_birth,1975,1979) if inrange(year_birth,1970,1979)

reghdfe yedu c.sdy_density#c.treat_placebo male han_ethn, absorb($var_abs_cohort) cluster(region2000)
outreg2 using "$path4\Table3.txt", append se nonotes nocons noaster nolabel text keep(c.sdy_density#c.treat c.sdy_density#c.treat_placebo male han_ethn) sortvar(c.sdy_density#c.treat c.sdy_density#c.treat_placebo male han_ethn)

drop treat_placebo

****************************************************************************************
*Inputs for Figure 3: Effect of SDYs on the Educational Attainment of Different Cohorts*
*Panel C: Census 2000                                                                  *
****************************************************************************************
forvalues y = 1946/1979 {
	gen I`y' = sdy_density*[year_birth==`y']
}

reghdfe yedu I1946-I1979 male han_ethn, absorb($var_abs_cohort2) cluster(region2000)
outreg2 using "$path4\Figure3.txt", append sideway noparen se nonotes nocons noaster nolabel text keep(I1946-I1979) sortvar(I1946-I1979)

drop I1946-I1979

**********************************************************************
*Table 8: The Lasting Effect of SDYs on Outcomes other than Education*
*Columns (8)--(9)                                                    *
**********************************************************************
gen treat = inrange(year_birth,1956,1969) if inrange(year_birth,1946,1969)

forvalues i = 1/2 {
	if (`i'==1) reghdfe age_marry1st c.sdy_density#c.treat male han_ethn, absorb($var_abs_cohort) cluster(region2000)
	if (`i'==2) reghdfe n_child      c.sdy_density#c.treat male han_ethn, absorb($var_abs_cohort) cluster(region2000)
	
	summ `e(depvar)' if e(sample)&treat==0
	local mean = r(mean)
	outreg2 using "$path4\Table8.txt", append se nonotes nocons noaster nolabel text addstat(Mean,`mean') keep(c.sdy_density#c.treat)
}





********************************************************************************
*                                                                              *
*                    Step 3: Analysis using the 2010 Census                    *
*                                                                              *
********************************************************************************
global var_abs_cohort  "region2010 prov#year_birth c.primary_base#year_birth c.junior_base#year_birth"

use "$path1B\census_2010_clean.dta", clear
rename treat_p treat

**********************************************************************
*Table 8: The Lasting Effect of SDYs on Outcomes other than Education*
*Columns (10)                                                        *
**********************************************************************
reghdfe yedu c.sdy_density#c.treat male han_ethn, absorb($var_abs_cohort) cluster(region2010)
summ `e(depvar)' if e(sample)&treat==0
local mean = r(mean)
outreg2 using "$path4\Table8.txt", append se nonotes nocons noaster nolabel text addstat(Mean,`mean') keep(c.sdy_density#c.treat) sortvar(c.sdy_density#c.treat)





********************************************************************************
*                                                                              *
*                    Step 4: Analysis using the 2010 CFPS                      *
*                                                                              *
********************************************************************************
global var_abs_cohort "region2010_h prov#year_birth c.primary_base#year_birth c.junior_base#year_birth"

use "$path1B\CFPS_2010_clean.dta", clear

gen treat = inrange(year_birth,1956,1969) if inrange(year_birth,1946,1969)

eststo clear
foreach var of varlist LOC LOC_education LOC_talent LOC_effort LOC_hard_work LOC_intellect LOC_F_SES LOC_F_wealth LOC_F_connection LOC_luck LOC_connection {
	eststo: reghdfe `var' c.sdy_density#c.treat male han_ethn, vce(cluster region2010_h) absorb($var_abs_cohort)
}
outreg2 [*] using "$path4\Table7_A.txt", se nonotes nocons noaster nolabel bdec(3) text replace keep(c.sdy_density#c.treat) sortvar(c.sdy_density#c.treat)

eststo clear
foreach var of varlist LOC LOC_education LOC_talent LOC_effort LOC_hard_work LOC_intellect LOC_F_SES LOC_F_wealth LOC_F_connection LOC_luck LOC_connection {
	eststo: reghdfe `var' c.sdy_density#c.treat male han_ethn yedu, vce(cluster region2010_h) absorb($var_abs_cohort)
}
outreg2 [*] using "$path4\Table7_B.txt", se nonotes nocons noaster nolabel bdec(3) text replace keep(c.sdy_density#c.treat yedu) sortvar(c.sdy_density#c.treat yedu)





********************************************************************************
*                                                                              *
*          Step 5: Analysis using our county-by-year data                      *
*                                                                              *
********************************************************************************
use "$path1B\county_year_data.dta", clear

keep if inrange(year,1955,1977)
drop if sdy_density == .

gen postSDY = [year >= 1968] if inrange(year,1955,1977)

foreach i in pri sec {
	foreach j in total state nonst {
		gen ratio_`i'_`j' = tch_`i'_`j'/pop1964
	}
}

gen fiscal_edu_pc = log(10000*fiscal_edu/pop1964)

eststo clear

forvalues i = 1/7 {
	if (`i'==1) reghdfe ratio_pri_total c.sdy_density#c.postSDY, cluster(countyid) absorb(countyid year#prov)
	if (`i'==2) reghdfe ratio_pri_state c.sdy_density#c.postSDY, cluster(countyid) absorb(countyid year#prov)
	if (`i'==3) reghdfe ratio_pri_nonst c.sdy_density#c.postSDY, cluster(countyid) absorb(countyid year#prov)
	if (`i'==4) reghdfe ratio_sec_total c.sdy_density#c.postSDY, cluster(countyid) absorb(countyid year#prov)
	if (`i'==5) reghdfe ratio_sec_state c.sdy_density#c.postSDY, cluster(countyid) absorb(countyid year#prov)
	if (`i'==6) reghdfe ratio_sec_nonst c.sdy_density#c.postSDY, cluster(countyid) absorb(countyid year#prov)
	if (`i'==7) reghdfe fiscal_edu_pc   c.sdy_density#c.postSDY, cluster(countyid) absorb(countyid year#prov)

	unique countyid if e(sample)
	local count = r(unique)

	if (`i'==1) outreg2 using "$path4\Table5.txt", se nonotes nocons noaster nolabel bdec(3) text replace addstat(Ncounty,`count') keep(c.sdy_density#c.postSDY) 
	if (`i'!=1) outreg2 using "$path4\Table5.txt", se nonotes nocons noaster nolabel bdec(3) text append  addstat(Ncounty,`count') keep(c.sdy_density#c.postSDY) 
}
