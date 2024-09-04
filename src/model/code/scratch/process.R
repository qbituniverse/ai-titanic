#################################################################################
# Startup
#################################################################################
source("code/startup.R")
processStarted <- date()
print.noquote(paste("### Process Started @", processStarted))

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
settings$tuning$type = c(Constants.AlgorithmType.DecisionTree.C50,
                         Constants.AlgorithmType.BlackBox.ArtificialNeuralNetworks.Nnet)

settings$tuning$type = c(Constants.AlgorithmType.ProbabilisticLearning.NaiveBayes,
                         Constants.AlgorithmType.DecisionTree.C50,
                         Constants.AlgorithmType.DecisionTree.RPART,
                         Constants.AlgorithmType.DecisionTree.CTREE,
                         Constants.AlgorithmType.RuleLearner.RIPPER,
                         Constants.AlgorithmType.BlackBox.ArtificialNeuralNetworks.Nnet,
                         Constants.AlgorithmType.BlackBox.SupportVectorMachines.Ksvm,
                         Constants.AlgorithmType.BlackBox.SupportVectorMachines.Svm)
settings$tuning$withEnsembles <- FALSE
models <- Process.Tuning(settings)

# top 2x models (from all algorithms)
selected <- models$top_models

# best performers (top 2x models for each algorithm)
selected <- models$best_performers

# best pair (from all best performers)
selected <- models$best_pair

# manual select (by ModelId & ModelType)
selected <- list()
model_1 <- sapply(models$all_models, function(m) m$ModelId == 2 & m$ModelType == 11)
selected[[1]] <- models$all_models[model_1][[1]]$Model$model
model_2 <- sapply(models$all_models, function(m) m$ModelId == 4 & m$ModelType == 4)
selected[[2]] <- models$all_models[model_2][[1]]$Model$model


## Ensemble Multi Model (caret = Accuracy)
settings$tuning$type = c(Constants.AlgorithmType.ProbabilisticLearning.NaiveBayes,
                         Constants.AlgorithmType.DecisionTree.C50,
                         Constants.AlgorithmType.DecisionTree.RPART,
                         Constants.AlgorithmType.DecisionTree.CTREE,
                         Constants.AlgorithmType.BlackBox.ArtificialNeuralNetworks.Nnet,
                         Constants.AlgorithmType.BlackBox.SupportVectorMachines.Svm)
settings$tuning$withEnsembles <- TRUE
ensembles <- Process.Tuning(settings)

# top 2x models (from all algorithms)
selected <- ensembles$top_models

# best performers (top 2x models for each algorithm)
selected <- ensembles$best_performers

# best pair (from all best performers)
selected <- ensembles$best_pair


## Ensemble Multi Model => GLM
ensemble_glm <- ModelTraining.Create.Ensemble.Glm(ensembles$top_models)
selected <- list(ensemble_glm)


## Ensemble Multi Model => GBM
enseblme_gbm <- ModelTraining.Create.Ensemble.Gbm(ensembles$top_models)
selected <- list(enseblme_gbm)


## Ensemble => Bagging
settings$tuning$type <- c(Constants.AlgorithmType.Ensembles.TreeBag)
settings$tuning$withEnsembles <- TRUE
ensembles_bagging <- Process.Tuning(settings)

# top 2x models (from all algorithms)
selected <- ensembles_bagging$top_models

# best pair (from all best performers)
selected <- ensembles_bagging$best_pair


## Ensemble => Boosting
settings$tuning$type <- c(Constants.AlgorithmType.Ensembles.AdaBoost)
settings$tuning$withEnsembles <- TRUE
ensembles_boosting <- Process.Tuning(settings)

# top 2x models (from all algorithms)
selected <- ensembles_boosting$top_models

# best pair (from all best performers)
selected <- ensembles_boosting$best_pair


## Ensemble => Random Forest
settings$tuning$type <- c(Constants.AlgorithmType.Ensembles.RandomForest)
settings$tuning$withEnsembles <- TRUE
ensembles_rf <- Process.Tuning(settings)

# top 2x models (from all algorithms)
selected <- ensembles_rf$top_models

# best pair (from all best performers)
selected <- ensembles_rf$best_pair

#################################################################################
# Clean-up
#################################################################################
#selected[[1]] <- NULL
#selected[[2]] <- NULL

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

#new_model <- Environment.Rds.LoadCustomModel(settings$project$name, "_model_svm_c50.rds")
#ModelPerformance.PrintStats.Models(new_model)
#Environment.Rds.SavePublishModel(new_model)

#################################################################################
### End ###
#################################################################################
print.noquote(paste("### Process Completed @", date(), "<= Started @", processStarted))