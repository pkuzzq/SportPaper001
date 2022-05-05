******************************************************************************
*Arrival of Young Talent: The Send-down Movement and Rural Education in China*
*                                                                            *
*By Yi Chen, Ziyin Fan, Xiaomin Gu, and LiAn Zhou. American Economic Review. *
******************************************************************************
/*
This do-file plots the figures in the main text.

Input data files:
Figure 3.txt (generated from 1_Table_Census_1990.do and 2_Table_Other.do)

Output files:
Figure1.pdf (Number of SDYs by Resettlement, 1962--1979)
Figure3.pdf (Effect of SDYs on the Educational Attainment of Different Cohorts)
*/





**************************************************************************
*Figure 1: Number of SDYs by Resettlement, 1962--1979 (Source: Gu (2009))*
**************************************************************************
clear
input str9 year total rural_village collective_farm state_farm
1962-1966	129.28	87.06	0	    42.22
1967-1968	199.68	165.96	0	    33.72
1969	    267.38	220.44	0	    46.94
1970	    106.4	74.99	0	    31.41
1971	    74.83	50.21	0	    24.62
1972	    67.39	50.26	0	    17.13
1973	    89.61	80.64	0	    8.97
1974	    172.48	119.19	34.63	18.66
1975	    236.86	163.45	49.68	23.73
1976	    188.03	122.86	41.51	23.66
1977	    171.68	113.79	41.9	15.99
1978	    48.09	26.04	18.92	3.13
1979	    24.77	7.32	16.44	1.01
end
foreach var in total rural_village collective_farm state_farm {
	replace `var'= `var'/100
}

gen v_temp = rural_village + collective_farm
encode year, generate(period)

twoway bar rural_village period, barw(0.6) base(0) color(gs2) ///
|| rbar v_temp rural_village period, barw(0.6) color(gs12) ///
|| rbar total v_temp period, barw(0.6) color(gs7) ///
||, graphregion(fcolor(gs16) lcolor(gs16)) plotregion(lcolor(gs16) margin(zero)) ///
     ylabel(0(0.5)3, angle(0) format(%12.1f)) ytitle("Number of SDYs (Million)", margin(medium)) ///
	 xlabel(1(1)13, noticks valuelabel angle(90)) xtitle("Year") ///
	 legend(label(1 "Rural Villages") label(2 "Collective Farms") label(3 "State Farms") ring(0) pos(2) colgap(*0.5)  ) 
graph export "$path4\Figure1.pdf",replace


*****************************************************************************
*Figure 3: Effect of SDYs on the Educational Attainment of Different Cohorts*
*****************************************************************************
insheet using "$path4\Figure3.txt", clear
keep if inrange(_n,5,38)
gen year = substr(v1,2,4)

rename (v2 v3 v4 v5 v6 v7)(coef1990 se1990 coef1982 se1982 coef2000 se2000)
destring, force replace
keep year coef* se*

reshape long coef se, i(year) j(data)
drop if coef == .

gen lb = coef - 1.96*se
gen ub = coef + 1.96*se
gen y_overlap = min(max(year-1955,0),max(1970-year,0),6)
sort data year

twoway line lb year if data==1982, sort lpattern(dash) lcolor(gs8) yaxis(1) ///
|| line ub year if data==1982, sort lpattern(dash) lcolor(gs8) ///
|| line coef year if data==1982, lwidth(thick) lcolor(black)  yaxis(1) ///
|| line y_overlap year if data==1982, sort lpattern(dash_dot) lwidth(thick) lcolor(gs8) yaxis(2) ///
||, graphregion(fcolor(gs16) lcolor(gs16)) plotregion(lcolor(gs16) margin(zero)) ///
     ylabel(-4(2)8, labsize(small) angle(0) format(%12.0f) axis(1)) ytitle("Coefficients", size(small) axis(1)) ///
     ylabel(0(2)6, labsize(small) angle(0) format(%12.0f) axis(2)) ytick(-6 0(1)6 12,axis(2)) ytitle("Years of Overlap", size(small) axis(2)) ///
	 xlabel(1945(5)1980, labsize(small)) xtick(1945(5)1980) xtitle("Birth Cohort", size(small)) ///
	 xline(1955 1970, lpattern(solid) lwidth(thin) lcolor(black)) ///
	 title("Panel A - Census 1982", size(small) margin(small)) ///
	 yline(0, lpattern(solid) lwidth(thin) lcolor(black)) legend(off) fxsize(70) fysize(60)
graph save a,replace 

twoway line lb year if data==1990, lpattern(dash) lcolor(gs8) yaxis(1) ///
|| line ub year if data==1990, lpattern(dash) lcolor(gs8) ///
|| line coef year if data==1990, lwidth(thick) lcolor(black) yaxis(1) ///
|| line y_overlap year if data==1990, lpattern(dash_dot) lwidth(thick) lcolor(gs8) yaxis(2) ///
||, graphregion(fcolor(gs16) lcolor(gs16)) plotregion(lcolor(gs16) margin(zero)) ///
     ylabel(-4(2)8, labsize(small) angle(0) format(%12.0f) axis(1)) ytitle("Coefficients", size(small) axis(1)) ///
     ylabel(0(2)6, labsize(small) angle(0) format(%12.0f) axis(2)) ytick(-6 0(1)6 12,axis(2)) ytitle("Years of Overlap", size(small) axis(2)) ///
	 xlabel(1945(5)1980, labsize(small)) xtick(1945(5)1980) xtitle("Birth Cohort", size(small)) ///
	 xline(1955 1970, lpattern(solid) lwidth(thin) lcolor(black)) ///
	 title("Panel B - Census 1990", size(small) margin(small)) ///
	 yline(0, lpattern(solid) lwidth(thin) lcolor(black)) legend(off) fxsize(70) fysize(60)
graph save b,replace 

twoway line lb year if data==2000, lpattern(dash) lcolor(gs8) yaxis(1) ///
|| line ub year if data==2000, lpattern(dash) lcolor(gs8) ///
|| line coef year if data==2000, lwidth(thick) lcolor(black) yaxis(1) ///
|| line y_overlap year if data==2000, lpattern(dash_dot) lwidth(thick) lcolor(gs8) yaxis(2) ///
||, graphregion(fcolor(gs16) lcolor(gs16)) plotregion(lcolor(gs16) margin(zero)) ///
     ylabel(-3(1)6, labsize(small) angle(0) format(%12.0f) axis(1)) ytitle("Coefficients", size(small) axis(1)) ///
     ylabel(0(2)6, labsize(small) angle(0) format(%12.0f) axis(2)) ytick(-6 0(1)6 12,axis(2)) ytitle("Years of Overlap", size(small) axis(2)) ///
	 xlabel(1945(5)1980, labsize(small)) xtick(1945(5)1980) xtitle("Birth Cohort", size(small)) ///
	 legend(order(3 1 4)label(3 "Coefficient") label(1 "95% CI") label(4 "Overlapped Years in""Primary Schools") col(2) size(small) margin(tiny)) ///
	 xline(1955 1970, lpattern(solid) lwidth(thin) lcolor(black)) ///
	 title("Panel C - Census 2000", size(small) margin(small)) ///
	 yline(0, lpattern(solid) lwidth(thin) lcolor(black)) fxsize(65) fysize(80)
graph save c,replace 

twoway || connected coef year if data==1982, lwidth(medthick) msymbol(triangle) color(black) ///
|| line coef year if data==1990, lwidth(medthick) color(gs6) ///
|| connected coef year if data==2000, lwidth(medthick) msymbol(square) color(gs12) ///
||, graphregion(fcolor(gs16) lcolor(gs16)) plotregion(lcolor(gs16) margin(zero)) ///
     ylabel(-2(1)5, labsize(small) angle(0) format(%12.0f)) ytitle("Coefficients", size(small)) ///
	 xlabel(1945(5)1980, labsize(small)) xtick(1945(5)1980) xtitle("Birth Cohort", size(small)) ///
	 legend(label(1 "Census 1982") label(2 "Census 1990") label(3 "Census 2000") col(2) size(small)) ///
	 xline(1955 1970, lpattern(solid) lwidth(thin) lcolor(black)) ///
	 title("Panel D - Three Censuses in One Graph", size(small) margin(small)) ///
	 yline(0, lpattern(solid) lwidth(thin) lcolor(black)) fxsize(70) fysize(80)
graph save d,replace 


graph combine a.gph b.gph c.gph d.gph, graphregion(fcolor(gs16) lcolor(gs16))
graph export "$path4\Figure3.pdf",replace

erase a.gph
erase b.gph
erase c.gph
erase d.gph
erase "$path4\Figure3.txt"
