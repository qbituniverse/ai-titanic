#################################################################################
# Logging
#################################################################################
Environment.Log0 <- function() { print.noquote("") }

Environment.Log1 <- function(value) { print.noquote(value) }

Environment.Log2 <- function(value) {
    print.noquote("")
    print.noquote(paste("## ", value, " ##"))
    print.noquote("")
}

Environment.Log3 <- function(value) {
    print.noquote("")
    print.noquote(paste("### ", value, " ###"))
    print.noquote("")
}

#################################################################################
# Data Input
#################################################################################
Environment.Csv.LoadRawData <- function() {
    return(read.csv(paste("input/", settings$project$raw, sep = ""), na.strings = c("NA", "", "NULL")))
}

Environment.Csv.LoadCleanData <- function() {
    return(read.csv(paste("input/", settings$project$clean, sep = ""), na.strings = c("NA", "", "NULL")))
}

Environment.Csv.LoadTestData <- function() {
    return(read.csv(paste("input/", settings$project$test, sep = ""), na.strings = c("NA", "", "NULL")))
}

Environment.Rds.LoadPublishModel <- function() {
  readRDS(paste("models/", settings$project$publish, sep = ""))
}

Environment.Rds.LoadCustomModel <- function(name) {
  readRDS(paste("models/" , name, sep = ""))
}

#################################################################################
# Data Output
#################################################################################
Environment.Csv.SaveCleanData <- function(data) {
    write.csv(data, file = paste("output/", settings$project$clean, sep = ""), row.names = FALSE)
}

Environment.Csv.SaveModelTuningResults <- function(df) {
    write.csv(df, file = paste("output/model_tuning_results_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".csv", sep = ""), row.names = FALSE)
}

Environment.Csv.SaveModelTestingResults <- function(df) {
    write.csv(df, file = paste("output/model_testing_results_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".csv", sep = ""), row.names = FALSE)
}

Environment.Csv.SaveModelTestingSummary <- function(df) {
    write.csv(df, file = paste("output/model_testing_summary_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".csv", sep = ""), row.names = FALSE)
}

Environment.Rds.SavePublishModel <- function(obj) {
  saveRDS(obj, paste("models/", settings$project$publish, sep = ""), compress = TRUE)
}

Environment.Rds.SaveCustomModel <- function(obj, name) {
  saveRDS(obj, paste("models/", name, sep = ""), compress = TRUE)
}

#################################################################################
# Helpers
#################################################################################
Environment.PrintAlgorithmType <- function(algorithmType) {
    if (algorithmType == Constants.AlgorithmType.NA) { Environment.Log1("Algorithm Type: NA") }

    if (algorithmType == Constants.AlgorithmType.LazyLearning.NearestNeighbours) {
        Environment.Log1("Algorithm Type: Lazy Learner: 1-Nearest Neighbour: knn1()")
    }
    if (algorithmType == Constants.AlgorithmType.ProbabilisticLearning.NaiveBayes) {
        Environment.Log1("Algorithm Type: Probabilistic Learner: Naive Bayes: naiveBayes()")
    }
    if (algorithmType == Constants.AlgorithmType.ProbabilisticLearning.LogisticRegression) {
        Environment.Log1("Algorithm Type: Probabilistic Learner: Generalized Linear Model: glm()")
    }
    if (algorithmType == Constants.AlgorithmType.DecisionTree.C50) {
        Environment.Log1("Algorithm Type: Decision Tree: Decision Trees and Rule-Based: C5.0()")
    }
    if (algorithmType == Constants.AlgorithmType.DecisionTree.RPART) {
        Environment.Log1("Algorithm Type: Decision Tree: Recursive Partitioning and Regression Trees: rpart()")
    }
    if (algorithmType == Constants.AlgorithmType.DecisionTree.CTREE) {
        Environment.Log1("Algorithm Type: Decision Tree: Conditional Inference Trees: ctree()")
    }
    if (algorithmType == Constants.AlgorithmType.RuleLearner.1R) {
        Environment.Log1("Algorithm Type: Rule Learner: 1R: OneR()")
    }
    if (algorithmType == Constants.AlgorithmType.RuleLearner.RIPPER) {
        Environment.Log1("Algorithm Type: Rule Learner: Repeated Incremental Pruning to Produce Error Reduction: JRip()")
    }
    if (algorithmType == Constants.AlgorithmType.BlackBox.ArtificialNeuralNetworks.Neuralnet) {
        Environment.Log1("Algorithm Type: Black Box: Artificial Neural Networks: neuralnet()")
    }
    if (algorithmType == Constants.AlgorithmType.BlackBox.ArtificialNeuralNetworks.Nnet) {
        Environment.Log1("Algorithm Type: Black Box: Artificial Neural Networks: nnet()")
    }
    if (algorithmType == Constants.AlgorithmType.BlackBox.SupportVectorMachines.Ksvm) {
        Environment.Log1("Algorithm Type: Black Box: Support Vector Machines: ksvm()")
    }
    if (algorithmType == Constants.AlgorithmType.BlackBox.SupportVectorMachines.Svm) {
        Environment.Log1("Algorithm Type: Black Box: Support Vector Machines: svm()")
    }
    if (algorithmType == Constants.AlgorithmType.Ensembles.Glm) {
        Environment.Log1("Algorithm Type: Ensembles: Glm()")
    }
    if (algorithmType == Constants.AlgorithmType.Ensembles.Gbm) {
        Environment.Log1("Algorithm Type: Ensembles: Gbm()")
    }
    if (algorithmType == Constants.AlgorithmType.Ensembles.TreeBag) {
        Environment.Log1("Algorithm Type: Ensembles: Baggings: treebag()")
    }
    if (algorithmType == Constants.AlgorithmType.Ensembles.AdaBoost) {
        Environment.Log1("Algorithm Type: Ensembles: Boosting: adaboost()")
    }
    if (algorithmType == Constants.AlgorithmType.Ensembles.RandomForest) {
        Environment.Log1("Algorithm Type: Ensembles: Random Forest: rf()")
    }
}