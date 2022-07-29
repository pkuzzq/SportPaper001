# 这个脚本打算由Stata来调用，Stata会给它提供它所需要的两个参数
# 如果独立运行，该脚本假定项目目录已经由系统变量 "MyProject "设定。
# --- 另外，用户可以通过手动编辑 "MyProject <- Sys.getenv(c("MyProject")) "这一行，将其作为一个独立的脚本运行。

args = commandArgs(trailingOnly = "TRUE")
if (length(args)) {
  dataset <- args[1]
  output <- args[2]
} else {
  MyProject <- Sys.getenv(c("MyProject"))
  dataset <- file.path(MyProject, "processed/auto_uncleaned")
  output <- file.path(MyProject, "results/intermediate/my_lm_regressions.dta")
}

# Load required libraries
library(tidyverse)
library(haven)
library(estimatr)

# Example of how to load a package from a project-specific library (provided for pedagogical purposes only)
# library(estimatr,lib = file.path(Sys.getenv(c("MyProject")), "scripts/libraries/R/windows/"))

my_data <- read_dta(dataset)

# Estimate OLS assuming HC1 standard errors (equivalent to "robust" in Stata)
ols1 <- lm_robust(price ~ mpg, data = my_data %>% filter(foreign=="Domestic"), se_type = "HC1")

ols2 <- lm_robust(price ~ mpg, data = my_data %>% filter(foreign=="Foreign"), se_type = "HC1")

ols3 <- lm_robust(price ~ mpg + weight, data = my_data %>% filter(foreign=="Domestic"), se_type = "HC1")

ols4 <- lm_robust(price ~ mpg + weight, data = my_data %>% filter(foreign=="Foreign"), se_type = "HC1")

# Format regression output and write to file
tidyols1 = add_column(tidy(ols1),origin="Domestic")
tidyols1 = add_column(tidyols1,rhs="mpg")
tidyols2 = add_column(tidy(ols2), origin ="Foreign")
tidyols2 = add_column(tidyols2,rhs="mpg")
tidyols3 = add_column(tidy(ols3), origin ="Domestic")
tidyols3 = add_column(tidyols3,rhs="mpg weight")
tidyols4 = add_column(tidy(ols4), origin ="Foreign")
tidyols4 = add_column(tidyols4,rhs="mpg weight")

tidyols_all <- bind_rows(tidyols1,tidyols2,tidyols3,tidyols4)

colnames(tidyols_all) <- gsub(".","_",colnames(tidyols_all), fixed=TRUE)

write_dta(tidyols_all,output)

## EOF