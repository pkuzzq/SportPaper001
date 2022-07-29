******************************************************************************
*Arrival of Young Talent: The Send-down Movement and Rural Education in China*
*                                                                            *
*By Yi Chen, Ziyin Fan, Xiaomin Gu, and LiAn Zhou. American Economic Review. *
******************************************************************************
/*
This do-file generates all the tables in the appendix.

Input data files:
census_1990_clean.dta
county_data.dta
county_year_data.dta
census_1990_county_char.dta (generated from 1_Table_Census_1990.do)
rural_school_expansion.dta (generated from 1_Table_Census_1990.do) 

Output files:
Table A1.txt (Knowledge Gap and the Effect of SDYs)
Table A3.txt (The Effect of SDYs on Occupational Choice)
Table B1.txt (Count of Number of Counties)
Table B2.txt (Correlation between County-level Information Availability and County Characteristics)
Table C1.txt Column (1) (Comparing the Number of Received SDYs from County-aggregate with that from National Report in Each Province)          
Table D1.txt (Robustness Check with Different Specifications)
Table D2.txt (Other Robustness Checks)
*/




********************************************************************************
*                                                                              *
*                            Tables in Appendix A                              *
*                                                                              *
********************************************************************************
use "$path1B\census_1990_clean.dta", clear
global var_abs_cohort "region1990 prov#year_birth c.primary_base#year_birth c.junior_base#year_birth"

keep if inrange(year_birth,1946,1969)
gen treat = inrange(year_birth,1956,1969) if inrange(year_birth,1946,1969)

***********************************************************
* generate base education level for both rural and urban  *
***********************************************************
gen edu_temp_urban = yedu if treat == 0 & rural == 0 

gen prefec = floor(region1990/100)
bysort region1990: egen edu_base_urban1 = mean(edu_temp_urban)
bysort prefec    : egen edu_base_urban2 = mean(edu_temp_urban)
bysort prov      : egen edu_base_urban3 = mean(edu_temp_urban)

drop edu_temp_urban

**************************************************
* Table A1: Knowledge Gap and the Effect of SDYs *
**************************************************
forvalues i = 1/3 {
	gen edu_base_diff`i' = edu_base_urban`i' - edu_base

	summ edu_base_diff`i' if !missing(yedu,sdy_density,edu_base_diff`i',treat) & rural==1
	gen DV_edu_base_diff`i' = edu_base_diff`i' - r(mean)

	summ sdy_density if !missing(yedu,sdy_density,edu_base_diff`i',treat) & rural==1
	gen DV_sdy_density = sdy_density - r(mean)	

	reghdfe yedu c.sdy_density#c.treat c.treat#c.edu_base_diff`i' c.DV_sdy_density#c.treat#c.DV_edu_base_diff`i' male han_ethn if rural==1, absorb($var_abs_cohort) cluster(region1990)
	if (`i'==1) outreg2 using "$path4\TableA1.txt", replace se nonotes nocons noaster nolabel text keep(c.sdy_density#c.treat c.DV_sdy_density#c.treat#c.DV_edu_base_diff`i')
	if (`i'!=1) outreg2 using "$path4\TableA1.txt", append  se nonotes nocons noaster nolabel text keep(c.sdy_density#c.treat c.DV_sdy_density#c.treat#c.DV_edu_base_diff`i')

	drop DV_edu_base_diff`i' DV_sdy_density
}
drop edu_base_diff* edu_base_urban*


*******************************************************
* Table A3: The Effect of SDYs on Occupational Choice *
*******************************************************
forvalues i = 1/9 {
	gen O`i' = [occisco==`i'] if occisco!=99
}

forvalues i = 1/9 {
	reghdfe O`i' c.sdy_density#c.treat male han_ethn if rural==1, absorb($var_abs_cohort) cluster(region1990)

	summ `e(depvar)' if e(sample)&treat==0
	local mean = r(mean)

	if (`i'==1) outreg2 using "$path4\TableA3.txt", replace se nonotes nocons noaster nolabel text addstat(Mean,`mean') keep(c.sdy_density#c.treat)
	if (`i'!=1) outreg2 using "$path4\TableA3.txt", append  se nonotes nocons noaster nolabel text addstat(Mean,`mean') keep(c.sdy_density#c.treat)
}
drop O1-O9 occisco





********************************************************************************
*                                                                              *
*                            Tables in Appendix B                              *
*                                                                              *
********************************************************************************
*********************************************************************
* Prepare the information availability of county-by-year level data *
*********************************************************************
use "$path1B\county_year_data.dta", clear
keep if inrange(year,1955,1977)
keep if sdy_density != .

bysort countyid: egen count1 = count(tch_sec_total)
bysort countyid: egen count2 = count(tch_pri_total)
bysort countyid: egen count3 = count(fiscal_edu)

gen share_nonmissing_teacher = (count1 + count2)/46
gen share_nonmissing_fiscal = (count3)/23

keep countyid share_nonmissing_teacher share_nonmissing_fiscal
duplicates drop

save "$path1A\teacher_fiscal_info.dta", replace

*****************************************
* Table B1: Count of Number of Counties *
*****************************************
use "$path1B\county_data.dta", clear

drop if region1990 == .
merge 1:1 countyid using "$path1A\teacher_fiscal_info.dta", nogenerate keep(1 3)
merge m:1 countyid using "$path1A\rural_school_expansion.dta", nogenerate keep(1 3)
replace share_nonmissing_teacher = 0 if share_nonmissing_teacher == .
replace share_nonmissing_fiscal =  0 if share_nonmissing_fiscal  == .

unique region1990
scalar r1 = r(unique) // number in Panel A, row 1

gen prov = floor(region1990/10000)
unique region1990 if !inlist(prov,11,12,31)
scalar r2 = r(unique) // number in Panel A, row 2

unique region1990 if !inlist(prov,11,12,31) & district!=1
scalar r3 = r(unique) // number in Panel A, row 3

unique region1990 if !inlist(prov,11,12,31) & district!=1 & sdy!=.
scalar r4 = r(unique) // number in Panel A, row 4

unique region1990 if !inlist(prov,11,12,31) & district!=1 & sdy!=. & pop1964!=.
scalar r5 = r(unique) // number in Panel A, row 5

*Panel B is conditional on "core counties"
keep if !inlist(prov,11,12,31) & district!=1 & sdy!=. & pop1964!=.
scalar r6 = .

unique region1990 if grain_output !=.
scalar r9 = r(unique) // number in Panel B, row 3

unique region1990 if !missing(secondary_speed,primary_speed)
scalar r12 = r(unique) // number in Panel B, row 6

unique region1990 if !missing(victims_cr)
scalar r13 = r(unique) // number in Panel B, row 7

*For the following variables, they don't have to show up in the 1990 census.
use "$path1B\county_data.dta", clear
merge 1:1 countyid using "$path1A\teacher_fiscal_info.dta", nogenerate keep(1 3)
merge m:1 countyid using "$path1A\rural_school_expansion.dta", nogenerate keep(1 3)
replace share_nonmissing_teacher = 0 if share_nonmissing_teacher == .
replace share_nonmissing_fiscal =  0 if share_nonmissing_fiscal  == .

gen prov = floor(region1990/10000)
keep if !inlist(prov,11,12,31) & district!=1 & sdy!=. & pop1964!=.

unique countyid if share_nonmissing_teacher > 0
scalar r7 = r(unique) // number in Panel B, row 1
summ share_nonmissing_teacher if share_nonmissing_teacher > 0 
scalar r8 = r(mean) // number in Panel B, row 2

unique countyid if share_nonmissing_fiscal > 0
scalar r10 = r(unique) // number in Panel B, row 4
summ share_nonmissing_fiscal if share_nonmissing_fiscal > 0 
scalar r11 = r(mean) // number in Panel B, row 5

clear
set obs 13
gen num = .
forvalues i = 1/13 {
	replace num = r`i' in `i'
}
outsheet using "$path4\TableB1.txt", replace



**************************************************************************************************
* Table B2: Correlation between County-level Information Availability and County Characteristics *
**************************************************************************************************
use "$path1A\census_1990_county_char.dta", clear
merge 1:1 countyid using "$path1A\teacher_fiscal_info.dta", keep(1 3) nogenerate

gen minority = 1 - han_ethn
replace victims_cr = victims_cr/pop1964
replace share_nonmissing_teacher = 0 if share_nonmissing_teacher == .
replace share_nonmissing_fiscal  =  0 if share_nonmissing_fiscal  == .

eststo clear
eststo: reghdfe sdy_density                          primary_graduate junior_graduate minority ins_famine, vce(robust) absorb(prov)
eststo: reghdfe sdy_density              victims_cr  primary_graduate junior_graduate minority ins_famine, vce(robust) absorb(prov)

eststo: reghdfe share_nonmissing_teacher sdy_density primary_graduate junior_graduate minority ins_famine, vce(robust) absorb(prov)
eststo: reghdfe grain_info               sdy_density primary_graduate junior_graduate minority ins_famine, vce(robust) absorb(prov)
eststo: reghdfe share_nonmissing_fiscal  sdy_density primary_graduate junior_graduate minority ins_famine, vce(robust) absorb(prov)
eststo: reghdfe school_info              sdy_density primary_graduate junior_graduate minority ins_famine, vce(robust) absorb(prov)
eststo: reghdfe cr_info                  sdy_density primary_graduate junior_graduate minority ins_famine, vce(robust) absorb(prov)

global var_order "sdy_density victims_cr ins_famine primary_graduate junior_graduate minority"
outreg2 [*] using "$path4\TableB2.txt", replace se nonotes nocons noaster nolabel text keep($var_order) sortvar($var_order)





********************************************************************************
*                                                                              *
*                            Tables in Appendix C                              *
*                                                                              *
********************************************************************************
************************************************************************
* Table C1: Comparing the Number of Received SDYs from County-aggregate*
* with that from National Report in Each Province, Column (1)          *
*                                                                      *
* Note: Column (2) comes from Gu (2009)                                *
************************************************************************
use "$path1B\county_data.dta", clear

drop if region1990 == .
gen prov = floor(region1990/10000)

drop if inlist(prov,11,12,31,54) // Drop Beijing, Tianjin, Shanghai, and Tibet
replace prov = 44 if prov == 46 // Hainan is part of Guangdong during the movement
replace prov = 51 if prov == 50 // Chongqing is part of Sichuan during the movement

collapse (sum) sdy, by(prov)
replace sdy = sdy/1000
outsheet using "$path4\TableC1_column1.txt", replace





********************************************************************************
*                                                                              *
*                            Tables in Appendix D                              *
*                                                                              *
********************************************************************************
use "$path1B\census_1990_clean.dta", clear

global var_abs_cohort "region1990 prov#year_birth c.primary_base#year_birth c.junior_base#year_birth"


gen treat        = inrange(year_birth,1956,1969) if inrange(year_birth,1946,1969)
gen treat_alt    = inrange(year_birth,1956,1969) if inrange(year_birth,1946,1969)&!inrange(year,1953,1955)
gen treat_junior = inrange(year_birth,1953,1969) if inrange(year_birth,1943,1969)

keep if inrange(year_birth,1943,1969) 

************************************************************
* Table D1: Robustness Check with Different Specifications *
************************************************************
*alternative densities of SDY
bysort region1990: egen cohort_size = sum(treat)
gen sdy_density_alt = sdy_density*pop1964/(100*cohort_size)
drop cohort_size

*alternative exposure to SDY
gen primary_overlap = min(max(year-1955,0),max(1970-year,0),6) if inrange(year_birth,1946,1969)
gen junior_overlap  = min(max(year-1952,0),max(1970-year,0),9) if inrange(year_birth,1943,1969)

global var_order "c.sdy_density#c.treat c.sdy_density_alt#c.treat c.sdy_density#c.primary_overlap c.sdy_density#c.treat_alt c.sdy_density#c.treat_junior c.sdy_density#c.junior_overlap"

gen temp_var = .
forvalues i = 1/8 {
	if (`i'>=1&`i'<=3) local dep_var "c.sdy_density#c.treat"
	if (`i'==4) local dep_var "c.sdy_density_alt#c.treat"
	if (`i'==5) local dep_var "c.sdy_density#c.primary_overlap"
	if (`i'==6) local dep_var "c.sdy_density#c.treat_alt"
	if (`i'==7) local dep_var "c.sdy_density#c.treat_junior"
	if (`i'==8) local dep_var "c.sdy_density#c.junior_overlap"

	if (`i'==1) local cond "& year_birth<=1966"
	if (`i'==2) local cond "& year_birth<=1963"
	if (`i'==3) local cond "& year_birth<=1960"
	if (`i'>3)  local cond ""

	reghdfe yedu `dep_var' male han_ethn if rural==1 `cond', absorb($var_abs_cohort) cluster(region1990)
	if (`i'==1) outreg2 using "$path4\TableD1_A.txt", se nonotes nocons noaster nolabel text replace keep($var_order) sortvar($var_order)
	if (`i'!=1) outreg2 using "$path4\TableD1_A.txt", se nonotes nocons noaster nolabel text append  keep($var_order) sortvar($var_order)

	replace temp_var = `dep_var' // to make the table easier to read, Panel B reports the corresponding coefficients to Panel A

	reghdfe yedu temp_var male han_ethn if rural==0 `cond', absorb($var_abs_cohort) cluster(region1990)
	if (`i'==1) outreg2 using "$path4\TableD1_B.txt", se nonotes nocons noaster nolabel text replace keep(temp_var)
	if (`i'!=1) outreg2 using "$path4\TableD1_B.txt", se nonotes nocons noaster nolabel text append  keep(temp_var)
}


*************************************
* Table D2: Other Robustness Checks *
*************************************

eststo clear
*drop nine Third-Frontier provinces
eststo: reghdfe yedu c.sdy_density#c.treat male han_ethn if rural==1 & !inlist(prov,51,52,61,62,42,43,53,64,65), absorb($var_abs_cohort) cluster(region1990)
eststo: reghdfe yedu c.sdy_density#c.treat male han_ethn if rural==0 & !inlist(prov,51,52,61,62,42,43,53,64,65), absorb($var_abs_cohort) cluster(region1990)

*drop five provinces that does not match well between local gazettes and national reports 
eststo: reghdfe yedu c.sdy_density#c.treat male han_ethn if rural==1 & !inlist(prov,14,23,53,64,65), absorb($var_abs_cohort) cluster(region1990)
eststo: reghdfe yedu c.sdy_density#c.treat male han_ethn if rural==0 & !inlist(prov,14,23,53,64,65), absorb($var_abs_cohort) cluster(region1990)

*impose stronger assumptions on migration history
eststo: reghdfe yedu c.sdy_density#c.treat male han_ethn if rural==1 & local_1985==1, absorb($var_abs_cohort) cluster(region1990)
eststo: reghdfe yedu c.sdy_density#c.treat male han_ethn if rural==0 & local_1985==1, absorb($var_abs_cohort) cluster(region1990)

*drop sample whose education are eligible for hukou transition
eststo: reghdfe yedu c.sdy_density#c.treat male han_ethn if rural==1 & hukou_transit==0, absorb($var_abs_cohort) cluster(region1990)
eststo: reghdfe yedu c.sdy_density#c.treat male han_ethn if rural==0 & hukou_transit==0, absorb($var_abs_cohort) cluster(region1990)

*drop counties that SDY numbers end with zero
gen last_digit = mod(sdy,10)

eststo: reghdfe yedu c.sdy_density#c.treat male han_ethn if rural==1 & last_digit!=0, absorb($var_abs_cohort) cluster(region1990)
eststo: reghdfe yedu c.sdy_density#c.treat male han_ethn if rural==0 & last_digit!=0, absorb($var_abs_cohort) cluster(region1990)

outreg2 [*] using "$path4\TableD2.txt", se nonotes nocons noaster nolabel text replace keep(c.sdy_density#c.treat)




erase "$path1A\census_1990_county_char.dta"
erase "$path1A\rural_school_expansion.dta"
erase "$path1A\teacher_fiscal_info.dta"
