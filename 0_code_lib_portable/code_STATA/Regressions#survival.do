**====================*
** 博士论文第3章研究
** 回归程序
**====================*

/* 这里与人大王非老师的顺序有点不同
    他在合并数据后：完善变量标签、单变量清洗、多变量清洗、定义研究样本、变量调整 
    我是在合并数据后：（没有完善变量标签，因为大部分是已存在）、单变量清洗（特殊值转缺失值）、（定义研究样本放在之后）、变量调整
*/
    version   16
    clear     all 


***************************************************************
****    A. 基本设定     
***************************************************************


    global    path    "C:\\Users\\pkuzz\\OneDrive\\【日常更新】林佳颖博士论文\\第3章\\2Working" //定义项目目录	
    // 需要预先在生成子文件夹：data, refs, out, adofiles
    global    D       "$path\\data"       //数据文件
    global    R       "$path\\refs"       //参考文献
    global    Out     "$path\\out"        //结果：图形和表格
    adopath   +       "$path\\adofiles"   //自编程序+外部命令 
    cd        "$D"                        //设定当前工作路径

*-核心参考资料 (参考文献和文档都存放于 $R 文件夹下)
*-  shellout "$R\Safin_Federer_2005_Aust.pdf"

    use data_dealed.dta,clear


***************************************************************
****     非参数分析：K-M 估计 (Kaplan–Meier estimator) 
***************************************************************

	sts test n_d_hos_affd
	sts test n_d_rent_affd

	#d ; //声明后续以分号为断行，作图时常用，选项较多 
	sts graph
	,  	
		by(n_d_hos_affd)											//	后面都是选项设定
	  	name(p1 ,replace)
	  	ylabel(, tposition(inside) labsize(*0.8) angle(0)) 
	   		//	纵轴刻度和标签设定
	  			//	纵坐标从0-100，0(20)100
	  			//	刻度线朝内,tposition(inside) 
	  			//	y轴标签字号为默认字号的 0.8 倍,labsize(*0.8)
				//	标签为纵向放置 (默认是横向),angle(0)
	  	ytitle("存活机率(%)", tstyle(smbody)) // y 轴标题为小号字体
	  	xtitle("分析时间(年)", tstyle(smbody)) // y 轴标题为小号字体
	  	legend(
	  		// title("子样本")
	  		label(1 "购房可负担") 
			label(2 "购房不可负担") 
			order(1 2 ) 
			size(small)
			  ) 									//图例: 标签按照地区排列，图例字体小号
	  	title("购房者的KM非参数存活曲线")
	  graphregion(color(white)) 					//图片底色为白色
	  ;

	sts graph
	,  	
		by(n_d_rent_affd)											//	后面都是选项设定
	  	name(p2 ,replace)
	  	ylabel(, tposition(inside) labsize(*0.8) angle(0)) 
	   		//	纵轴刻度和标签设定
	  			//	纵坐标从0-100，0(20)100
	  			//	刻度线朝内,tposition(inside) 
	  			//	y轴标签字号为默认字号的 0.8 倍,labsize(*0.8)
				//	标签为纵向放置 (默认是横向),angle(0)
	  	ytitle("存活机率(%)", tstyle(smbody)) // y 轴标题为小号字体
	  	xtitle("分析时间(年)", tstyle(smbody)) // y 轴标题为小号字体
	  	legend(
	  		// title("子样本")
	  		label(1 "租房可负担") 
			label(2 "租房不可负担") 
			order(1 2 ) 
			size(small)
			  ) 									//图例: 标签按照地区排列，图例字体小号
	  	title("租房者的KM非参数存活曲线")
	  graphregion(color(white)) 					//图片底色为白色
	  ;
	graph combine p1 p2 ;
	local s "$Out\\Figure_hos"; //存储的文件名(或路径\文件名)
	gr save `s'.gph,replace ;
	gr export `s'.png,replace width(1800);
	gs_fileinfo `s'.gph; //从gph召回代码，即便是手动修改也能看到改动
	di r(command);
	#delimit  cr


	// sts graph, by(n_d_rent_affd)
	// sts graph, cumhaz by(n_d_rent_affd)

	// sts graph, ci        // 整体生存函数，即KM估计量
	// 	graph export "${Out}/Fig_ci.png", replace //存储图片
	// sts graph, by(n_d_hos_affd)		// 自有房住宅负担分组生存函数，即KM估计量
	// 	graph export "${Out}/Fig_by_hos_xlist.png", replace
	// sts graph, by(n_d_rent_affd)	// 租赁房住宅负担分组生存函数，即KM估计量
	// 	graph export "${Out}/Fig_by_rent_xlist.png", replace

	// sts graph, cumhaz by(n_d_hos_affd) 	// 自有房住宅负担分组累计风险函数
	// 	graph export "${Out}/Fig_Cum_by_hos_xlist.png", replace
	// sts graph, cumhaz by(n_d_rent_affd)	// 租赁房住宅负担分组累计风险函数
	// 	graph export "${Out}/Fig_Cum_by_rent_xlist.png", replace

	// sts graph, hazard ci 	// 整体风险函数，即KM估计量
	// 	graph export "${Out}/Fig_hazard_ci.png", replace
	// sts graph, hazard by(n_d_hos_affd)	// 自有房住宅负担分组累计风险函数
	// 	graph export "${Out}/Fig_hazard_by_hos_xlist.png", replace
	// sts graph, hazard by(n_d_rent_affd)	// 租赁房住宅负担分组累计风险函数
	// 	graph export "${Out}/Fig_hazard_by_rent_xlist.png", replace

// 目标：不负担的组别，累计风险陡峭，风险更高，√


***************************************************************
****    参数模型 (Parametric Models)的选取     ***************************************************************

	*  dis(exp)			—— 指数模型；
	*  dis(weibull)		—— Weibull模型；
	*  dis(gompertz)	—— Gompertz模型；
	*  dis(logl)		—— Log-logistic模型；
	*  dis(lognormal)	—— Log-normal模型
*-------


**	变量设定


  	// global y   		"Mark"   								//被解释变量
  	global x_hos   	"n_d_hos_affd" 							//基本解释变量
   	global x_rent   "n_d_rent_affd" 						//基本解释变量
  	global z   		"age_ age_sqr hos_space_ " 	//基本控制变量(连续) 
  	global w  		"i.rec_gender_ i.rec_marital_status_ i.rec_d_employer_ i.n_rec_inc_grp_ i.num_child_fami i.rec_edu_ i.rec_edu_p  i.hos_type_ "    //虚拟变量
	// global opt ", vce(robust)" 
	// global opt ", vce(cluster industry)" 
  	


**	全样本的参数模型选择(仅屏幕呈现用于模型选择)
*- 估计
	quietly ///
	foreach i of newlist exp weibull gompertz loglogistic lognormal ggamma {
		 streg  ${x_hos} ${z} ${w} , dist(`i')  nolog 
		 est store `i'
		 estat ic	
	}
*-模型名称 (请先执行这一行)
	global mm "exp weibull gompertz loglogistic lognormal ggamma"
*-屏幕呈现
	esttab $mm,  replace  nogap compress									///
			b(%20.3f) t(%7.2f)   aic bic  				 					///
			star( * 0.10 ** 0.05 *** 0.01 ) 		  						///
			addnotes("*** 1% ** 5% * 10%")    								///		
			title("全样本的参数模型选择")  mtitle($mm)  
// indicate("edu = rec_edu*") drop(`drop')



	*-Note:
	*	(1) 伽马分布下的设定语法在不同的 Stata 版本中略有差异：
		*  Stata14 以下为： dist(gamma)
		*  Stata15 以上为： dist(ggamma)
	*	(2) 回归选项有nohr（为了方便解释通常去掉）,汇报是系数，默认汇报的是风险比率，行文时注意语言！！
		*  例如，无nohr，风险比率1.6，表示A的风险比率约1.6，这意味着A比B的自评健康状态下降的风险高60%。
		*  例如，有nohr，0.1，表示A比B的自评健康状态下降事件发生的概率高0.1个对数单位。



**	全样本与子样本中购房者和租房者的weibull模型结果，呈现风险比率而非系数的表格,无nohr(仅屏幕呈现用于模型选择)
*- 估计
/*
	quietly {
		streg  ${x_hos} ${z} ${w}  if !missing(sample_core) , dist(weibull)  nolog  vce(robust)
		est store full_hos_coef
		estadd scalar p = e(aux_p)
		estadd scalar LogLikelihood = e(ll)
		streg  ${x_rent} ${z} ${w} if !missing(sample_core), dist(weibull)  nolog vce(robust)
		est store full_rent_coef
		estadd scalar p = e(aux_p)
		estadd scalar LogLikelihood = e(ll)
		streg  ${x_hos} ${z} ${w}  if sample_core == 1 , dist(weibull)  nolog vce(robust)
		est store core_hos_coef
		estadd scalar p = e(aux_p)
		estadd scalar LogLikelihood = e(ll)
		// streg  ${x_rent} ${z} ${w} if sample_core == 1 , dist(weibull)  nolog vce(robust)
		// est store core_rent_coef
		// estadd scalar p = e(aux_p)
		// estadd scalar LogLikelihood = e(ll) 
		streg  ${x_hos} ${z} ${w}  if sample_core == 2 , dist(weibull)  nolog vce(robust)
		est store dual_hos_coef
		estadd scalar p = e(aux_p)
		estadd scalar LogLikelihood = e(ll)
		streg  ${x_rent} ${z} ${w} if sample_core == 2 , dist(weibull)  nolog vce(robust)
		est store dual_rent_coef
		estadd scalar p = e(aux_p)
		estadd scalar LogLikelihood = e(ll)
		}

	*-模型名称 (请先执行这一行)
	global mmm "full_hos_coef full_rent_coef core_hos_coef  dual_hos_coef dual_rent_coef"
*-屏幕呈现
	esttab $mmm,  replace  nogap compress									///
			b(%20.3f) se(%7.2f)  aic bic scalar(p LogLikelihood)  			///
			star( * 0.10 ** 0.05 *** 0.01 ) 		  						///		
			title("全样本与子样本中购房者和租房者的weibull模型结果")  mtitle($mmm)  
*/


  	*-----结果表1：全样本的购房者和租房者的回归结果-------

quietly {
	streg  ${x_hos} ${z} ${w}  if !missing(sample_core) , dist(weibull) nohr nolog  vce( cluster id) //系数
	est store hos_coef
	estadd scalar pp = e(aux_p)
	estadd scalar LogLikelihood = e(ll)
	stcurve , hazard 
 	graph export "${Out}/Fig_weibullhazard.png", replace
	streg  ${x_hos} ${z} ${w}  if !missing(sample_core) , dist(weibull)  nolog   vce( cluster id)
	est store hos_odds
	estadd scalar pp = e(aux_p)
	estadd scalar LogLikelihood = e(ll)
	streg  ${x_rent} ${z} ${w}  if !missing(sample_core) , dist(weibull) nohr nolog  vce( cluster id) //系数
	est store rent_coef
	estadd scalar pp = e(aux_p)
	estadd scalar LogLikelihood = e(ll)
	stcurve , hazard 
 	graph export "${Out}/Fig_weibullhazard.png", replace
	streg  ${x_rent} ${z} ${w}  if !missing(sample_core) , dist(weibull)  nolog   vce( cluster id)
	est store rent_odds
	estadd scalar pp = e(aux_p)
	estadd scalar LogLikelihood = e(ll)
}

	global fullsample "hos_coef hos_odds rent_coef   rent_odds"

*-屏幕呈现
	esttab $fullsample,  replace  nogap compress							       ///
			b(%20.3f) t(%7.2f) abs   scalar(pp LogLikelihood)  			           ///
			star( * 0.10 ** 0.05 *** 0.01 ) indicate("收入效应 =*.n_rec_inc_grp_")  ///
			addnotes("*** p<0.01; ** p<0.05; * p<0.1") 						       ///	
			title("全样本购房者和租房者的weibull模型结果")  mtitle($fullsample)  

*-输出到 Word 文档 
	esttab $fullsample using "${Out}/full_result1.csv", replace nogap compress      ///
			b(%20.3f) t(%7.2f) abs  scalar(pp LogLikelihood)  					    ///
			star( * 0.10 ** 0.05 *** 0.01 ) indicate("收入效应 =*.n_rec_inc_grp_")   ///
			addnotes("*** p<0.01; ** p<0.05; * p<0.1") 								///	
			title("全样本购房者和租房者的weibull模型结果")  mtitle($fullsample)
// Odds需要手动加上
// 需要手动调整变量顺序




***************************************************************
****    COX模型回归-假定失效时间有重叠    
***************************************************************


**	变量重新设定，把时变变量先剔除，避免内生性问题


  	// global y   		"Mark"   							//被解释变量
  	global x_hos   	"n_d_hos_affd" 							//基本解释变量
   	global x_rent   "n_d_rent_affd" 						//基本解释变量
  	global z_nt		" hos_space_ " 	//基本控制变量(连续) 
  	global w_nt		"i.rec_gender_ i.rec_marital_status_ i.rec_d_employer_ i.n_rec_inc_grp_  i.rec_edu_ i.rec_edu_p i.hos_type_  "    //虚拟变量


*----
*- 假定失效时间不重叠(no tied failure)

	// quietly stcox ${hos_xlist}, vce(robust) nolog nohr

*-----结果表2：子样本的购房者和租房者的回归结果-------


*----
*- 假定失效时间有重叠(tied failure),使用efron


	stcox ${x_hos} ${z_nt}  ${w_nt} if !missing(sample_core), nohr nolog vce( cluster id) efron //系数
	est store sample_full_hos
	estat phtest ,detail
	stcurve, hazard

	stcox  ${x_rent} ${z_nt}  ${w_nt} if !missing(sample_core), nohr nolog vce( cluster id) efron //系数
	est store sample_full_rent
	estat phtest ,detail
	stcurve, hazard

	stcox  ${x_hos} ${z_nt}  ${w_nt} if   sample_core==1 ,  nohr nolog  vce( cluster id)  efron //系数
	est store sample_core_hos
	estat phtest ,detail
	stcurve, hazard

	stcox  ${x_rent} ${z_nt} ${w_nt}  if   sample_core==1 ,  nohr nolog  vce( cluster id) efron //系数
	est store sample_core_rent
	estat phtest ,detail
	stcurve, hazard 

	stcox  ${x_hos} ${z_nt}  ${w_nt}   if   sample_core==2 ,  nohr nolog efron vce( cluster id) //系数
	est store sample_dual_hos
	estat phtest ,detail
	stcurve, hazard

	stcox  ${x_rent} ${z_nt}  ${w_nt}  if   sample_core==2 ,  nohr nolog efron vce( cluster id) //系数
	est store sample_dual_rent
	estat phtest ,detail
	stcurve, hazard


	global subsample " sample_full_hos sample_full_rent sample_core_hos sample_core_rent sample_dual_hos  sample_dual_rent"
	global w_2  "*.rec_gender_ *.rec_marital_status_ *.rec_d_employer_ *.n_rec_inc_grp_ *.num_child_fami *.rec_edu_ *.rec_edu_p *.rec_tenure *.hos_type_ "
	global drop ${z} ${w_2}

*-屏幕呈现
	esttab $subsample,  replace  nogap compress							       ///
			b(%20.3f) t(%7.2f) abs  not 			           ///
			star( * 0.10 ** 0.05 *** 0.01 )   ///
			addnotes("*** p<0.01; ** p<0.05; * p<0.1") 		       ///	
			title("全样本购房者和租房者的weibull模型结果")  mtitle($subsample)  

*-输出到 Word 文档 
	esttab $subsample using "${Out}/full_result2.csv", replace nogap compress      ///
			b(%20.3f) t(%7.2f) abs not 					    ///
			star( * 0.10 ** 0.05 *** 0.01 )   ///
			addnotes("*** p<0.01; ** p<0.05; * p<0.1") 								///	
			title("子样本的购房者和租房者的回归结果")  mtitle($subsample)
	
===
/*等比例风险假定检验（testing PH）*/


	stphplot, by (n_d_hos_affd) adjust (id)
	stcox ${xlist} , nolog nohr schoenfeld(schoen*) scaledsch (scaled*)

	estat phtest, log detail
	estat phtest, log plot(age) yline(0)

	stcox black alcohol drugs married workprg age educ priors tserved felon c.age#educ , nohr nolog noshow tvc(black alcohol drugs married workprg age educ priors tserved felon) texp( ln(_t) )
	lrtest, saving(0)
	quietly stcox black alcohol drugs married workprg age educ priors tserved felon c.age#educ
	lrtest, using(0)


/*分层Cox检验（stratified Cox model）*/
	stcox black alcohol drugs married workprg age educ tserved felon, strata(priors) robust nolog nohr

  	*-----结果表2：子样本的购房者和租房者的回归结果-------




*-------------------
*- resuls comparison of hazard ratio
*- 估计
// 	 foreach i of newlist exp weibull gompertz loglogistic lognormal ggamma {
// 		quietly streg  ${rent_xlist} , dist(`i') nolog 
// 		quietly est store `i'
// 		// stcurve, hazard
// 		// graph export "${Out}/Fig_Cum_hazard_`i'.png", replace
// 		// stcurve, cumhaz
// 		// graph export "${Out}/Fig_Cum_cumhaz_`i'.png", replace
// 		quietly estat ic	
// 	}

// *-模型名称 (请先执行这一行)
// 	global mm "exp weibull gompertz loglogistic lognormal ggamma"

// *-屏幕呈现
// 	esttab $mm,  replace nogap 	compress									///
// 			b(%20.3f) se(%7.2f)   aic bic    								///
// 			star( * 0.10 ** 0.05 *** 0.01 ) 		  						///		
// 			title("aaaaa")  mtitle($mm)  indicate("edu = rec_edu*")
	  
// *-输出到 Word 文档 
// 	esttab $mm using "${Out}/Campare_dist.rtf", nogaps  replace  				///
// 			b(%20.3f) se(%7.2f) aic bic obslast star( * 0.10 ** 0.05 *** 0.01 )	///
// 			title("Campare_dist")  mtitle($mm)  indicate("edu = rec_edu*")
// 			// indicate() order() drop() r2(%9.3f) ar2 obslast scalars(F)

*-输出到 latex 文档 
	// esttab using "${Out}/Campare_dist.tex", append compress nogaps replace    	///
	// 			b(%20.3f) se(%7.2f) r2(%9.3f) star( * 0.10 ** 0.05 *** 0.01 ) 	///
	// 			ar2 aic bic obslast scalars(F)  		 ///
	// 			booktabs page width(\hsize) 			 ///
	// 			title("参数模型结果比较") mtitle($mm)  
				// indicate() order() drop()



// 选定回归后，再进行一次详细解释









******************************  T5. 分段恒定对数比率模型   ******************************  
* Log-Rate Models for Piecewise Constant Rates

*----
*-5.1 分段固定风险模型（指数模型）

	drop id
	gen id=_n
	gen fail=1-cens

/*以stset命令指定持续时间变量及事件失效变量*/
	stset durat, id(id) failure(fail)
	stsplit J, at (20, 40, 60)
	list id _d _t _t0 J in 1/10

	gen origin=_t0
	gen ending=_t
	gen event=_d
	gen elapsed=ending-origin
	tab J

	tab J fail
	tab J _d

	stset elapsed, failure(event)
	xi:streg black alcohol drugs married workprg age educ priors tserved felon i.J, d(e) nolog
	xi:streg black alcohol drugs married workprg age educ priors tserved felon i.J*age, d(e) nolog

******************************  T3. 离散时间风险模型  ******************************
** Step 1 Data organization

	cap 	drop 	id
	gen 	id=_n
	sort 	id
	list 	black alcohol drugs married workprg age educ priors tserved felon in 1/10,compress table

*** 定义 观察期 follow
    by id :		gen  	follow = _N
    lab var 	follow 	"观察期"

	expand 		follow /*Duplicate observations*/

** Step 2 Variable creation

	bysort id: 	gen t = _n
	list 		id black alcohol drugs married workprg age educ priors tserved felon durat t in 68/78,compress table
	gen 		event=1
	replace 	event=0 if follow==durat & cens==1
	list 		id black alcohol drugs married workprg age educ priors tserved felon durat event t in 68/78,compress table

** Step 3 Estimation

	logit 		event black alcohol drugs married workprg age educ priors tserved felon t, nolog



    save   _temp_.dta ,replace
	