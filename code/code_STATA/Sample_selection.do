**====================*
** 博士论文第3张研究
** 主程序
**====================*

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
    cd $D                      //设定当前工作路径

    use data_dealed.dta,clear

** 选择变量
    
  keep id a id_suvyear id_sampltype health_*  n_*  rec* sample_core   num_child_fami hos_space_ hos_type_ n_rec_inc_grp_ age_sqr age_ age_p id_sampleage
  
  order id id_suvyear a sample_core health_ health_p health_cmpr_  n_d_hos_affd n_d_rent_affd rec_gender_ rec_marital_status_ rec_d_employer_  n_rec_inc_grp_ num_child_fami  rec_edu_ rec_edu_f rec_edu_m rec_edu_p rec_edu_pf rec_edu_pm  rec_tenure hos_type_ hos_space_

  // keep if  sample_core == 1 
  // keep if  sample_core == 2 


  save    data_dealed.dta , replace
  exit

