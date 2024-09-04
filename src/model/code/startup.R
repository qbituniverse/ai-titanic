#################################################################################
# Clear Environment
#################################################################################
gc()
rm(list = ls())
sessionInfo()

processStarted <- date()
print.noquote(paste("### Base Load Started @", processStarted))

#################################################################################
# Load Sources
#################################################################################
lib_path <- "/usr/local/lib/R/site-library"

print.noquote("")
print.noquote(paste("Working Directory path:", getwd()))

print.noquote("")
.libPaths(lib_path)
print.noquote(paste("Current Libraries path:", lib_path))
print.noquote(.libPaths())

source("code/base/constants.R")
source("code/base/settings.R")
source("code/base/environment.R")

source("code/functions/data_preparation.R")
source("code/functions/data_quality.R")
source("code/functions/model_performance.R")
source("code/functions/model_testing.R")
source("code/functions/model_training.R")
source("code/functions/model_tuning.R")

source("code/processes/preprocess.R")
source("code/processes/analysis.R")
source("code/processes/tuning.R")
source("code/processes/testing.R")
source("code/processes/publish.R")

#################################################################################
# Register Packages
#################################################################################
require(gmodels, lib.loc = lib_path)
require(e1071, lib.loc = lib_path)
require(caret, lib.loc = lib_path)
require(caretEnsemble, lib.loc = lib_path)
require(vcd, lib.loc = lib_path)
require(FSelector, lib.loc = lib_path)
require(C50, lib.loc = lib_path)
require(rpart, lib.loc = lib_path)
require(party, lib.loc = lib_path)
require(RWeka, lib.loc = lib_path)
require(nnet, lib.loc = lib_path)
require(kernlab, lib.loc = lib_path)
require(naivebayes, lib.loc = lib_path)
# "fastAdaboost" appears to be archived: https://cran.r-project.org/web/packages/fastAdaboost/index.html
require(fastAdaboost, lib.loc = lib_path)

#################################################################################
# Settings
#################################################################################
if (settings$seed > 0) { set.seed(settings$seed) }

print.noquote(paste("### Base Load Completed @", date(), "<= Started @", processStarted))