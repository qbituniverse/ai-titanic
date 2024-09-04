#################################################################################
# Create Model
#################################################################################
ModelTraining.Execute <- function(trainset, testset, settings) {
    # create model
    titanic.data.model <- ModelTraining.Create(df = trainset, settings = settings)

    # create predictions
    predict <- ModelTraining.Predict.Single(model = titanic.data.model$model,
                                            df = testset,
                                            settings = settings)

    titanic.data.model$prediction <- predict$prediction
    titanic.data.model$probability <- predict$probability

    # calculate model stats
    titanic.data.model$stats <- ModelPerformance.CalculateStats.Model(model = titanic.data.model,
                                                                      df = testset,
                                                                      settings = settings)

    # print out model stats
    ModelPerformance.PrintStats.Model(titanic.data.model)

    # returns
    return(list(type = settings$model$type, model = titanic.data.model))
}

ModelTraining.Create <- function(df, settings) {
    if (settings$tuning$withEnsembles) {
        return(ModelTraining.Create.Ensemble(df = df, settings = settings))
    } else {
        return(ModelTraining.Create.Model(df = df, settings = settings))
    }
}

# model
ModelTraining.Create.Model <- function(df, settings) {
    Environment.Log2("Create Model")
    Environment.PrintAlgorithmType(settings$model$type)

    if (settings$seed > 0) { set.seed(settings$seed) }
    data.model <- data.frame()

    if (settings$model$type == Constants.AlgorithmType.ProbabilisticLearning.NaiveBayes) {
        Environment.Log1(paste("laplace:", settings$model$naivebayes$laplace))
    
        data.model <- naiveBayes(df[-Constants.Columns.Survived],
                                 df[, Constants.Columns.Survived],
                                 laplace = settings$model$naivebayes$laplace)
    }

    if (settings$model$type == Constants.AlgorithmType.DecisionTree.C50) {
        Environment.Log1(paste("trials:", settings$model$c50$trials))

        data.model <- C5.0(df[-Constants.Columns.Survived],
                           df[, Constants.Columns.Survived],
                           trials = settings$model$c50$trials)
    }

    if (settings$model$type == Constants.AlgorithmType.DecisionTree.RPART) {
        data.model <- rpart(Survived ~ Sex + Age + Pclass + Fare + SibSp + Parch,
                            data = df)
    }

    if (settings$model$type == Constants.AlgorithmType.DecisionTree.CTREE) {
        data.model <- ctree(Survived ~ Sex + Age + Pclass + Fare + SibSp + Parch,
                            data = df)
    }

    if (settings$model$type == Constants.AlgorithmType.RuleLearner.RIPPER) {
        data.model <- JRip(Survived ~ Sex + Age + Pclass + Fare + SibSp + Parch,
                           data = df)
    }

    if (settings$model$type == Constants.AlgorithmType.BlackBox.ArtificialNeuralNetworks.Nnet) {
        Environment.Log1(paste("size:", settings$model$nnet$size))
        Environment.Log1(paste("maxit:", settings$model$nnet$maxit))

        data.model <- nnet(Survived ~ Sex + Age + Pclass + Fare + SibSp + Parch,
                           data = df,
                           size = settings$model$nnet$size,
                           maxit = settings$model$nnet$maxit)
    }

    if (settings$model$type == Constants.AlgorithmType.BlackBox.SupportVectorMachines.Ksvm) {
        Environment.Log1(paste("kernel:", settings$model$ksvm$kernel))

        data.model <- ksvm(Survived ~ Sex + Age + Pclass + Fare + SibSp + Parch,
                           data = df,
                           kernel = settings$model$ksvm$kernel,
                           prob.model = TRUE)
    }

    if (settings$model$type == Constants.AlgorithmType.BlackBox.SupportVectorMachines.Svm) {
        Environment.Log1(paste("kernel:", settings$model$svm$kernel))

        data.model <- svm(Survived ~ Sex + Age + Pclass + Fare + SibSp + Parch,
                          data = df,
                          kernel = settings$model$svm$kernel,
                          probability = TRUE)
    }

    return(list(type = settings$model$type, model = data.model))
}

# ensemble
ModelTraining.Create.Ensemble <- function(df, settings) {
    Environment.Log2("Create Ensemble")
    Environment.PrintAlgorithmType(settings$model$type)

    if (settings$seed > 0) { set.seed(settings$seed) }
    data.model <- data.frame()
    method <- ""
    tuneGrid <- NULL

    if (settings$model$type == Constants.AlgorithmType.ProbabilisticLearning.NaiveBayes) {
        method <- "naive_bayes"
        tuneGrid <- settings$tuning$ensembles$naivebayes
    }

    if (settings$model$type == Constants.AlgorithmType.DecisionTree.C50) {
        method <- "C5.0"
        tuneGrid <- settings$tuning$ensembles$c50
    }

    if (settings$model$type == Constants.AlgorithmType.DecisionTree.RPART) {
        method <- "rpart"
        tuneGrid <- settings$tuning$ensembles$rpart
    }

    if (settings$model$type == Constants.AlgorithmType.DecisionTree.CTREE) {
        method <- "ctree"
        tuneGrid <- settings$tuning$ensembles$ctree
    }

    if (settings$model$type == Constants.AlgorithmType.BlackBox.ArtificialNeuralNetworks.Nnet) {
        method <- "nnet"
        tuneGrid <- settings$tuning$ensembles$nnet
    }

    if (settings$model$type == Constants.AlgorithmType.BlackBox.SupportVectorMachines.Svm) {
        method <- "svmLinear"
        tuneGrid <- settings$tuning$ensembles$svm
    }

    if (settings$model$type == Constants.AlgorithmType.Ensembles.TreeBag) {
        method <- "treebag"
    }

    if (settings$model$type == Constants.AlgorithmType.Ensembles.AdaBoost) {
        method <- "adaboost"
        tuneGrid <- settings$tuning$ensembles$adaboost
    }

    if (settings$model$type == Constants.AlgorithmType.Ensembles.RandomForest) {
        method <- "rf"
        tuneGrid <- settings$tuning$ensembles$rf
    }

    data.model <- train(Survived ~ Sex + Age + Pclass + Fare + SibSp + Parch,
                        data = df,
                        metric = "Accuracy",
                        method = method,
                        trControl = trainControl(savePredictions = TRUE, classProbs = TRUE),
                        tuneGrid = tuneGrid)

    return(list(type = settings$model$type, model = data.model))
}

# ensemble bundling
ModelTraining.Create.Ensemble.Glm <- function(models) {
    Environment.Log2("Create Ensemble Glm")

    models_glm <- caretStack(ModelTraining.Create.Ensemble.List(models), method = "glm")
    models_glm$type <- Constants.AlgorithmType.Ensembles.Glm

    return(list(type = Constants.AlgorithmType.Ensembles.Glm, model = models_glm))
}

ModelTraining.Create.Ensemble.Gbm <- function(models) {
    Environment.Log2("Create Ensemble Gbm")

    models_gbm <- caretStack(ModelTraining.Create.Ensemble.List(models), method = "gbm")
    models_gbm$type <- Constants.AlgorithmType.Ensembles.Gbm

    return(list(type = Constants.AlgorithmType.Ensembles.Gbm, model = models_gbm))
}

ModelTraining.Create.Ensemble.List <- function(models) {
    Environment.Log2("Create Ensemble List")

    models_l <- list()
    for (m in 1:length(models)) { models_l[[m]] <- models[[m]]$model }
    class(models_l) <- "caretList"

    return(models_l)
}

#################################################################################
# Prediction
#################################################################################
ModelTraining.Predict.Single <- function(model, df, settings) {
    if (settings$tuning$withEnsembles) {
        return(ModelTraining.Predict.Ensemble(model = model, df = df, settings = settings))
    } else {
        return(ModelTraining.Predict.Model(model = model, df = df, settings = settings))
    }
}

ModelTraining.Predict.Many <- function(models, df, settings) {
    if (settings$tuning$withEnsembles) {
        return(ModelTraining.Predict.Ensembles(models = models, df = df, settings = settings))
    } else {
        return(ModelTraining.Predict.Models(models = models, df = df, settings = settings))
    }
}

# model
ModelTraining.Predict.Model <- function(model, df, settings) {
    Environment.Log2("Predict Model")
    Environment.PrintAlgorithmType(settings$model$type)

    if (settings$seed > 0) { set.seed(settings$seed) }
    data.prediction <- data.frame()
    data.probability <- data.frame()

    if (settings$model$type == Constants.AlgorithmType.ProbabilisticLearning.NaiveBayes) {
        data.prediction <- predict(model, df, type = "class")
        data.probability <- predict(model, df, type = "raw")
    }

    if (settings$model$type == Constants.AlgorithmType.DecisionTree.C50) {
        data.prediction <- predict(model, df, type = "class")
        data.probability <- predict(model, df, type = "prob")
    }

    if (settings$model$type == Constants.AlgorithmType.DecisionTree.RPART) {
        data.prediction <- predict(model, df, type = "class")
        data.probability <- predict(model, df, type = "prob")
    }

    if (settings$model$type == Constants.AlgorithmType.DecisionTree.CTREE) {
        data.prediction <- predict(model, df, type = "response")
        data.probability <- predict(model, df, type = "prob")
    }

    if (settings$model$type == Constants.AlgorithmType.RuleLearner.RIPPER) {
        data.prediction <- predict(model, df, type = "class")
        data.probability <- predict(model, df, type = "prob")
    }

    if (settings$model$type == Constants.AlgorithmType.BlackBox.ArtificialNeuralNetworks.Nnet) {
        data.prediction <- predict(model, df, type = "class")
        data.probability <- predict(model, df, type = "raw")
    }

    if (settings$model$type == Constants.AlgorithmType.BlackBox.SupportVectorMachines.Ksvm) {
        data.prediction <- predict(model, df, type = "response")
        data.probability <- predict(model, df, type = "prob")
    }

    if (settings$model$type == Constants.AlgorithmType.BlackBox.SupportVectorMachines.Svm) {
        data.prediction <- predict(model, df, type = "class")
        prob <- predict(model, df, probability = TRUE)
        data.probability <- attr(prob, "probabilities")
    }

    return(list(prediction = factor(data.prediction, levels = Constants.Vector.Survived),
                probability = data.probability))
}

ModelTraining.Predict.Models <- function(models, df, settings) {
    Environment.Log2("Predict Models")

    if (settings$seed > 0) { set.seed(settings$seed) }

    results <- lapply(models, function(m) {
        result <- data.frame()
        settings$model$type <- m$type

        predict <- ModelTraining.Predict.Model(model = m$model, df = df, settings = settings)

        p_s <- p_p <- 0
        if (settings$model$type == Constants.AlgorithmType.DecisionTree.CTREE) {
            p_p <- sapply(predict$probability, '[[', 1)
            p_s <- sapply(predict$probability, '[[', 2)
        } else if (settings$model$type == Constants.AlgorithmType.BlackBox.ArtificialNeuralNetworks.Nnet) {
            p_p <- 1 - predict$probability
            p_s <- predict$probability
        } else {
            p_p <- predict$probability[1]
            p_s <- predict$probability[2]
        }

        probability <- list(final = 0, survived = 0, perished = 0)
        if (predict$prediction == Constants.Survived.No) { probability$final <- DataQuality.AsPercentWithTwoDecimal(p_p) }
        if (predict$prediction == Constants.Survived.Yes) { probability$final <- DataQuality.AsPercentWithTwoDecimal(p_s) }
        probability$survived <- DataQuality.AsPercentWithTwoDecimal(p_s)
        probability$perished <- DataQuality.AsPercentWithTwoDecimal(p_p)

        result <- rbind(result, data.frame(
                        type = m$type,
                        prediction = predict$prediction,
                        probability = probability,
                        sensitivity = m$stats$summary$sensitivity,
                        specificity = m$stats$summary$specificity,
                        f1 = m$stats$summary$f1,
                        kappa = m$stats$summary$kappa_unweighted))

        return(result)
    })

    results_df <- do.call(rbind, results)
    best_result <- results_df[order(-results_df$probability.final),][1,]

    if (nrow(results_df) > 1) {
        df_0 <- results_df[results_df$prediction == Constants.Survived.No,]
        df_1 <- results_df[results_df$prediction == Constants.Survived.Yes,]
        if (nrow(df_0) > 0 && nrow(df_1) > 0) {
            p_0 <- df_0[order(-df_0$sensitivity, -df_0$probability.final),][1,]
            p_1 <- df_1[order(-df_1$specificity, -df_1$probability.final),][1,]

            s_0 <- (p_0$sensitivity + p_0$probability.final) / 2
            s_1 <- (p_1$specificity + p_1$probability.final) / 2

            if (s_0 > s_1) { best_result <- p_0 }
            if (s_1 > s_0) { best_result <- p_1 }
            if (s_0 == s_1) { best_result <- results_df[order(-results_df$f1),][1,] }
        }
    }
    
    return(list(prediction = factor(best_result$prediction, levels = Constants.Vector.Survived),
                probability = list(final = best_result$probability.final,
                                   survived = best_result$probability.survived,
                                   perished = best_result$probability.perished),
                models = results_df))
}

# ensemble
ModelTraining.Predict.Ensemble <- function(model, df, settings) {
    Environment.Log2("Predict Ensemble")
    Environment.PrintAlgorithmType(settings$model$type)

    if (settings$seed > 0) { set.seed(settings$seed) }
    data.prediction <- predict(model, df, type = "raw")
    data.probability <- predict(model, df, type = "prob")

    return(list(prediction = factor(data.prediction, levels = Constants.Vector.Survived),
                probability = data.probability))
}

ModelTraining.Predict.Ensembles <- function(models, df, settings) {
    Environment.Log2("Predict Ensembles")

    if (settings$seed > 0) { set.seed(settings$seed) }

    results <- lapply(models, function(m) {
        result <- data.frame()
        settings$model$type <- m$type

        predict <- ModelTraining.Predict.Ensemble(model = m$model, df = df, settings = settings)

        p_s <- p_p <- 0
        if (settings$model$type == Constants.AlgorithmType.Ensembles.Glm ||
            settings$model$type == Constants.AlgorithmType.Ensembles.Gbm) {
            p_p <- 1 - predict$probability
            p_s <- predict$probability
        } else {
            p_p <- predict$probability[1][1,]
            p_s <- predict$probability[2][1,]
        }

        probability <- list(final = 0, survived = 0, perished = 0)
        if (predict$prediction == Constants.Survived.No) { probability$final <- DataQuality.AsPercentWithTwoDecimal(p_p) }
        if (predict$prediction == Constants.Survived.Yes) { probability$final <- DataQuality.AsPercentWithTwoDecimal(p_s) }
        probability$survived <- DataQuality.AsPercentWithTwoDecimal(p_s)
        probability$perished <- DataQuality.AsPercentWithTwoDecimal(p_p)

        if (settings$model$type == Constants.AlgorithmType.Ensembles.Glm ||
            settings$model$type == Constants.AlgorithmType.Ensembles.Gbm) {
            result <- rbind(result, data.frame(
                            type = m$type,
                            prediction = predict$prediction,
                            probability = probability,
                            sensitivity = 0,
                            specificity = 0,
                            f1 = 0,
                            kappa = 0))
        } else {
            result <- rbind(result, data.frame(
                            type = m$type,
                            prediction = predict$prediction,
                            probability = probability,
                            sensitivity = m$stats$summary$sensitivity,
                            specificity = m$stats$summary$specificity,
                            f1 = m$stats$summary$f1,
                            kappa = m$stats$summary$kappa_unweighted))
        }

        return(result)
    })

    results_df <- do.call(rbind, results)
    best_result <- results_df[order(-results_df$probability.final),][1,]

    if (nrow(results_df) > 1) {
        df_0 <- results_df[results_df$prediction == Constants.Survived.No,]
        df_1 <- results_df[results_df$prediction == Constants.Survived.Yes,]
        if (nrow(df_0) > 0 && nrow(df_1) > 0) {
            p_0 <- df_0[order(-df_0$sensitivity, - df_0$probability.final),][1,]
            p_1 <- df_1[order(-df_1$specificity, - df_1$probability.final),][1,]

            s_0 <- (p_0$sensitivity + p_0$probability.final) / 2
            s_1 <- (p_1$specificity + p_1$probability.final) / 2

            if (s_0 > s_1) { best_result <- p_0 }
            if (s_1 > s_0) { best_result <- p_1 }
            if (s_0 == s_1) { best_result <- results_df[order(-results_df$f1),][1,] }
            }
    }

    return(list(prediction = factor(best_result$prediction, levels = Constants.Vector.Survived),
                probability = list(final = best_result$probability.final,
                                   survived = best_result$probability.survived,
                                   perished = best_result$probability.perished),
                models = results_df))
}

#################################################################################
# Requests
#################################################################################
ModelTraining.ComposePredictionRequest <- function(sex, age, pclass, fare, sibsp, parch) {
    modelInputs <- data.frame(
        Sex = as.factor(trimws(sex)),
        Age = as.numeric(trimws(age)),
        Pclass = as.factor(trimws(pclass)),
        Fare = as.numeric(trimws(fare)),
        SibSp = as.integer(trimws(sibsp)),
        Parch = as.integer(trimws(parch)))
    return(DataQuality.SetPredictionFactorLevels(modelInputs))
}

ModelTraining.ComposePredictionResponse <- function(prediction) {
    confidence <- list()
    confidence$survived <- prediction$probability$survived
    confidence$perished <- prediction$probability$perished
    
    survived <- list()
    survived$result <- prediction$prediction
    survived$confidence <- prediction$probability$final

    models <- list()
    for (m in 1:nrow(prediction$models)) {
        models[[m]] <- prediction$models[m,]
    }

    return(list(survived = survived, confidence = confidence, models = models))
}