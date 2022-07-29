************
* SCRIPT: 1_process_raw_data.do
* PURPOSE: imports the raw data and saves it in Stata readable format
*目的:导入原始数据并以Stata可读格式保存,提取主要变量,为了日后,尽量多提取
*将提取的变量,用Excel表记录下来)
************

* Preamble (unnecessary when executing run.do)
run "$MyProject/scripts/programs/_config.do"

********************************************************************************
*                                                                              *
*                        Step 1: CFPS 2018                               *
*                                                                              *
********************************************************************************

* 导入儿童代答库
* 可以与家庭关系库匹配
use "$MyProject/data/CFPS2018/cfps2018childproxy_202012.dta", clear  //导入少儿家长代答数据库	
global varlist_child2018 	pid fid18 fid16 fid14 fid12 fid10 ////
							provcd18 countyid18 cid18 urban18 subsample ///
							subpopulation psu pid_a_f pid_a_m respc1pid ///
							school ibirthy gender  ///
							wf901 wf906 cfps2018eduy_im wz302 ///
							wc3_b_2
keep $varlist_child2018 //保留被代答的儿童兴趣变量
save "$MyProject/processed/intermediate/cfps2018_varlist_child2018.dta", replace

* 导入家庭关系库
* 可以与少儿库、成人库进行匹配
use "$MyProject/data/CFPS2018/cfps2018famconf_202008.dta", clear  //导入少儿家长代答数据库
global varlist_famconf2018 	pid fid*  gene*  pid_a_* rtype_end18 code_a_p co_a18_p ///
							tb6_a18_p  
keep $varlist_famconf2018   //保留成员信息变量
save "$MyProject/processed/intermediate/cfps2018_varlist_famconf2018.dta", replace

* 导入成人库
* 可以与家庭库进行匹配
use "$MyProject/data/CFPS2018/cfps2018person_202012.dta", clear  //导入少儿家长代答数据库
global varlist_person2018 	pid fid18 fid16 fid14 fid12 fid10 ///
							pid_a_f pid_a_m countyid18 cid18 interviewerid18 ///
							qp701 qp702    
keep $varlist_person2018 //保留成员信息变量
save "$MyProject/processed/intermediate/cfps2018_varlist_person2018.dta", replace

********************************************************************************
*                                                                              *
*                        Step 2: CFPS 2010                               *
*                                                                              *
********************************************************************************

* 导入成人库
use "$MyProject/data/CFPS2010/cfps2010adult_201906.dta", clear  //导入少儿家长代答数据库
global varlist_adult2010 	pid* fid*  ql1_s_* ql101_a_3
keep $varlist_adult2010 //保留成员信息变量
save "$MyProject/processed/intermediate/cfps2010_varlist_adult2010.dta", replace

* 导入少儿库
use "$MyProject/data/CFPS2010/cfps2010child_201906.dta", clear  //导入少儿家长代答数据库
global varlist_child2010 	*id* wl3 
keep $varlist_child2010 	//保留成员信息变量

* 导入家庭关系库
use "$MyProject/data/CFPS2010/cfps2010famconf_202008.dta", clear  //导入少儿家长代答数据库
global varlist_famconf2010 	*id* *best
keep $varlist_famconf2010 	//保留成员信息变量

* 导入村居库
use "$MyProject/data/CFPS2010/cfps2010comm_201906.dta", clear  //导入少儿家长代答数据库
global varlist_comm2010 	ca301_a_*  ca3_s_* cid countyid ce3 
keep $varlist_comm2010 		//保留成员信息变量

********************************************************************************
*                                                                              *
*                        Step 3: CFPS 2012                               *
*                                                                              *
********************************************************************************

* 导入成人库
use "$MyProject/data/CFPS2012/cfps2012adult_201906.dta", clear  //导入少儿家长代答数据库
global varlist_adult2012 	*id* *id*  qp701
keep $varlist_adult2012 //保留成员信息变量
save "$MyProject/processed/intermediate/cfps2010_varlist_adult.dta", replace


merge 1:1 pid using cfps2018person_202012, force  //匹配个人库

compress
save "$MyProject/processed/intermediate/auto_uncleaned.dta", replace

** EOF


