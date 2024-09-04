#################################################################################
# Data columns & values
#################################################################################
Constants.Columns.Sex <- 1
Constants.Columns.Age <- 2
Constants.Columns.Pclass <- 3
Constants.Columns.Fare <- 4
Constants.Columns.SibSp <- 5
Constants.Columns.Parch <- 6
Constants.Columns.Survived <- 7

Constants.Sex.Female <- "female"
Constants.Sex.Male <- "male"

Constants.Pclass.1 <- "1"
Constants.Pclass.2 <- "2"
Constants.Pclass.3 <- "3"

Constants.Survived.No <- "no"
Constants.Survived.Yes <- "yes"

Constants.Result.Pass <- "PASS"
Constants.Result.Fail <- "FAIL"

#################################################################################
# Values
#################################################################################
Constants.Vector.Sex <- c(Constants.Sex.Female, Constants.Sex.Male)
Constants.Vector.Pclass <- c(Constants.Pclass.1, Constants.Pclass.2, Constants.Pclass.3)
Constants.Vector.Survived <- c(Constants.Survived.No, Constants.Survived.Yes)

#################################################################################
# Algorithms
#################################################################################
Constants.AlgorithmType.NA <- 0
Constants.AlgorithmType.LazyLearning.NearestNeighbours <- 1
Constants.AlgorithmType.ProbabilisticLearning.NaiveBayes <- 2
Constants.AlgorithmType.ProbabilisticLearning.LogisticRegression <- 3
Constants.AlgorithmType.DecisionTree.C50 <- 4
Constants.AlgorithmType.DecisionTree.RPART <- 5
Constants.AlgorithmType.DecisionTree.CTREE <- 6
Constants.AlgorithmType.RuleLearner.1R <- 7
Constants.AlgorithmType.RuleLearner.RIPPER <- 8
Constants.AlgorithmType.BlackBox.ArtificialNeuralNetworks.Neuralnet <- 9
Constants.AlgorithmType.BlackBox.ArtificialNeuralNetworks.Nnet <- 10
Constants.AlgorithmType.BlackBox.SupportVectorMachines.Ksvm <- 11
Constants.AlgorithmType.BlackBox.SupportVectorMachines.Svm <- 12
Constants.AlgorithmType.Ensembles.Glm <- 13
Constants.AlgorithmType.Ensembles.Gbm <- 14
Constants.AlgorithmType.Ensembles.TreeBag <- 15
Constants.AlgorithmType.Ensembles.AdaBoost <- 16
Constants.AlgorithmType.Ensembles.RandomForest <- 17