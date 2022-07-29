
**====================*
** 博士论文第3章研究
** 数据清洗程序（含age变量启动程序）
**====================*

/* 这里与人大王非老师的顺序有点不同
    他在合并数据后：完善变量标签、单变量清洗、多变量清洗、定义研究样本、变量调整 
    我是在合并数据后：（没有完善变量标签，因为大部分是已存在）、单变量清洗（特殊值转缺失值）、（定义研究样本放在之后）、变量调整
*/
    
    version   17
    clear     all 

**==============================**
**          A. 基本设定
**==============================**

global    path    "C:\\Users\\pkuzz\\OneDrive\\【日常更新】林佳颖博士论文\\第3章\\2Working" //定义项目目录	
// 需要预先在生成子文件夹：data, refs, out, adofiles
global    D       "$path\\data"       //数据文件
global    R       "$path\\refs"       //参考文献
global    Out     "$path\\out"        //结果：图形和表格
adopath   +       "$path\\adofiles"   //自编程序+外部命令 
cd        "$D"                        //设定当前工作路径



**==============================**
****    提取数据，配置工作路径  ****
**==============================**


/* ** 设定目录，使用数据
    cd  $datasource //数据提取路径
    cdout //里面有codebook
    use append_all_raw.dta , clear
    dir
    cd  $path\Work仍在进行 //返回到常规操作路径 */


**===========================**
****    D1. 提取关键变量     ****
**===========================**


//  分析主样本时RI样本
/*  是对RI1999-2016和RR2000-2018分别进行的，
        dofile在C:\Users\pkuzz\OneDrive\【日常更新】林佳颖博士论文\第3章\第3章的SOP\Work仍在进行\sample_chapter3_dofile 
        */


**===========================**
****    D2. 数据纵向合并     ****
**===========================**


* cd      "$D\\append_pre_new"  // 设置数据存放路径，合并之前数据，样本较少
* openall
cd      "$D" // 返回到常规操作路径
use     append_all_raw.dta ,clear 
save    "_temp_" , replace   

* 首先选择样本，非常规操作，通常应该在选取变量、清晰之后再选择样本
keep    if id_sampltype == 1  // 样本为RI样本


**===============================================**
****  D3. 数据清洗，特殊值转为缺失值（第一轮整体）   ****
**===============================================**


** 根据 id id_suvyear id_suvtype 3个 变量删除重复值
    * duplicates drop id id_suvyear id_sampltype, force    


** 生成id的识别变量
sort        id  id_suvyear
by id :     gen a =_n
lab var     a "样本唯一性识别变量，匹配用"
order       a
// drop industry_ occupation_ //删除行业和职业变量，因为暂时用不到



**==============================**
**          D3.1 因变量
**==============================**


**  因变量，自评健康，特殊值改为缺失值
replace     health_      = . if health_      == 9 | health_   ==. | health_ ==7 | health_ ==6
replace     health_cmpr_ = . if health_cmpr_ == 6
replace     health_p     = . if health_p     == 0 | health_p  >=6 


**  备选因变量，医疗和保险支出，特殊值改为缺失值
*** 首先生成是否有医疗支出的指示变量
gen             d_expend_med_ = (expend_med_ ~= 0) 
label var       d_expend_med_   "是否有医疗支出"
label define    expend_med      1 "有"   0 "无"
label value     d_expend_med_   expend_med


*** 对非0的人寿医疗保险，特殊值改为缺失值。（主要是稳健性分析）
local        i  expend_med_
tab         `i'
replace     `i' = . if  (`i' == 0 | `i' >= 9999995)


**  备选因变量：对最近的快乐度处理特殊值
rename   happy_     happy_recent_
local    i          happy_recent_
tab     `i'
replace `i'         = . if  (`i' >= 95 )


**  备选因变量：去年生活满意度处理特殊值

rename          sacrif_ sacrif_lyear_
local    i      sacrif_lyear_
tab     `i'
replace `i'     = . if (`i' >= 95 | `i' == 8)


order a id id_sampltype id_sampleage id_household id_suvyear id_location health_ health_cmpr_ health_p expend_med_ happy_recent_ sacrif_lyear_ birth_min_ birth_min_p birth_min_f birth_min_m birth_min_pf birth_min_mf



** 生产新的因变量，为二元类
gen         n_d_health_ = (health_ == 1 | health_ == 2 | health_ == 3)
replace     n_d_health_ = 0 if  (health_ == 4 | health_ == 5)
lab define  hel 1 "健康" 0 "不健康"
lab value   n_d_health_ hel
lab var     n_d_health_ "自认为是否健康，1为健康"



**==============================**
**          D3.2 控制变量
**==============================**

**  年龄：从出生年份（民国）到受访年龄
*** 难点在于一些年份的特殊值与其他不同。1999-2003 年的住样本的特殊值为3位数，如999\996

*** 出生年份特殊值处理

list        id  id_suvyear birth_min_p  if birth_min_p>95 , noobs sepby(id)
local       i  birth_min_p
replace     `i' = . if  (`i' == 0 |`i' >= 95) 

list  id  id_suvyear birth_min_  if birth_min_>95 , noobs sepby(id)
local i  birth_min_
replace `i' = . if  (`i' == 0 |`i' >= 95) 

local i  birth_min_pf
replace `i' = . if  (`i' == 0 |`i' >= 96 ) 

local i  birth_min_mf
replace `i' = . if  (`i' == 0 |`i' >= 96 ) 

local i  birth_min_f
replace `i' = . if  (`i' == 0 |`i' >= 96 ) 

list  id   if birth_min_f >95 & !missing( birth_min_f )  , noobs sepby(id)

local i  birth_min_m
replace `i' = . if  (`i' == 0 |`i' >= 96 ) 


*** 生成访问年龄

global a age_surv
global b birth_min

foreach i of newlist _  _p _f _m _pf  _mf {
    by id : replace ${b}`i' = ${b}`i'[1]  if  !missing( ${b}`i'[1] ) 
    by id : replace ${b}`i' = ${b}`i'[_n-1] if  !missing( ${b}`i'[_n-1] ) 
    by id : replace ${b}`i' = ${b}`i'[_n+1] if  !missing( ${b}`i'[_n+1] ) 
    by id : gen ${a}`i'     = id_suvyear[_n] - (${b}`i'[_n] + 1911)  if !missing( ${b}`i'[1])
}

by id : replace ${a}_f  =. if  ${a}_f[_n] >= 99
by id : replace ${a}_m  =. if  ${a}_m[_n] >= 99
by id : replace ${a}_pf =. if ${a}_pf[_n] >= 99
by id : replace ${a}_mf =. if ${a}_mf[_n] >= 99


clonevar age_  = age_surv_
clonevar age_p = age_surv_p
gen age_sqr  = age_ ^ 2


** 父母健在否？0值保留

    * foreach i in d_live_f d_live_m d_live_pf d_live_pm {
    *     replace `i' = . if ( `i' == 6 |`i' == 7| `i' == 8 |`i' == 9 | `i' == 0  )
    * }


* ** 因为后面生产年龄变量时会发现有很多大于100岁的，要剔除那些不健在的，先做准备

*     foreach i in d_live_f d_live_m d_live_pf d_live_pm {
*         recode `i'  ( 1 = 1 "健在")( 2 = 0 "不健在") , generate(new_`i')
*         by id : replace new_`i' =  new_`i'[1]  if  !missing( new_`i'[1] ) 
*     }   

*     by id : replace ${a}_f  =. if  ${a}_f[_n] >= 99 | new_d_live_f[_n] == 0     
*     by id : replace ${a}_m  =. if  ${a}_m[_n] >= 99 | new_d_live_m[_n] == 0     
*     by id : replace ${a}_pf =. if ${a}_pf[_n] >= 99 | new_d_live_pf[_n] == 0
*     by id : replace ${a}_mf =. if ${a}_mf[_n] >= 99 | new_d_live_pm[_n] == 0 


** 性别 重新编码+补充缺失值

local i  gender_
recode `i'  ( 1 = 1 "男性")( 2 = 0 "女性") , generate(rec_`i')
by id : replace rec_`i'  = rec_`i'[1] if  missing(rec_`i'[_n])


**  婚姻状况，1 "已婚（包括同居；2 "未婚（含分居、离婚或丧偶）

list  id  id_suvyear marital_status_ if marital_status_ == 6  & !missing( marital_status_ )  , noobs sepby(id)

local i  marital_status_
replace `i' = . if  (`i' == 95 |`i' == 96 |`i' == 97 |`i' == 98 |`i' == 0 ) // 清理缺失值
recode `i' (2/3 11 = 1 "已婚（包括同居）") (1 4/7 8 9 10 = 0 "未婚（含分居、离婚或丧偶）"), pre(rec_) 


**  教育程度

foreach i in  edu_ edu_p edu_f edu_m edu_pf edu_pm {
    recode `i' (1/3 = 1 "小学或以下") (4/11 16 = 2 "中学") (12/15 = 3 "大学或以上"),  pre(rec_)
    // 特别说明，把自修归为小学或以下，技术学院归为中学
    replace rec_`i' = . if  (`i' == 0 | `i' == 95 |`i' == 96 |`i' == 97 |`i' == 98 |`i' == 99 )
    // 0为不适用，96不知道，97其他，98拒答，99缺失
    by id : replace rec_`i'  = rec_`i'[1] if  missing(rec_`i'[_n])
}


**  工作属性的recode和处理缺失值。

local i  d_employer_
recode `i' (2 5 8= 1 "雇主") (1 3 9 = 2 "私人部门打工") (4 6 7 = 3 "公营部门"), pre(rec_) 
//  雇主：有雇佣别人、帮家里工作有无薪水；私人部门包括独自工作；公营部门：公营企业、为政府工作、为非营利机构工作
sort  id  id_suvyear
order `i' rec_`i'  id  id_suvyear a
replace rec_`i' = . if  (`i' == 0 |`i' == 97 |`i' == 98 |`i' == 99 )
replace rec_`i' = . if  (rec_`i' == 0 ) 
by id : replace rec_`i'  = rec_`i'[_n-1] if  missing(rec_`i'[_n]) &  `i'[_n] == 0


// **  就业状态（有工作属性就暂时不要就业状态）
// **  生成就业状态类别变量，同时处理缺失值。
//     gen employment_ = ( labour_mstatus_ == 1 | labour_mstatus_ == 2 )
//     replace employment_ = . if labour_mstatus_ ==. & labour_mstatus_ == 8
//     label var employment_ "受访者就业状态"
//     gen employment_p = ( labour_mstatus_p == 1 )
//     replace employment_p = . if labour_mstatus_p == 0  | labour_mstatus_p == 8
//     label var employment_p "受访者配偶就业状态"
//     label define employ 0 "失业" 1 "就业" 
//     label value  employment_  employment_p employ
//  只要就业相关的就业状态有1个为就业，就显示为就业；否则为失业
**  把编码过的原变量删除



**  住宅权属，不要跳答，RI2000忘记子女了，补充Private rental housing ;Private ownership housing
**  公有租房 私人租房 公有住房 私有住房
local i  tenure
recode `i' (1 = 1 "私有住房") (2 3 4   = 2 "私人租房") (5 6 7 8 9 10 = 3 "公有或父母亲人所有") (97 = 4 "其他"), pre(rec_) 
sort  id  id_suvyear
order `i' rec_`i'  id  id_suvyear a
recode rec_`i' (8 = 3 )  if id_suvyear == 2000 
replace rec_`i' = . if  (rec_`i' == 99 |rec_`i' == 98 | rec_`i' == 96 | rec_`i' == 0  )
by id : replace rec_`i'  = rec_`i'[_n-1] if  missing(rec_`i'[_n]) &  (`i'[_n] == 0 | `i'[_n] == .)


** 住宅型式。
** 处理缺失值。编码值完全不统一，需要重新校对

    * 编码设置：
    *     1 独院或双并式别墅或连栋透天式
    *     2 公寓、大楼或华夏
    *     3 传统农村式
    *     4 其他 
local i  hos_type_
//初步看下RI1999-2010的样貌
recode `i' (1  = 1 )(3 = 2 )(4 = 3)(5 = 4)(0 2 6 7 8 9 10 97 = . ) if (id_suvyear >= 1999 & id_suvyear <= 2014 ) 

// RI2016重新编码了，因此需要校正

recode `i' (2 3  = 1 )(7  = 2 )(8 9 = 3)(1 6 = 4)(0 4 5 97 98 99 10 = . ) if (id_suvyear >= 2016 & id_suvyear <= 2018 ) 


order `i'  id  id_suvyear a
by id : replace `i'  = `i'[_n-1] if  missing(`i'[_n])  |  `i'[_n] == 0 & (id_suvyear >= 1999 & id_suvyear <= 2014 )

label define hostype 1 "独栋"  2 "公寓" 3 "大厦" 4 "传统农村"
label value `i' hostype

**  房屋面积，不要跳答。因为有房屋权属
local i  hos_space_
order `i'  id  id_suvyear a
replace `i' = . if  (`i' >= 995 ) 
replace `i' = . if  (`i' == 0 ) 
by id : replace `i'  = `i'[_n-1] if  missing(`i'[_n])  


    ** todo 家庭结构


    * local bir  birth_min
    * foreach i of newlist _c1 _c2 _c3 _c4 { 
    * replace `bir'`i' = . if (`bir'`i' == 0 | `bir'`i'>= 996)
    * }

    // ** 把不健在的双亲剔除为缺失值    
    //     global a age_surv
    //     global c new_d_live
    //     foreach i of newlist _f _m _pf  _pm {
        //         replace $a`i' = $a`i' * $c`i'
        //         replace $a`i' = . if  $a`i' == 0
        //     } 
        // 把不健在和识别后为0的样本都变为缺失值


** 家庭子女数量（暂时没有加入）
    foreach i in  num_child_fami num_son_fami num_dau_fami{
            replace `i' = . if ( `i' >= 96 )
            by id : replace `i'  = `i'[_n-1] if  missing(`i'[_n])  
    }
    replace num_child_fami = 5 if num_child_fami >= 5
    label variable num_child_fami "家有小孩数量"
    lab define child 0 "没有" 1 "1个" 2 "2个" 3 "3个" 4 "4个" 5 "5个以上"
    lab value num_child_fami child

**==============================**
**          D3.3 关键自变量
**==============================**


** 收入系列8个变量，涉及到跳转 
** 先** 把跳答和特殊值处理为缺失值 

** 1    
order income*

local i income_month_
replace `i' = . if `i' == 1 | `i' == 9999991 | `i' == 9999992 | `i' == 9999996 | `i' == 9999997 |`i' == 9999998 | `i' == 9999999
replace `i' = `i'*1000  if income_month_ <= 100 & income_month_ != 0
//把2个RR2000年的值单位纠正，估计是写错了。因为问卷中的收入是千元
replace `i' = .  if `i' == 0 // 把0值的收入，替换为缺失值
bysort id : egen avg_`i' = mean(`i')
bysort id : replace `i'  = avg_`i'   if missing(`i')

** 2

local i income_est_month_
replace `i' = . if `i' == 1 | `i' >= 96 | `i' == 0
replace `i' = (`i' - 1.5 )*10000 if `i' <=21 & `i' >=2 
recode income_est_month_ (22 = 250000) (23 = 350000) (24 = 450000) ///
if income_est_month_ >21 & income_est_month_ <25

** 3

local i income_month_p
replace `i' = . if `i' == 1 | `i' >= 9999991 | `i' == 0
bysort id : egen avg_`i' = mean(`i')
bysort id : replace `i'  = avg_`i'   if missing(`i')


** 4

local i income_est_month_p
replace `i' = . if `i' == 1 | `i' >= 96 | `i' == 0
replace `i' = (`i' - 1.5 )*10000 if `i' <=21 & `i' >=2 
recode income_est_month_p (22 = 250000) (23 = 350000) (24 = 450000) ///
if income_est_month_p >21 & income_est_month_p <25


** 5

local i income_lyear_
replace `i' = . if `i' >= 9999991 | `i' == 0
bysort id : egen avg_`i' = mean(`i')
bysort id : replace `i'  = avg_`i'   if missing(`i')

** 6

local i income_lyear_p
replace `i' = . if `i' >= 9999991 | `i' == 0
bysort id : egen avg_`i' = mean(`i')
bysort id : replace `i'  = avg_`i'   if missing(`i')

** 7

local i income_lyear_ljob_
replace `i' = . if `i' >= 9999991 | `i' == 0
bysort id : egen avg_`i' = mean(`i')
bysort id : replace `i'  = avg_`i'   if missing(`i')

** 8

tab income_lyear_ljob_p 
local i income_lyear_ljob_p
replace `i' = . if `i' >= 9999991 | `i' == 0
bysort id : egen avg_`i' = mean(`i')
bysort id : replace `i'  = avg_`i'   if missing(`i')

drop income_lyear_ljob_ income_lyear_ljob_p

** 把3类收入合并到新的变量中，rec_收入
/* 思路是：
    1、个人月收入为缺失值，则用月估计值代替；
    2、若是个人月收入为继续缺失值，则用去年工作月收入代替；
    3、若是个人月收入为继续缺失值，则用去年工作年收入除以12代替
    */

** 受访者的收入

clonevar  rec_inc_ =  income_month_ // 个人月收入的克隆新比变量
replace   rec_inc_ =  income_est_month_  if rec_inc_ == . // 若是个人月收入为缺失值，则用月估计值代替
    * replace   rec_inc_ =  income_lyear_ljob_ if rec_inc_ == . // 若是个人月收入为继续缺失值，则用去年工作月收入代替
    replace   rec_inc_ =  income_lyear_ / 12 if rec_inc_ == . // 若是个人月收入为继续缺失值，则用去年工作年收入除以12代替
    count if  rec_inc_ == . // 计算仍旧缺失的数量

** 受访者配偶的收入

clonevar  rec_inc_p = income_month_p // 配偶个人月收入的克隆新比变量
replace   rec_inc_p =  income_est_month_p  if rec_inc_p == . // 若是个人月收入为缺失值，则用月估计值代替
    * replace   rec_inc_p =  income_lyear_ljob_p if rec_inc_p == . // 若是个人月收入为继续缺失值，则用去年工作月收入代替
    replace   rec_inc_p =  income_lyear_p / 12 if rec_inc_p == . // 若是个人月收入为继续缺失值，则用去年工作年收入除以12代替
    count if  rec_inc_p == . // 计算仍旧缺失的数量


**  生产住宅负担变量（30/40原则）：区分购房户和租房户


***     购房户：区分已婚和未婚
****    已婚购房户的家庭贷款支出与未婚月贷款支出是一样的  expend_hosload_
*****   生成月家庭收入变量 n_income_fami （包含已婚和未婚）
*****   已婚购房户家庭月收入：调查者及其配偶的月收入之和
egen n_income_fami = rowtotal( rec_inc_ rec_inc_p)  if rec_marital_status_ == 1
//rowtotal 是暂时把括号内变量的缺失值视为0


*****   未婚购房户家庭月收入
replace n_income_fami = rec_inc_ if rec_marital_status_ == 0 | !missing(n_income_fami)
replace n_income_fami =. if n_income_fami == 0
lab var n_income_fami "家庭月收入"


***     识别收入40百分的家庭或个人
***     生成家庭收入位于1%-40%分位数之间的低收入家庭群体
sort id  id_suvyear

****    在当年内的群体中找低收入群体 （个人认为应该是这个）
winsor n_income_fami, gen( n_income_fami_w ) p(0.025) 
gen n_d_HAS_lowinc = . if missing(n_income_fami_w)

foreach i in 1999 2000 2001 2002 2004 2005 2006 2007 2008 2009 2010 2011 2012 2014 2016 2018 {
    _pctile n_income_fami_w  if id_suvyear == `i' &  n_income_fami_w != . , p(${low_down} ${low_upper})
    bysort id_suvyear : replace n_d_HAS_lowinc = ( n_income_fami_w >= r(r1) &  n_income_fami_w <= r(r2))
}

label variable n_d_HAS_lowinc "家庭收入位于1%-40%分位数的低收入家庭群体"
lab define low 1 "当年低收" 0 "非低收"
lab value n_d_HAS_lowinc low



*   住房支出

**  购房还贷

**  只保存有房贷支出的样本,先保留极端值（若是结婚，就是家庭的房贷支出；若没有结婚，就是个人房贷支出）

local i  expend_hosload_
sort  id  id_suvyear
order `i' id  id_suvyear a
replace `i' = . if  (`i' >= 9999991 | `i' == 0)
bysort id : egen avg_`i' = mean(`i')
bysort id : replace `i'  = avg_`i'   if missing(`i') & !missing(`i'[_n-1])


**   对是否有房贷的特殊值处理，可以后续做子样本分析，研究贷款行为（样本筛选，可以从“房子是谁的”入手）。
**   不保存“0 跳答/不適用(非自己或配偶所有) ”

local i  d_houseload_
sort  id  id_suvyear
order `i' id  id_suvyear a
replace `i' = . if  (`i' >= 6  | `i' == 0 )
replace `i' = 1 if  !missing(expend_hosload_) 
replace `i' = 2 if   missing(expend_hosload_)


* · 租房 
**  查看单位，有小于的数字，很多出现。租金与房贷是同样的处理方式

local i  expend_rent_ 
sort  id  id_suvyear
order `i' id  id_suvyear a
/* list  id_suvyear id_suvtype if `i' <= 10 &  `i' != 0 // 发现RR2004的样本居多，回去要看RR2004的codebook,单位是千元 */
replace `i' = `i' * 1000 if id_suvyear == 2004 | `i' <= 100 // RR2004租金已经转为元
replace `i' = . if  `i' >= 9999990
replace `i' = . if  `i' >= 999996 & `i' <= 999999
replace `i' = . if  `i' == 0
bysort id : egen avg_`i' = mean(`i')
bysort id : replace `i'  = avg_`i'   if missing(`i') & !missing(`i'[_n-1])
replace `i' = . if  d_houseload_ == 1

gen d_houserent_ = !missing(expend_rent_)


***     识别贷款占比30以上的家庭或个人

***     购房户：住宅负担
gen n_hos_affd    = expend_hosload_ / n_income_fami  // 计算房贷支出占家庭收入比
lab var n_hos_affd "房贷月支出/家庭月收入的所得比"
gen n_d_hos_affd =  ( n_hos_affd >= ${min_expd} &  n_hos_affd < ${max_expd} ) if          n_d_HAS_lowinc == 1 | d_houseload_ == 1
order n_hos_affd  n_d_HAS_lowinc  id  id_suvyear a   
replace n_d_hos_affd = 0 if missing(n_d_hos_affd) |  n_d_HAS_lowinc == 0


// 购房贷款支出占比在25%-35%之间
lab var n_d_hos_affd "住户是否处于住宅不能负担状态"
lab define haffd 0 "住宅可负担" 1 "住宅不可负担" //正确的赋值
lab value n_d_hos_affd haffd



***     租房户：租金支出/家庭月收入的所得比

gen     n_rent_affd   = expend_rent_ / n_income_fami // 计算房贷支出占家庭收入比
lab var n_rent_affd     "房租月支出/家庭月收入的所得比"
gen     n_d_rent_affd = ( n_rent_affd >= ${min_expd} & n_rent_affd < ${max_expd} ) if       n_d_HAS_lowinc == 1
replace n_d_rent_affd = 0 if missing( n_d_rent_affd ) |  n_d_HAS_lowinc == 0
replace n_d_rent_affd = . if d_houseload_ == 1 | missing( n_rent_affd )
// 月租金支出占比在25%-35%之间
lab var n_d_rent_affd "租户是否处于住宅不能负担状态"
lab     define raffd 0 "租宅可负担" 1 "租宅不可负担"
lab     value n_d_rent_affd raffd

replace n_d_hos_affd = . if  !missing( n_d_rent_affd ) | missing( n_d_hos_affd )


**==============================**
**          D3. 数据清洗，处理缺失值（第二轮查漏、调整）
**==============================**


**==============================**
**          D4. 数据清洗，生产分组变量和新变量，n_为前缀（数据描述阶段的回头调整）
**==============================**

** 对个人月收入进行分组（便于后续描述）
// 第0组到第4组分别为：< 22000, 22000-44000, 44000-66000, 66000-88000, > 88000
winsor rec_inc_, gen( rec_inc_w_ ) p(0.025) highonly

gen n_rec_inc_grp_  = 0 if ( rec_inc_w_ <= 15000 )
replace n_rec_inc_grp_  = 1 if ( rec_inc_w_ > 15000 & rec_inc_w_ <= 30000  )
replace n_rec_inc_grp_  = 2 if ( rec_inc_w_ > 30000 & rec_inc_w_ <= 45000  )
replace n_rec_inc_grp_  = 3 if ( rec_inc_w_ > 45000 & rec_inc_w_ <= 60000  )
replace n_rec_inc_grp_  = 4 if ( rec_inc_w_ > 60000 & rec_inc_w_ <= 75000  )
replace n_rec_inc_grp_  = 5 if ( rec_inc_w_ > 75000 & rec_inc_w_ <= 90000  )
replace n_rec_inc_grp_  = 6 if ( rec_inc_w_ > 90000   )
lab var n_rec_inc_grp_ "个人月收入分组"
// 定义及赋予值标签

lab define incgrp 0 "小于等于15000" 1 "15000-30000" 2 "30001-45000" 3 "45001-60000" 4  "60001-75000" 5 "75001-90000" 6 "大于90000"
lab val n_rec_inc_grp_ incgrp
*** 生成月收入的自然对数值（便于后续描述、分析）
gen n_lnrec_inc_ = ln(rec_inc_)
lab var n_lnrec_inc_ "ln(月收入)"

** 生成年龄分组（便于后续描述）
// 第1组到第4组分别为：<= 35, 36-50, 51-65, > 65
gen     n_age_grp = 0 if age_surv_ <= 30
replace n_age_grp = 1 if age_surv_ > 30 & age_surv_ <= 40
replace n_age_grp = 2 if age_surv_ > 40 & age_surv_ <= 50
replace n_age_grp = 3 if age_surv_ > 50 & age_surv_ <= 60
replace n_age_grp = 4 if age_surv_ > 60 & age_surv_ <= 65
replace n_age_grp = 5 if age_surv_ > 65 & age_surv_ <= 75
replace n_age_grp = 6 if age_surv_ > 75 & age_surv_ < .

// 定义及赋予标签
lab def agegrp 0 "<= 30" 1 "30-40" 2 "40-50" 3 "50-60" 4 "60-65" 5 "65-75" 6 "> 75"
lab val n_age_grp agegrp
lab var n_age_grp "年龄分组"

// ** 可以看出生世代（60年代、70年代、80年代，等），日后可分析。在第4章或其他章节
// ** 可以按居住地址分组，日后在第4章中进行。


  ** 生存老人家户
  
    local     age age_surv_
    gen       sample_core = ( `age' >= 25 & `age'p >= 25 ) 
    replace   sample_core = 2 if  (( `age' < 60 & `age'p < 60 ) & (`age'f >= 65 | `age'm >= 65 | `age'pf >= 65 | `age'mf >= 65 )) 
    recode sample_core (1 = 1) (2 = 2) ( 0  . = . )
    lab var sample_core "样本分组标识"
    lab define sample 1 "核心老年家户" 2 "双亲老年家户"
    lab val  sample_core sample


cd "$D"                       //设定当前工作路径
save    data_dealed.dta , replace
exit






