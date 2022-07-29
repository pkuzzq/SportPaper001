*******
* 这个脚本将所有必要的Stata软件包安装到/libraries/stata中。
* 要重新安装所有Stata软件包，请删除整个/libraries/stata文件夹。
* 注意：这个脚本只为教学目的而提供。它不应该作为你的复制材料的一部分，因为这些附加组件已经在/libraries/stata中可用。
*******

* Create and define a local installation directory for the packages
cap mkdir "$MyProject/scripts/libraries"
cap mkdir "$MyProject/scripts/libraries/stata"
net set ado "$MyProject/scripts/libraries/stata"


* Install latest developer's version of the package from GitHub
foreach p in regsave texsave rscript {
	net install `p', from("https://raw.githubusercontent.com/reifjulian/`p'/master") replace
}


* Install packages from SSC
foreach p in ingap {
	local ltr = substr(`"`p'"',1,1)
	qui net from "http://fmwww.bc.edu/repec/bocode/`ltr'"
	net install `p', replace
}



** EOF
