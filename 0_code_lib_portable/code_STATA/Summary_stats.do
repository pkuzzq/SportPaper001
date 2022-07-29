**====================**
** **研究
** 数据描述程序
**====================**
    version   16
    clear     all 

***************************************************************
****    A. 基本设定     
***************************************************************

    global path "C:\\Users\\pkuzz\\OneDrive\\【日常更新】林佳颖博士论文\\第3章\\2Working" //定义项目目录	
    // 需要预先在生成子文件夹：data, refs, out, adofiles
    global D    "$path\\data"      //数据文件
    global R    "$path\\refs"      //参考文献
    global Out  "$path\\out"       //结果：图形和表格
    adopath +   "$path\\adofiles"  //自编程序+外部命令 
    cd $D                      	   //设定当前工作路径
** 画图设定
    set scheme s2color //将默认图形方案设置为Stata Journal所使用的方案，默认为s2color(factory setting)
    grstyle init  //初始化
    grstyle set plain, horizontal grid  //设置背景和坐标系
    grstyle set legend 2, inside nobox  //将图例放置于绘图区域内部的2点钟位置(右上)
    grstyle set color Dark2 //使用Dark2调色板，可使用命令colorpalette Dark2查看调色板颜色
    // grstyle set ci Dark2, opacity(20) //设置置信区间的不透明度为20%
    grstyle set symbol  //设置符号格式，T代表三角形，S代表正方形，具体可通过help symbolstyle查看
    grstyle set lpattern  //设置线条格式，具体线条格式可通过help linepatternstyle查看 "-." "--.."

*-核心参考资料 (参考文献和文档都存放于 $R 文件夹下)
*-  shellout "$R\Safin_Federer_2005_Aust.pdf"

    use data_dealed.dta,clear

***************************************************************
****    S1.数据设定（寻求显著）     
***************************************************************


*todo 这里针对data_dealed以及生存分析专用模型的设定，若是增加样本|修正控制变量|变更编码等，需要返回D#do文件中操作
** 仅仅留下重要变量，目的生成event、durat、cens、follow
    
** 生成 每个户的观察时间指示变量 _j
    bysort id :	gen _j =_n 
    lab var _j 			"个体观察值第几次的标记" 
    order 	id _j id_suvyear id_sampltype

** 选定 兴趣事件变量，但现在还无法定义什么是事件发生 event_? 
    *todo 这里变更兴趣变量
    global 	event health_
    // health_cmpr_ //户主与一年前相比的健康状况
    // health_
    // happy_recent_
    // sacrif_lyear_
    drop if missing(${event}) //消除兴趣事件的缺失值

**  定义 整个事件的持续时间 duration  
*** 定义事件每个观察值时间点 date1  
    clonevar 	time_end = id_suvyear
    label 		variable time_end "每条观测结束时点"
    drop if 	time_end== . 
*** 定义事件每个观察值时间起点 date0，date是结束时间，event_? 是兴趣事件变量在date时的取值
    snapspan 	id time_end ${event} ,gen(time_begin)  replace
// 	note:  1437 obs. (17.4%) have only a single record; they will be ignored
    label 	variable time_begin "每条观测起始时点"

    stset time_end ,failure(${event} == 3 4 5) origin(${event} == 1 2 )  id(id) time0(time_begin)

*! 非常重要
** stset 选项构成与解释
*!  failure 代表事件发生的状态编码，认定什么是事件发生
*!	origin 某编码标志出现之后(不包含该编码)事件才有可能发生其,之前(包含本身)_d变量一定为0。可以是事件编码,也可以事件
*!	enter 某编码标志出现之后(不包含该编码)观测值才有效,其之前(包含本身)_st变量一定为0
*!	exit  某编码标志出现之前(不包含该编码)观测值才有效,其之后(包含本身)_st变量一定为0

**  stset生成后
	label variable _st "1为数据可用"
	label variable _d  "1为事件发生0为删失"
	label variable _t  "每条观测结束时点距初次进入样本时间-Analysis time when record ends"
	label variable _t0 "每条观测起始时点距初次进入样本时间-Analysis time when record begins"
	
** 数据特征描述  
    // stdes
  
** 数据示例  
    // sts list in 1/20



***************************************************************
****    S1. 数据描述-基本描述性统计    
***************************************************************

  // 如果数据处理部分未作更新，可直接这里进行后续分析

  *-----表1：基本统计量-------
	local v1 " _d health_  n_d_hos_affd n_d_rent_affd rec_gender_ rec_marital_status_ rec_d_employer_  n_rec_inc_grp_ num_child_fami  rec_edu_ rec_edu_f rec_edu_m rec_edu_p rec_edu_pf rec_edu_pm  rec_tenure hos_type_  " //填入变量名 

	// 分类变量做表需要tabulate生成虚拟变量
	foreach i in `v1' {
		tabulate `i', gen(dum_`i')
	} 
	local v " dum_* hos_space_ age_ age_p  " //增加连续变量

	// 将总样本分为2类子样本处理	
	eststo full: 	estpost summarize `v'  if !missing(sample_core) 
	eststo core: 	estpost summarize `v'  if sample_core==1
	eststo dual: 	estpost summarize `v'  if sample_core==2
	eststo diff: 	estpost ttest 	  `v', by(sample_core)
	

	// 生成表格
	#delimit ; 								//声明后续以分号为断行，作图表时常用，选项较多 
	local s "$Out\\Table1_sum_sample.rtf"; 	//存储的文件名(或路径\文件名)
	esttab full core dual diff using `s'
	, 
		replace nogap compress  			//无空行，紧凑
		cell(
			 "sum(pattern(1 1 1 0) 		fmt(0)) 
			  count(pattern(1 1 1 0) 	fmt(0)) 
			  b(pattern(0 0 0 1) 		fmt(2)) 
			  se(pattern(0 0 0 1) 		fmt(2))"
			) 
		mtitle("full" "core" "dual" "Difference (3)-(2)");
	#delimit  cr

***************************************************************
****    S2. 数据样本分布图    
***************************************************************


	#d ; //声明后续以分号为断行，作图时常用，选项较多 
	graph bar (count) 
	,  												//	后面都是选项设定
	  	over(sample_core, gap(0)  label(nolabel)) 	//	首先按照样本分类, 无横坐标标签
	  	over(n_age_grp,	label(labsize(small)))    	//	其次按照年龄分类，横坐标标签字体小号
	  	asyvars                             		//	按照地区在y轴分类
	  	ylabel(, tposition(inside) labsize(*0.8) angle(0)) 
	   		//	纵轴刻度和标签设定
	  			//	纵坐标从0-100，0(20)100
	  			//	刻度线朝内,tposition(inside) 
	  			//	y轴标签字号为默认字号的 0.8 倍,labsize(*0.8)
				//	标签为纵向放置 (默认是横向),angle(0)
	  	ytitle("", tstyle(smbody)) // y 轴标题为小号字体
	  	blabel(bar, size(vsmall) format(%3.0f)) 	//	产生数字标签，字体小号，固定格式保留0位小数
	  	// bar(1, color(" `r(color1)' ")) 
	  	// bar(2, color(" `r(color2)' "))  
	  	legend(
	  		// title("子样本")
	  		label(1 "核心老年家户") 
			label(2 "双亲老年家户") 
			order(1 2 ) 
			size(small)
			  ) 									//图例: 标签按照地区排列，图例字体小号
	  graphregion(color(white)) 					//图片底色为白色
	  ;
	  local s "$Out\\Figure_sample_distribution"; //存储的文件名(或路径\文件名)
	  gr save 	`s'.gph,replace ;
	  gr export `s'.png,replace width(1600);
	  gs_fileinfo `s'.gph; //从gph召回代码，即便是手动修改也能看到改动
	di r(command);
	#delimit  cr


  	save    data_dealed.dta , replace
	exit

***************************************************************
****    SX.	下面暂时未用到    
***************************************************************

	local yv .2			//阴影区域顶部的y值         
	local x1 10			//x值的第一个        
	local x2 15			//x值的第一个        
	local ac "orange"	// 双向箭头的颜色; "none"=no arrow   
	local aw 1.5 		//双向箭头的厚度      
	local ps 25			//阴影区透明度，%

	#d ; //声明后续以分号为断行，作图时常用，选项较多 
	tw (
		scatteri `yv' `x1' `yv' `x2',
    	recast(area) col(gs10%`ps') lw(0)
    	) 
    	(
    		fun y=gammaden(6,1,0,x), lp(solid) ra(0 20) 
    		plotr(marg(zero)) graphr(col(white)) xla(0(2)20) 
    		xtitle(" " "x") leg(off) lc(ebblue) lw(*2.5) 
    		xli(`x1' `x2', lc(gs8) noex) 
    		ytitle("f(x)", orient(hor)) ylabel(,ang(360) tposition(inside))
    	)
    		//  
    	(
    		pcarrowi .075 `x1' .075 `x2'
    		,
    		msi(`aw') lw(*`aw') mlw(*`aw') 
    		mlc("`ac'") lc("`ac'") 
    		recast(pcbarrow) 
    		text(.09 12.5 "(some x-window" "of interest)")
    	);
    local s "$Out\\graph";
	gr save `s'.gph,replace ;
	gr export `s'.png,replace width(1600);
	gs_fileinfo `s'.gph; //从gph召回代码，即便是手动修改也能看到改动
	di r(command);
	#d cr //声明后续以分号为断行，作图时常用，选项较多 




  *-----表x：相关系数矩阵-------
  local v " " //填入变量名
  local s "$Out\Table2_corr" //存储的文件名(或路径\文件名)
  logout, save("`s'") excel replace: ///
          pwcorr_a `v', format(%6.2f) //star(0.05)

****************************** S2. 数据描述-分组统计分析  ****************

  use "data_dealed.dta", clear  
  *-----表x：组间均值差异检验-------
  local v "" //填入变量名
  local s "$Out\\ttable2" //存储的文件名(或路径\文件名)
  logout, save("`s'") excel replace: ///
          ttable2 `v', by(variable) format(%6.2f)


****************************** S3. 数据描述-因变量数据描述 ****************
*** 因变量取值分布描述
	tab totinc_grp year if sample, col	// 未加权的取值分布(频数+频率)
	tab totinc_grp year if sample [aw=wgt], col	// 加权的取值分布(频数+频率)
*** 加权的统计指标：均值、中位数、标准差、极差
	tabstat totinc if sample [aw=wgt], s(mean median sd range) by(year)	


******************************  因变量（个人健康）数据描述  ******************************
** 因变量取值分布描述（tab 命令，习惯上把因变量放在第二个位置）
*** 按调查年份看
	tab id_suvyear  	d_health_  if id_suvtype ,row // 未加权的取值分布(频数+频率)
	tab id_suvyear  	d_health_  if id_suvtype [aw=weight_3rd], row	// 加权的取值分布(频数+频率)
*** 按收入分组看
	tab rec_inc_grp_	d_health_  if id_suvtype ,row // 未加权的取值分布(频数+频率)
	tab rec_inc_grp_	d_health_  if id_suvtype [aw=weight_3rd], row	// 加权的取值分布(频数+频率)
*** 按年龄分组看
	tab age_grp	        d_health_  if id_suvtype ,row // 未加权的取值分布(频数+频率)
	tab age_grp		    d_health_  if id_suvtype [aw=weight_3rd], row	// 加权的取值分布(频数+频率)
*** 按住房负担看
	tab d_rent_affd     d_health_  if id_suvtype ,row // 未加权的取值分布(频数+频率)
	tab d_rent_affd     d_health_  if id_suvtype [aw=weight_3rd], row	// 加权的取值分布(频数+频率)


reg  health_ d_rent_affd  i.gender_ i.rec_inc_grp_ employment_ employment_p i.age_grp  i.hos_type_



******************************  因变量（住宅负担）数据描述  ******************************
*** 按调查年份看
	tab id_suvyear  	d_hos_affd  if id_suvtype ,row // 未加权的取值分布(频数+频率)
	tab id_suvyear  	d_hos_affd  if id_suvtype [aw=weight_3rd], row	// 加权的取值分布(频数+频率)
*** 按收入分组看
	tab rec_inc_grp_	d_hos_affd  if id_suvtype ,row // 未加权的取值分布(频数+频率)
	tab rec_inc_grp_	d_hos_affd  if id_suvtype [aw=weight_3rd], row	// 加权的取值分布(频数+频率)
*** 按年龄分组看
	tab age_grp	        d_rent_affd  if id_suvtype ,row // 未加权的取值分布(频数+频率)
	tab age_grp		    d_hos_affd  if id_suvtype [aw=weight_3rd], row	// 加权的取值分布(频数+频率)
*** 按住房负担看
* todo:
	- 找分析的Y的思路，同时考虑怎么呈现在论文中。设计第3章的分析架构
	- 生成住宅负担变量√
	- 需要把样本重新确定，每个样本只保留其在主样本时，也就是第一出现
	- 现在是如何把RI样本中的缺失值，用RR中的信息补充，还不再扩充样本数量。

*** 未加权的统计指标：均值、中位数、标准差、极差
	tabstat health_ if id_suvtype , s(mean median sd range) by(id_suvyear)	

*** 未加权的频率分布图
	histogram health_, discrete percent barwidth(0.8) normal scheme(s1mono) by(age_grp)
	//补充了正态图，发现，年龄大的组别，更正态，而年龄小，更右篇。
	graph save health_by_agegrp , replace

*** 加权的历年核密度分布图
	twoway kdensity ltotinc if sample & year == 2005 [aw=wgt] ||	///
		   kdensity ltotinc if sample & year == 2010 [aw=wgt] ||	///
		   kdensity ltotinc if sample & year == 2015 [aw=wgt],	///
		   legend(lab(1 "2005") lab(2 "2010") lab(3 "2015") col(3))	///
		   xtitle("总收入") ytitle("核密度（加权）")
	graph save ltotinc_w, replace

*========== 自变量数据描述 ==========*
*** 关键自变量取值分布描述
	tab educ year if sample, col	// 未加权的取值分布(频数+频率)
	tab educ year if sample [aw=wgt], col	// 加权的取值分布(频数+频率)
	
*** 控制变量描述
* 城乡
	tab region year if sample, col	// 未加权的取值分布(频数+频率)
	tab region year if sample [aw=wgt], col	// 加权的取值分布(频数+频率)
* 性别
	tab gender year if sample, col	// 未加权的取值分布(频数+频率)
	tab gender year if sample [aw=wgt], col	// 加权的取值分布(频数+频率)
* 民族
	tab han year if sample, col	// 未加权的取值分布(频数+频率)
	tab han year if sample [aw=wgt], col	// 加权的取值分布(频数+频率)
* 省份
	tab prov year if sample, col	// 未加权的取值分布(频数+频率)
	tab prov year if sample [aw=wgt], col	// 加权的取值分布(频数+频率)
* 出生年份
	tab bthyr_grp year if sample, col	// 未加权的取值分布(频数+频率)
	tab bthyr_grp year if sample [aw=wgt], col	// 加权的取值分布(频数+频率)
* 年龄
	tab age_grp year if sample, col	// 未加权的取值分布(频数+频率)
	tab age_grp year if sample [aw=wgt], col	// 加权的取值分布(频数+频率)
	tabstat age if sample [aw=wgt], s(mean median sd range) by(year)	// 加权的统计指标：均值、中位数、标准差、离差

*========== 因变量与关键自变量联合描述 ==========*
*** 联合取值分布
	bysort year: tab educ totinc_grp if sample, cell	// 历年未加权的取值分布(频数+频率)
	bysort year: tab educ totinc_grp if sample [aw=wgt], cell	// 历年加权的取值分布(频数+频率)
*** 加权的统计指标：均值、中位数、标准差、四分位差，分教育组
	table educ year if sample [aw=wgt], ///
		  c(mean totinc median totinc sd totinc iqr totinc) row col
/*
*** 历年联合分布图(未加权)
	twoway scatter ltotinc educ if sample & year == 2005, m(Oh) mc(black) ||	///
		   scatter ltotinc educ if sample & year == 2010, m(Th) mc(red)	||	///
		   scatter ltotinc educ if sample & year == 2015, m(Sh) mc(blue)	///
		   legend(lab(1 "2005") lab(2 "2010") lab(3 "2015") col(3)) xlab(,val)
	   
*** 历年统计指标图
	graph box ltotinc if sample [aw=wgt], over(year) over(educ)
*/

*========== 因变量与关键自变量关联的异质性（针对的是外生变量的分组）描述 ==========*
*** 分城乡
* 联合取值分布
	bysort year: tab educ region if sample, cell	// 历年未加权的取值分布(频数+频率)
	bysort year: tab educ region if sample [aw=wgt], cell	// 历年加权的取值分布(频数+频率)
* 因变量统计指标
	table educ region year if sample [aw=wgt], c(mean totinc median totinc) col row


** 存储数据
exit



****************************** 因变量数据描述 ******************************
*** 因变量取值分布描述
	tab totinc_grp year if sample, col	// 未加权的取值分布(频数+频率)
	tab totinc_grp year if sample [aw=wgt], col	// 加权的取值分布(频数+频率)
*** 加权的统计指标：均值、中位数、标准差、极差
	tabstat totinc if sample [aw=wgt], s(mean median sd range) by(year)	
/*
*** 未加权的历年核密度分布图
	twoway kdensity ltotinc if sample & year == 2005 ||	///
		   kdensity ltotinc if sample & year == 2010 ||	///
		   kdensity ltotinc if sample & year == 2015,	///
		   legend(lab(1 "2005") lab(2 "2010") lab(3 "2015") col(3))	///
		   xtitle("总收入") ytitle("核密度（未加权）")
	graph save ltotinc_uw, replace
*** 加权的历年核密度分布图
	twoway kdensity ltotinc if sample & year == 2005 [aw=wgt] ||	///
		   kdensity ltotinc if sample & year == 2010 [aw=wgt] ||	///
		   kdensity ltotinc if sample & year == 2015 [aw=wgt],	///
		   legend(lab(1 "2005") lab(2 "2010") lab(3 "2015") col(3))	///
		   xtitle("总收入") ytitle("核密度（加权）")
	graph save ltotinc_w, replace
*/	
****************************** 自变量数据描述 ******************************
*** 关键自变量取值分布描述
	tab educ year if sample, col	// 未加权的取值分布(频数+频率)
	tab educ year if sample [aw=wgt], col	// 加权的取值分布(频数+频率)
	
*** 控制变量描述
* 城乡
	tab region year if sample, col	// 未加权的取值分布(频数+频率)
	tab region year if sample [aw=wgt], col	// 加权的取值分布(频数+频率)
* 性别
	tab gender year if sample, col	// 未加权的取值分布(频数+频率)
	tab gender year if sample [aw=wgt], col	// 加权的取值分布(频数+频率)
* 民族
	tab han year if sample, col	// 未加权的取值分布(频数+频率)
	tab han year if sample [aw=wgt], col	// 加权的取值分布(频数+频率)
* 省份
	tab prov year if sample, col	// 未加权的取值分布(频数+频率)
	tab prov year if sample [aw=wgt], col	// 加权的取值分布(频数+频率)
* 出生年份
	tab bthyr_grp year if sample, col	// 未加权的取值分布(频数+频率)
	tab bthyr_grp year if sample [aw=wgt], col	// 加权的取值分布(频数+频率)
* 年龄
	tab age_grp year if sample, col	// 未加权的取值分布(频数+频率)
	tab age_grp year if sample [aw=wgt], col	// 加权的取值分布(频数+频率)
	tabstat age if sample [aw=wgt], s(mean median sd range) by(year)	// 加权的统计指标：均值、中位数、标准差、离差

****************************** 因变量与关键自变量联合描述 ******************************
*** 联合取值分布
	bysort year: tab educ totinc_grp if sample, cell	// 历年未加权的取值分布(频数+频率)
	bysort year: tab educ totinc_grp if sample [aw=wgt], cell	// 历年加权的取值分布(频数+频率)
*** 加权的统计指标：均值、中位数、标准差、四分位差，分教育组
	table educ year if sample [aw=wgt], ///
		  c(mean totinc median totinc sd totinc iqr totinc) row col
/*
*** 历年联合分布图(未加权)
	twoway scatter ltotinc educ if sample & year == 2005, m(Oh) mc(black) ||	///
		   scatter ltotinc educ if sample & year == 2010, m(Th) mc(red)	||	///
		   scatter ltotinc educ if sample & year == 2015, m(Sh) mc(blue)	///
		   legend(lab(1 "2005") lab(2 "2010") lab(3 "2015") col(3)) xlab(,val)
	   
*** 历年统计指标图
	graph box ltotinc if sample [aw=wgt], over(year) over(educ)
*/
****************************** 因变量与关键自变量关联的异质性描述 ******************************
*** 分城乡
* 联合取值分布
	bysort year: tab educ region if sample, cell	// 历年未加权的取值分布(频数+频率)
	bysort year: tab educ region if sample [aw=wgt], cell	// 历年加权的取值分布(频数+频率)
* 因变量统计指标
	table educ region year if sample [aw=wgt], c(mean totinc median totinc) col row
*** 分性别
*** 分民族
*** 分地区（依据省份划分为几个地区）
*** 分出生年份组
*** 分年龄


exit