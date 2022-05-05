**====================*
** Paper_1 研究
** 主程序
**====================*

/* 这里与人大王非老师的顺序有点不同
    他在合并数据后：完善变量标签、单变量清洗、多变量清洗、定义研究样本、变量调整 
    我是在合并数据后：（没有完善变量标签，因为大部分是已存在）、单变量清洗（特殊值转缺失值）、（定义研究样本放在之后）、变量调整

ssc install outreg2, replace
ssc install estout, replace
ssc install outsum, replace
ssc install firstdigit, replace
ssc install unique, replace
ssc install ftools, replace
ssc install reghdfe, replace
ssc install sxpose, replace
*/
    version   16
    clear all
    set more off, permanent

**==============================**
**          A. 基本设定
**==============================**

    global    path    "~/Desktop/Paper01" //定义项目目录 
    global    SourceData    "$path/SourceData"       //数据文件
    global    WorkData      "$path/WorkData"        //数据文件
    global    Refs          "$path/Refs"            //参考文献
    global    Output        "$path/Output"          //结果：图形和表格
    adopath   +             "$path/Code"            //自编程序+外部命令 
    cd        $SourceData                                //设定当前工作路径




** 画图设定
    set     scheme  s2color,perm //将默认图形方案设置为Stata Journal所使用的方案，默认为s2color(factory setting)
    grstyle init  //初始化
    grstyle set     plain, horizontal grid  //设置背景和坐标系
    grstyle set     legend 2, inside nobox  //将图例放置于绘图区域内部的2点钟位置(右上)
    grstyle set     color Dark2 //使用Dark2调色板，可使用命令colorpalette Dark2查看调色板颜色
    // grstyle set     ci Dark2, opacity(20) //设置置信区间的不透明度为20%
    grstyle set     symbol  //设置符号格式，T代表三角形，S代表正方形，具体可通过help symbolstyle查看
    grstyle set     lpattern  //设置线条格式，具体线条格式可通过help linepatternstyle查看 "-." "--.."

*-核心参考资料 (参考文献和文档都存放于 $R 文件夹下)
*-  shellout "$R\Safin_Federer_2005_Aust.pdf"

***************************************************************
****    1 Data_cleaning     
***************************************************************

  cd $path     //设定当前工作路径
  // do Data_cleaning.do

***************************************************************
****    2 Sample_selection     
***************************************************************
  
  cd $path     //设定当前工作路径
  // do Sample_selection.do

***************************************************************
****    3 Summary_stats     
***************************************************************
  
  cd $path     //设定当前工作路径
  // do Summary_stats.do

***************************************************************
****    4 Regressions     
***************************************************************

  cd $path     //设定当前工作路径
	// do Regressions#survival.do

  
