#################################################################################
# Startup
#################################################################################
source("code/startup.R")
modelStarted <- date()
print.noquote(paste("### Model Started @", modelStarted))

#################################################################################
# Preprocess
#################################################################################
preprocess <- Process.Preprocess(settings)

#################################################################################
# Analysis
#################################################################################
analysis <- Process.Analysis(settings)

#################################################################################
# Tuning
#################################################################################

## Manual Multi Model (DIY = Sensitivity & Specificity)
settings$tuning$type = c(Constants.AlgorithmType.DecisionTree.C50)
settings$tuning$withEnsembles <- FALSE

models <- Process.Tuning(settings)

# top 2x models (from all algorithms)
selected <- models$top_models

# best performers (top 2x models for each algorithm)
selected <- models$best_performers

# best pair (from all best performers)
selected <- models$best_pair

#################################################################################
# Test
#################################################################################
ModelPerformance.PrintStats.Models(selected)
ModelPerformance.VariableAnalysis.Models(selected)
test <- Process.Testing(models = selected, settings = settings)

#################################################################################
# Publish
#################################################################################
model_time_stamped <- paste(settings$project$name, "_model_", trimws(format(Sys.time(),"%Y%m%d_%H%M%S")), ".rds", sep = "")
ModelPerformance.PrintStats.Models(selected)
Environment.Rds.SaveCustomModel(selected, model_time_stamped)
Environment.Rds.SavePublishModel(selected)

#################################################################################
### End ###
#################################################################################
print.noquote(paste("### Model Completed @", date(), "<= Started @", modelStarted))