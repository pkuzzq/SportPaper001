************
* SCRIPT: 2_clean_data.do
* 目的:处理主要数据集,为分析做准备.
************

* 序言(在执行run.do时不需要).
run "$MyProject/scripts/programs/_config.do"

************
* Code begins
************

use "$MyProject/processed/intermediate/auto_uncleaned.dta", clear

* 用该变量的中位数替换缺失的数值
foreach v of varlist * {
	cap confirm numeric var `v'
	if _rc continue
	
	gen imp_`v' = mi(`v')
	label var imp_`v' "Imputed value for `v'"
	summ `v', detail
	replace `v' = r(p50) if mi(`v')
}

compress
save "$MyProject/processed/auto.dta", replace

** EOF
