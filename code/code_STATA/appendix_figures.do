******************************************************************************
*Arrival of Young Talent: The Send-down Movement and Rural Education in China*
*                                                                            *
*By Yi Chen, Ziyin Fan, Xiaomin Gu, and LiAn Zhou. American Economic Review. *
******************************************************************************
/*
This do-file generates all the figures in the appendix.

Input data files:
NBS_data.dta
county_data.dta
county_year_data.dta
census_1990_clean.dta

Output files:
Figure A1.pdf (Trends of Real Educational Expenditures in Local Gazetteers)
Figure A2.pdf (The Process of China's Secondary Education Expansion since the Late 1960s)
Figure C1.pdf (Benford's Law and Data Quality on SDYs)
Figure C2.pdf (Number of SDYs Estimated from CFPS 2010)
Figure E1.pdf (Estimating the Effect of SDYs using the Synthetic Control Method)
*/


********************************************************************************
*                                                                              *
*                            Figures in Appendix A                             *
*                                                                              *
********************************************************************************
************************************************************************
*Figure A1: Trends of Real Educational Expenditures in Local Gazetteers*
************************************************************************
use "$path1B\county_year_data.dta", clear
keep if inrange(year,1950,1990)
rename fiscal_edu fiscal_edu_county

collapse (mean) fiscal_edu_county, by(year)
merge 1:1 year using "$path1B\NBS_data.dta", nogenerate keepusing(fiscal_edu price_deflator)

replace fiscal_edu_national = fiscal_edu_national/price_deflator
replace fiscal_edu_county   = fiscal_edu_county/price_deflator

twoway line fiscal_edu_national year, yaxis(1) lcolor(black) lpattern(solid) ///
	|| line fiscal_edu_county year, yaxis(2) lcolor(gs8) lpattern(dash) ///
||, graphregion(fcolor(gs16) lcolor(gs16)) plotregion(lcolor(gs16) margin(zero)) ///
     ylabel(0(50)250, angle(0) format(%12.0f) axis(1)) ytitle("National Fiscal Educational Expenditures""from NBS (100 million RMB)", margin(medium) axis(1)) ///
     ylabel(0(100)500, angle(0) format(%12.0f) axis(2)) ytitle("Educational Expenditures Per County""from Local Gazeteers (10,000 RMB)", margin(medium) axis(2)) ///
	 xlabel(1950(5)1990) xtick(1950(5)1990) xtitle("Year") ///
	 legend(label(1 "National Fiscal Educational""Expenditures from NBS") label(2 "Educational Expenditures Per County""from Local Gazeteers") col(1) size(medsmall))
graph export "$path4\FigureA1.pdf",replace


**************************************************************************************
*Figure A2: The Process of China's Secondary Education Expansion since the Late 1960s*
**************************************************************************************
use "$path1B\county_year_data.dta", clear
keep if sdy_density !=.

collapse (mean) school_primary school_secondary, by(year)

twoway line school_primary year, yaxis(1) lcolor(black) lpattern(solid) ///
	|| line school_secondary year, yaxis(2) lcolor(gs8) lpattern(dash) 	///
||, graphregion(fcolor(gs16) lcolor(gs16)) plotregion(lcolor(gs16) margin(zero)) ///
     ylabel(0(150)600, angle(0) format(%12.0f) axis(1)) ytitle("# Primary Schools per County", margin(medium) axis(1)) ///
     ylabel(0(20)80, angle(0) format(%12.0f) axis(2)) ytitle("# Secondary Schools per County", margin(medium) axis(2)) ///
	 xlabel(1950(5)1990) xtick(1950(5)1990) xtitle("Year") title("Panel A - Summary Statistics from Local Gazeteers",size(medium) margin(medium)) ///
	 legend(label(1 "# Primary Schools per County") label(2 "# Secondary Schools per County") col(1) size(medsmall)) 
graph save a, replace

use "$path1B\NBS_data.dta", clear

twoway line primary_stu year, yaxis(1) lcolor(black) lpattern(solid) ///
	|| line secondary_stu year, yaxis(2) lcolor(gs8) lpattern(dash) ///
||, graphregion(fcolor(gs16) lcolor(gs16)) plotregion(lcolor(gs16) margin(zero)) ///
     ylabel(0(400)1600, angle(0) format(%12.0f) axis(1)) ytitle("# Primary Students per 10,000", margin(medium) axis(1)) ///
     ylabel(0(200)800, angle(0) format(%12.0f) axis(2)) ytitle("# Secondary Students per 10,000", margin(medium) axis(2)) ///
	 xlabel(1950(5)1990) xtick(1950(5)1990) xtitle("Year") title("Panel B - National-level Statistics",size(medium) margin(medium)) ///
	 legend(label(1 "# Primary Students per 10,000") label(2 "# Secondary Students per 10,000") col(1) size(medsmall))
graph save b,replace 

graph combine a.gph b.gph, rows(2) graphregion(fcolor(gs16) lcolor(gs16)) xsize(13.5) ysize(20)
graph export "$path4\FigureA2.pdf",replace

erase a.gph
erase b.gph 





********************************************************************************
*                                                                              *
*                            Figures in Appendix C                             *
*                                                                              *
********************************************************************************
***************************************************
*Figure C1: Benford's Law and Data Quality on SDYs*
***************************************************
use "$path1B\county_data.dta", clear

drop if region1990 == .
gen prov = floor(region1990/10000)
keep if !inlist(prov,11,12,31) & district!=1 & sdy_density!=. // keep the sample corresponding to our main analysis

keep sdy region1990

firstdigit sdy, percent
/*
. firstdigit sdy, percent

          n   chi-sq.  P-value   digit   observed   expected
------------------------------------------------------------
sdy    1773      6.81   0.5575       1      28.54      30.10
                                     2      17.65      17.61
                                     3      12.86      12.49
                                     4       9.53       9.69
                                     5       8.97       7.92
                                     6       6.32       6.69
                                     7       6.32       5.80
                                     8       4.74       5.12
                                     9       5.08       4.58
*/

clear
input str9 digit data benford
1      28.54      30.10
2      17.65      17.61
3      12.86      12.49
4       9.53       9.69
5       8.97       7.92
6       6.32       6.69
7       6.32       5.80
8       4.74       5.12
9       5.08       4.58
end // the input comes from the results of firstdight, as shown above

graph bar benford data, over(digit) bargap(0)  bar(1,color(gs0)) bar(2,color(gs12)) ///
graphregion(fcolor(gs16) lcolor(gs16)) plotregion(lcolor(gs16) margin(zero)) ///
     ylabel(0(5)30, angle(0) format(%12.0f)) ytitle("Percentage Points", margin(medium)) ///
     b1title("First Digit", margin(medium)) ///
	 legend(label(1 "Data on SDYs") label(2 "Benford's Law") ring(0) pos(2) colgap(*0.5)) 
graph export "$path4\FigureC1.pdf",replace 




****************************************************
*Figure C2: Number of SDYs Estimated from CFPS 2010*
****************************************************
/*Note: Plotting this graph requires the original CFPS 2010 data.
We directly provide the output numbers here. Those numbers can be
replicated with the following codes. */


/*
use "$path2B\cfps2010adult_201906",clear

rename qg101_a_1 sdy_start
rename qa1y_best year_birth

keep if qg1_s_1r==1|qg1_s_2r==1 // keep SDY sample
keep sdy_start rswt_nat

keep if inrange(sdy_start,1962,1979)
recode sdy_start (1962/1966=1)(1967/1968=2), gen(period)
replace period = sdy_start-1966 if inrange(sdy_start,1969,1979)

collapse (sum) rswt_nat, by(period)
gen cfps_impute = rswt_nat/10000
drop rswt_nat

list
*/

clear 
input str9 year sdy_national cfps_impute
1962-1966	129.28	160.266
1967-1968	199.68	254.5743
1969	    267.38	162.5964
1970	    106.4	113.5627
1971	    74.83	77.62477
1972	    67.39	84.00252
1973	    89.61	52.58943
1974	    172.48	170.2201
1975	    236.86	209.5235
1976	    188.03	173.3829
1977	    171.68	105.0372
1978	    48.09	32.24603
1979	    24.77	3.03945
end

replace sdy_national= sdy_national/100
replace cfps_impute = cfps_impute/100

encode year, generate(period)

graph bar sdy_national cfps_impute, over(period,label(angle(90))) bargap(0) bar(1,color(gs0)) bar(2,color(gs12)) ///
graphregion(fcolor(gs16) lcolor(gs16)) plotregion(lcolor(gs16) margin(zero)) ///
     ylabel(0(0.5)3, angle(0) format(%12.1f)) ytitle("Number of SDYs (Million)", margin(medium)) ///
	 legend(label(1 "National Reports") label(2 "CFPS Estimates") ring(0) pos(2) colgap(*0.5)  ) 
graph export "$path4\FigureC2.pdf",replace 





********************************************************************************
*                                                                              *
*                            Figures in Appendix E                             *
*                                                                              *
********************************************************************************
****************************************
* Synthetic Control, Step 1:           *
* prepare county-level characteristics *
****************************************
use "$path1B\census_1990_clean.dta", clear
keep if rural == 1

gen minority = 1 - han_ethn
gen famine = inrange(year_birth,1959,1961)
gen nonfamine = inrange(year_birth,1955,1957)

replace minority         = . if  !inrange(year_birth,1946,1955)
replace primary_graduate = . if  !inrange(year_birth,1946,1955)
replace junior_graduate  = . if  !inrange(year_birth,1946,1955)

collapse (mean) minority primary_graduate junior_graduate (sum) famine nonfamine, by(region1990)

gen ins_famine = 1 - famine/nonfamine
drop famine nonfamine
save "$path1A\census_1990_county_SC.dta", replace

****************************************************************
* Synthetic Control, Step 2:                                   *
* pick up counties with sufficient observations in each cohort *
****************************************************************
use "$path1B\census_1990_clean.dta", clear

keep if inrange(year_birth,1946,1969) 
keep if rural==1

collapse (count) N = yedu, by(year_birth region1990)

drop if N < 30
bysort region1990: gen balance = _N

keep if balance == 24
drop balance

keep region1990
duplicates drop
save "$path1A\census_1990_county_list.dta", replace

*****************************************************
* Synthetic Control, Step 3:                        *
* prepare county-by-cohort data for the SC analysis *
*****************************************************
use "$path1B\county_data.dta", clear
drop if region1990 == . |countyid == .
drop region1982 region2000 region2010

*SC requires counties to have complete information
merge 1:1 region1990 using "$path1A\census_1990_county_list.dta", keep(3) nogenerate
merge 1:1 region1990 using "$path1A\census_1990_county_SC.dta", keep(3) nogenerate
replace grain_output = grain_output/pop1964

keep region1990 sdy_density grain_output minority ins_famine urbanratio64 primary_graduate junior_graduate
keep if !missing(sdy_density,grain_output,minority,ins_famine,urbanratio64)

sort sdy_density
gen N = _N
gen treat = [_n > (N+1)/2] 
drop N

tempfile temp
save `temp', replace


use "$path1B\census_1990_clean.dta", clear

keep if inrange(year_birth,1946,1969) 
keep if rural==1

collapse (mean) yedu, by(year_birth region1990)
merge m:1 region1990 using `temp', keep(3) nogenerate

tsset region1990 year_birth
save "$path1A\synth_analysis.dta", replace

*****************************************************
* Synthetic Control, Step 4:                        *
* extended Abadie synthetic control (SC) method     *
*****************************************************
use "$path1A\synth_analysis.dta", clear

gen D = [year_birth>=1956]*treat
drop if D==.

parallel initialize 

synth_runner yedu yedu(1946(1)1955) primary_graduate(1955) junior_graduate(1955) grain_output(1955) urbanratio64(1955) minority(1955) ins_famine(1955), d(D) gen_var parallel

effect_graphs
pval_graphs

matrix P = e(pvals_std)
save "$path1A\synth_results.dta", replace

clear
svmat P, names(matcol)
gen I = 1
reshape long Pc, i(I) j(lead)
drop I

rename Pc p_vals

tempfile temp
save `temp', replace

use "$path1A\synth_results.dta", clear
merge m:1 lead using `temp', nogenerate
save "$path1A\synth_results.dta", replace

*****************************************************************************
*Figure E1: Estimating the Effect of SDYs using the Synthetic Control Method*
*****************************************************************************
use "$path1A\synth_results.dta", clear

keep if treat == 1
collapse (mean) p_vals yedu yedu_synth, by(year_birth)
gen effect = yedu - yedu_synth

twoway line yedu year_birth, lcolor(black) || line yedu_synth year_birth, lpattern(dash) lcolor(black) ///
||, graphregion(fcolor(gs16) lcolor(gs16)) plotregion(lcolor(gs16) margin(zero)) ///
     ylabel(5(0.5)8, angle(0) format(%12.1f)) ytitle("Average Years of Education", margin(medium)) ///
	 xlabel(1945(5)1970) xtick(1945(5)1970) xtitle("Birth Cohort") ///
	 legend(label(1 "Treated (Counties with Higher""Density of SDY)") label(2 "Synthetic Control from Counties""with Lower Density of SDY") col(1) size(small) ring(0) pos(4) colgap(*0.5)) ///
	 xline(1955, lpattern(solid) lwidth(thin) lcolor(black))  ///
	 title("Treatment versus Control",size(medium) margin(medium))
graph save a,replace 

twoway line effect year_birth, yaxis(1) lcolor(black) || scatter p_vals year_birth, yaxis(2) msymbol(square) mcolor(black) ///
||, graphregion(fcolor(gs16) lcolor(gs16)) plotregion(lcolor(gs16) margin(zero)) ///
     ylabel(-0.1(0.1)0.4, angle(0) format(%12.1f) axis(1)) ytitle("Treatment Effect", margin(medium) axis(1)) ///
     ylabel(0(0.2)1, angle(0) format(%12.1f) axis(2)) ytick(-0.25 0(0.2)1,axis(2)) ytitle("p-values", margin(medium) axis(2)) ///
	 xlabel(1945(5)1970) xtick(1945(5)1970) xtitle("Birth Cohort") ///
	 legend(label(1 "Treatment Effect") label(2 "p-values") col(1) size(small) ring(0) pos(3) colgap(*0.5)) ///
	 xline(1955, lpattern(solid) lwidth(thin) lcolor(black))  ///
	 title("Treatment Effect and P-values",size(medium) margin(medium))
graph save b,replace 

graph combine a.gph b.gph, rows(1) graphregion(fcolor(gs16) lcolor(gs16)) xsize(18) ysize(8)
graph export "$path4\FigureE1.pdf",replace

erase a.gph
erase b.gph

erase "$path1A\census_1990_county_list.dta"
erase "$path1A\census_1990_county_SC.dta"
erase "$path1A\synth_analysis.dta"
erase "$path1A\synth_results.dta"
