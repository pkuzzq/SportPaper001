******************************************************************************
*Arrival of Young Talent: The Send-down Movement and Rural Education in China*
*                                                                            *
*By Yi Chen, Ziyin Fan, Xiaomin Gu, and LiAn Zhou. American Economic Review. *
******************************************************************************
/*
This do-file carries out the analysis using the 1990 census.

Input data files:
census_1990_clean.dta
county_year_data.dta

Output files:
Table 2.txt (Summary Statistics)
Table 3.txt Columns (1)--(7) (The Effect of SDYs on the Educational Attainment of Rural Children)
Table 4.txt (Heterogeneous Effect of SDYs)
Table 6.txt (Addressing Various Confounding Factors)
Table 8.txt Columns (1)--(7) (The Lasting Effect of SDYs on Outcomes other than Education)

Figure 3.txt, census 1990 
*/





**********************************************
*Preparation:                                *
*Compute speed of school construction program*
**********************************************
use "$path1B\county_year_data.dta", clear

foreach s in secondary primary {
	sort countyid year

	bysort countyid: egen Min_year = min(year) if inrange(year,1964,1966)&!missing(school_`s')
	bysort countyid: egen Max_year = max(year) if inrange(year,1975,1977)&!missing(school_`s')

	bysort countyid: egen min_year = mean(Min_year)
	bysort countyid: egen max_year = mean(Max_year)

	gen Min_school = school_`s' if year == min_year
	gen Max_school = school_`s' if year == max_year

	bysort countyid: egen min_school = mean(Min_school)
	bysort countyid: egen max_school = mean(Max_school)

	gen `s'_speed = (max_school-min_school)/(max_year-min_year)
	drop Min_* Max_* min_* max_*
}

drop if secondary_speed ==. | primary_speed == .

keep countyid secondary_speed primary_speed
duplicates drop

save "$path1A\rural_school_expansion.dta", replace





********************************************************************************
*                                                                              *
*             Step 1: Data Preparation and Summary Statistics                  *
*                                                                              *
********************************************************************************
use "$path1B\census_1990_clean.dta", clear

*******************
*Control:1946-1955*
*Treat:  1956-1969*
*******************
gen treat = inrange(year_birth,1956,1969) if inrange(year_birth,1946,1969)

******************
* Define Globals *
******************
global var_abs_cohort "region1990 prov#year_birth c.primary_base#year_birth c.junior_base#year_birth"
global var_abs_cohort2 "region1990 prov#year_birth c.primary_base_older#year_birth c.junior_base_older#year_birth"

************************************
* Generate County Characteristics  *
************************************
*rural school expansion
merge m:1 countyid using "$path1A\rural_school_expansion.dta", nogenerate keep(1 3)

gen speed_primary_density   = primary_speed/(pop1964/1000)
gen speed_secondary_density = secondary_speed/(pop1964/1000)

*intensity of the Great Famine
gen famine = inrange(year_birth,1959,1961) if rural == 1
gen nonfamine = inrange(year_birth,1955,1957) if rural == 1

bysort region1990: egen sum_famine = sum(famine)
bysort region1990: egen sum_nonfamine = sum(nonfamine)

gen ins_famine = 1-sum_famine/sum_nonfamine
drop famine nonfamine sum_famine sum_nonfamine

*extract data for county-level information
preserve
generate cr_info = [victims_cr!=.]
generate grain_info = [grain_output!=.]
generate school_info = !missing(speed_primary_density,speed_secondary_density )

foreach var in yedu primary_graduate junior_graduate {
	replace `var' = . if treat !=0 | rural != 1 // only keep the baseline
}

collapse (mean) countyid pop1964 sdy_density han_ethn primary_graduate junior_graduate victims_cr cr_info grain_info school_info ins_famine, by(region1990)
gen prov = floor(region1990/10000)

save "$path1A\census_1990_county_char.dta", replace
restore

*******************************************************************
*Table 2: Summary Statistics of the 1% Sample from the 1990 Census*
*******************************************************************
gen age = 1990 - year_birth
outsum yedu primary_graduate junior_graduate male han_ethn age if treat==0 & rural==1 using "$path4\Table2.txt", replace
outsum yedu primary_graduate junior_graduate male han_ethn age if treat==0 & rural==0 using "$path4\Table2.txt", append
outsum yedu primary_graduate junior_graduate male han_ethn age if treat==1 & rural==1 using "$path4\Table2.txt", append
outsum yedu primary_graduate junior_graduate male han_ethn age if treat==1 & rural==0 using "$path4\Table2.txt", append





********************************************************************************
*                                                                              *
*                          Step 2: Main Results                                *
*                                                                              *
********************************************************************************
*****************************************************************************
*Table 3: The Effect of SDYs on the Educational Attainment of Rural Children*
*Columns (1)--(7)                                                           *
*****************************************************************************
foreach var in yedu primary_graduate junior_graduate {
	forvalues i = 1/2 {
		if (`i'==1) reghdfe `var' c.sdy_density#c.treat male han_ethn if rural==1, absorb($var_abs_cohort) cluster(region1990)
		if (`i'==2) reghdfe `var' c.sdy_density#c.treat male han_ethn if rural==0, absorb($var_abs_cohort) cluster(region1990)

		summ `var' if e(sample)&treat==0
		local mean = r(mean)
		if (("`var'"=="yedu")&(`i'==1)) outreg2 using "$path4\Table3.txt", replace se nonotes nocons noaster nolabel text addstat(Mean,`mean') keep(c.sdy_density#c.treat male han_ethn) sortvar(c.sdy_density#c.treat male han_ethn)
		if (("`var'"!="yedu")|(`i'!=1)) outreg2 using "$path4\Table3.txt", append  se nonotes nocons noaster nolabel text addstat(Mean,`mean') keep(c.sdy_density#c.treat male han_ethn) sortvar(c.sdy_density#c.treat male han_ethn)
	}
}

keep if rural==1
drop rural // for the remaining analysis, we only use the rural sample

gen treat_placebo = inrange(year_birth,1951,1955) if inrange(year_birth,1946,1955)

reghdfe yedu c.sdy_density#c.treat_placebo male han_ethn, absorb($var_abs_cohort) cluster(region1990)
outreg2 using "$path4\Table3.txt", append se nonotes nocons noaster nolabel text keep(c.sdy_density#c.treat c.sdy_density#c.treat_placebo male han_ethn) sortvar(c.sdy_density#c.treat c.sdy_density#c.treat_placebo male han_ethn)

drop treat_placebo




****************************************************************************************
*Inputs for Figure 3: Effect of SDYs on the Educational Attainment of Different Cohorts*
*Panel B: Census 1990                                                                  *
****************************************************************************************
compress

forvalues y = 1946/1969 {
	gen I`y' = sdy_density*[year_birth==`y']
}

reghdfe yedu I1946-I1969 male han_ethn, absorb($var_abs_cohort2) cluster(region1990)
outreg2 using "$path4\Figure3.txt", replace sideway noparen se nonotes nocons noaster nolabel text keep(I1946-I1969) sortvar(I1946-I1969)

drop I1946-I1969
drop if inrange(year_birth,1941,1945) // these cohorts serve as the baseline in the above regression, and will not be used in the following analysis.

***************************************
*Table 4: Heterogeneous Effect of SDYs*
***************************************
forvalues i = 1/8 {
	if (`i'==1) reghdfe yedu             c.sdy_density#c.treat male han_ethn if male==1                   , absorb($var_abs_cohort) cluster(region1990)
	if (`i'==2) reghdfe yedu             c.sdy_density#c.treat male han_ethn if male==0                   , absorb($var_abs_cohort) cluster(region1990)

	if (`i'==3) reghdfe yedu             c.sdy_density#c.treat male han_ethn if edu_base<5.5              , absorb($var_abs_cohort) cluster(region1990)
	if (`i'==4) reghdfe yedu             c.sdy_density#c.treat male han_ethn if (edu_base>=5.5&edu_base<.), absorb($var_abs_cohort) cluster(region1990)

	if (`i'==5) reghdfe primary_graduate c.sdy_density#c.treat male han_ethn if edu_base<5.5              , absorb($var_abs_cohort) cluster(region1990)
	if (`i'==6) reghdfe junior_graduate  c.sdy_density#c.treat male han_ethn if edu_base<5.5              , absorb($var_abs_cohort) cluster(region1990)

	if (`i'==7) reghdfe primary_graduate c.sdy_density#c.treat male han_ethn if (edu_base>=5.5&edu_base<.), absorb($var_abs_cohort) cluster(region1990)
	if (`i'==8) reghdfe junior_graduate  c.sdy_density#c.treat male han_ethn if (edu_base>=5.5&edu_base<.), absorb($var_abs_cohort) cluster(region1990)

	summ yedu             if e(sample)&treat==0
	local mean1 = r(mean)
	summ primary_graduate if e(sample)&treat==0
	local mean2 = r(mean)
	summ junior_graduate  if e(sample)&treat==0
	local mean3 = r(mean)

	if (`i'==1) outreg2 using "$path4\Table4.txt", replace se nonotes nocons noaster nolabel text addstat(Mean1,`mean1',Mean2,`mean2',Mean3,`mean3') keep(c.sdy_density#c.treat)
	if (`i'!=1) outreg2 using "$path4\Table4.txt", append  se nonotes nocons noaster nolabel text addstat(Mean1,`mean1',Mean2,`mean2',Mean3,`mean3') keep(c.sdy_density#c.treat)
}





********************************************************************************
*                                                                              *
*          Step 3: Contemporaneous Events and Other Outcome Variables          *
*                                                                              *
********************************************************************************
*************************************************
*Table 6: Addressing Various Confounding Factors*
*************************************************
*grain productivity
replace grain_output = grain_output/pop1964

*Cultural Revolution
replace victims_cr = victims_cr/pop1964

gen treat_cr1 = inrange(year_birth,1954,1961)
gen treat_cr2 = inrange(year_birth,1962,1968)

*great famine
gen famine_cohort1 = inrange(year_birth,1955,1958)
gen famine_cohort2 = inrange(year_birth,1959,1961)

*prepare for the interaction terms between school expansion program and SDY
reghdfe yedu c.sdy_density#c.treat c.speed_primary_density#c.treat c.speed_secondary_density#c.treat male han_ethn, absorb($var_abs_cohort) cluster(region1990)

summ speed_secondary_density if e(sample)==1
gen DV_secondary_density = speed_secondary_density - r(mean)

summ speed_primary_density if e(sample)==1
gen DV_primary_density = speed_primary_density - r(mean)

summ sdy_density if e(sample)==1
gen DV_sdy_density = sdy_density - r(mean)

local newvar1  "c.grain_output#c.treat"
local newvar2  "c.speed_primary_density#c.treat c.speed_secondary_density#c.treat"
local newvar3  "c.speed_primary_density#c.treat c.speed_secondary_density#c.treat c.DV_sdy_density#c.treat#c.DV_primary_density c.DV_sdy_density#c.treat#c.DV_secondary_density"
local newvar4  "c.victims_cr#c.treat_cr1 c.victims_cr#c.treat_cr2"
local newvar5  "c.ins_famine#c.famine_cohort1 c.ins_famine#c.famine_cohort2"
local newvar6  "`newvar1' `newvar2' `newvar4' `newvar5'"
local newvar_r c.grain_output#c.treat c.speed_primary_density#c.treat c.speed_secondary_density#c.treat c.DV_sdy_density#c.treat#c.DV_primary_density c.DV_sdy_density#c.treat#c.DV_secondary_density ///
				c.victims_cr#c.treat_cr1 c.victims_cr#c.treat_cr2 c.ins_famine#c.famine_cohort1 c.ins_famine#c.famine_cohort2

capture gen sample = .

forvalues i = 1/6 {
	if (`i'==1) local comm "replace"
	if (`i'!=1) local comm "append"

	reghdfe yedu c.sdy_density#c.treat `newvar`i'' male han_ethn, absorb($var_abs_cohort) cluster(region1990)
	outreg2 using "$path4\Table6_A.txt", `comm' se nonotes nocons noaster nolabel text keep(c.sdy_density#c.treat `newvar_r') sortvar(c.sdy_density#c.treat `newvar_r') 

	replace sample = e(sample)
	reghdfe yedu c.sdy_density#c.treat             male han_ethn if sample == 1, absorb($var_abs_cohort) cluster(region1990)
	outreg2 using "$path4\Table6_B.txt", `comm' se nonotes nocons noaster nolabel text keep(c.sdy_density#c.treat)
}

**********************************************************************
*Table 8: The Lasting Effect of SDYs on Outcomes other than Education*
*Columns (1)--(7)                                                    *
**********************************************************************
gen senior_high = [yedu > 9] if yedu>=9 & yedu<. 
/*According to our definition of yedu, junior high graduates receive 9 years of education.
Going beyond 9 years of education is equivalent to going beyond junior high education.*/

gen occ_highskill = inlist(occisco,2,3) if !inlist(occisco,1,99)

forvalues i = 1/7 {
	if (`i'==1) reghdfe senior_high   c.sdy_density#c.treat      male han_ethn, absorb($var_abs_cohort) cluster(region1990)

	if (`i'==2) reghdfe laborforce    c.sdy_density#c.treat      male han_ethn, absorb($var_abs_cohort) cluster(region1990)
	if (`i'==3) reghdfe laborforce    c.sdy_density#c.treat yedu male han_ethn, absorb($var_abs_cohort) cluster(region1990)

	if (`i'==4) reghdfe occ_highskill c.sdy_density#c.treat      male han_ethn, absorb($var_abs_cohort) cluster(region1990)
	if (`i'==5) reghdfe occ_highskill c.sdy_density#c.treat yedu male han_ethn, absorb($var_abs_cohort) cluster(region1990)

	if (`i'==6) reghdfe teacher       c.sdy_density#c.treat      male han_ethn, absorb($var_abs_cohort) cluster(region1990)
	if (`i'==7) reghdfe teacher       c.sdy_density#c.treat yedu male han_ethn, absorb($var_abs_cohort) cluster(region1990)

	summ `e(depvar)' if e(sample)&treat==0
	local mean = r(mean)

	if (`i'==1) outreg2 using "$path4\Table8.txt", replace se nonotes nocons noaster nolabel text addstat(Mean,`mean') keep(c.sdy_density#c.treat yedu) sortvar(c.sdy_density#c.treat yedu)
	if (`i'!=1) outreg2 using "$path4\Table8.txt", append  se nonotes nocons noaster nolabel text addstat(Mean,`mean') keep(c.sdy_density#c.treat yedu) sortvar(c.sdy_density#c.treat yedu)
}
