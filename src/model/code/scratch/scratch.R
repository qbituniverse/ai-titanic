# startup
source("code/startup.R")

# exlore data
titanic.data.clean <- DataQuality.SetFullFactorLevels(Environment.Csv.LoadCleanData())
summary(titanic.data.clean)

# survival by gender
mosaicplot(titanic.data.clean$Sex ~ titanic.data.clean$Survived,
           main = "Gender by Survival",
           xlab = "Gender", ylab = "Survived",
           color = c("red", "lightgreen"))

# build model
settings$tuning$withEnsembles <- FALSE
settings$tuning$type = c(Constants.AlgorithmType.DecisionTree.C50,
                         Constants.AlgorithmType.BlackBox.ArtificialNeuralNetworks.Nnet)
models <- Process.Tuning(settings)

# select top models
length(models$all_models)
top <- models$top_models

# print stats
ModelPerformance.PrintStats.Models(top)

# test
test <- Process.Testing(models = top, settings = settings)

# publish
model_time_stamped <- paste(settings$project$name, "_model_", trimws(format(Sys.time(),"%Y%m%d_%H%M%S")), ".rds", sep = "")
Environment.Rds.SaveCustomModel(top, model_time_stamped)
Environment.Rds.SavePublishModel(top)

# call model from R
model_publish <- Environment.Rds.LoadPublishModel()
test_case <- ModelTraining.ComposePredictionRequest("male", 14, 3, 9.225, 0, 0)
test_case

prediction <- ModelTraining.Predict.Many(models = model_publish, df = test_case, settings = settings)
result <- ModelTraining.ComposePredictionResponse(prediction)
result

# call model from Postman
# ...