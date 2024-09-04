#################################################################################
# Tuning Methods
#################################################################################
ModelTuning.Execute <- function(settings) {
    Environment.Log2("Tune Model")

    results <- data.frame()
    current_model_id <- 0
    current_best_accuracy <- -1000
    current_worst_accuracy <- -1000

    prepared <- DataPreparation.PrepareData()

    model <- ModelTuning.Execute.Core(prepared, settings, current_best_accuracy, current_worst_accuracy, current_model_id)

    current_model_id <- model$model_id
    current_best_accuracy <- model$best_accuracy
    current_worst_accuracy <- model$worst_accuracy
    results <- rbind(results, model$results)

    return(results)
}

ModelTuning.Execute.Core <- function(df, settings, bestAccuracy, worstAccuracy, modelId) {
    model_results <- data.frame()
    result <- data.frame(DateTime = date(),
                         ModelType = settings$model$type,
                         ModelSettings = 0,
                         ModelId = 0,
                         BalancedAccuracy = 0,
                         TotalAccuracy = 0,
                         Sensitivity = 0,
                         Specificity = 0,
                         KappaUnweighted = 0,
                         F1 = 0)
    current_model_id <- modelId
    current_best_accuracy <- bestAccuracy
    current_worst_accuracy <- worstAccuracy

    LogModelStats <- function(model, result) {
        result$BalancedAccuracy <- model$stats$summary$balanced_accuracy
        result$TotalAccuracy <- model$stats$summary$accuracy
        result$Sensitivity <- model$stats$summary$sensitivity
        result$Specificity <- model$stats$summary$specificity
        result$KappaUnweighted <- model$stats$summary$kappa_unweighted
        result$F1 <- model$stats$summary$f1
        result$Model$model <- model
        return(result)
    }

    LogCurrentAccuracy <- function(modelAccuracy, currentBestAccuracy, currentWorstAccuracy) {
        if (modelAccuracy > currentBestAccuracy || currentBestAccuracy == -1000) { currentBestAccuracy <- modelAccuracy }
        if (modelAccuracy < currentWorstAccuracy || currentWorstAccuracy == -1000) { currentWorstAccuracy <- modelAccuracy }
        Environment.Log0()
        Environment.Log1(paste("Run Accuracy => ", modelAccuracy, "%"))
        Environment.Log1(paste("Best Accuracy => ", currentBestAccuracy, "%"))
        Environment.Log1(paste("Worst Accuracy => ", currentWorstAccuracy, "%"))
        return(list(best = currentBestAccuracy, worst = currentWorstAccuracy))
    }

    if (settings$model$type == Constants.AlgorithmType.ProbabilisticLearning.NaiveBayes && !settings$tuning$withEnsembles) {
        for (laplace in settings$tuning$models$naivebayes$laplace) {
            settings$model$naivebayes$laplace <- as.integer(laplace)
            current_model_id <- current_model_id + 1

            model <- ModelTraining.Execute(df$trainset, df$testset, settings)$model

            result <- LogModelStats(model, result)
            result$ModelSettings <- paste("laplace:", settings$model$naivebayes$laplace)
            result$ModelId <- current_model_id

            model_results <- rbind(model_results, result)

            accuracyLog <- LogCurrentAccuracy(result$BalancedAccuracy, current_best_accuracy, current_worst_accuracy)
            current_best_accuracy <- accuracyLog$best
            current_worst_accuracy <- accuracyLog$worst
        }
    } else if (settings$model$type == Constants.AlgorithmType.DecisionTree.C50 && !settings$tuning$withEnsembles) {
        for (trials in settings$tuning$models$c50$trials) {
            settings$model$c50$trials <- as.integer(trials)
            current_model_id <- current_model_id + 1

            model <- ModelTraining.Execute(df$trainset, df$testset, settings)$model

            result <- LogModelStats(model, result)
            result$ModelSettings <- paste("trials:", settings$model$c50$trials)
            result$ModelId <- current_model_id

            model_results <- rbind(model_results, result)

            accuracyLog <- LogCurrentAccuracy(result$BalancedAccuracy, current_best_accuracy, current_worst_accuracy)
            current_best_accuracy <- accuracyLog$best
            current_worst_accuracy <- accuracyLog$worst
        }
    } else if (settings$model$type == Constants.AlgorithmType.BlackBox.ArtificialNeuralNetworks.Nnet && !settings$tuning$withEnsembles) {
        for (size in settings$tuning$models$nnet$size) {
            for (maxit in settings$tuning$models$nnet$maxit) {
                settings$model$nnet$size <- as.integer(size)
                settings$model$nnet$maxit <- as.integer(maxit)
                current_model_id <- current_model_id + 1

                model <- ModelTraining.Execute(df$trainset, df$testset, settings)$model

                result <- LogModelStats(model, result)
                result$ModelSettings <- paste("size:", settings$model$nnet$size, "maxit:", settings$model$nnet$maxit)
                result$ModelId <- current_model_id

                model_results <- rbind(model_results, result)

                accuracyLog <- LogCurrentAccuracy(result$BalancedAccuracy, current_best_accuracy, current_worst_accuracy)
                current_best_accuracy <- accuracyLog$best
                current_worst_accuracy <- accuracyLog$worst
            }
        }
    } else if (settings$model$type == Constants.AlgorithmType.BlackBox.SupportVectorMachines.Ksvm && !settings$tuning$withEnsembles) {
        for (kernel in settings$tuning$models$ksvm$kernel) {
            settings$model$ksvm$kernel <- as.character(kernel)
            current_model_id <- current_model_id + 1

            model <- ModelTraining.Execute(df$trainset, df$testset, settings)$model

            result <- LogModelStats(model, result)
            result$ModelSettings <- paste("kernel:", settings$model$ksvm$kernel)
            result$ModelId <- current_model_id

            model_results <- rbind(model_results, result)

            accuracyLog <- LogCurrentAccuracy(result$BalancedAccuracy, current_best_accuracy, current_worst_accuracy)
            current_best_accuracy <- accuracyLog$best
            current_worst_accuracy <- accuracyLog$worst
        }
    } else if (settings$model$type == Constants.AlgorithmType.BlackBox.SupportVectorMachines.Svm && !settings$tuning$withEnsembles) {
        for (kernel in settings$tuning$models$svm$kernel) {
            settings$model$svm$kernel <- as.character(kernel)
            current_model_id <- current_model_id + 1

            model <- ModelTraining.Execute(df$trainset, df$testset, settings)$model

            result <- LogModelStats(model, result)
            result$ModelSettings <- paste("kernel:", settings$model$svm$kernel)
            result$ModelId <- current_model_id

            model_results <- rbind(model_results, result)

            accuracyLog <- LogCurrentAccuracy(result$BalancedAccuracy, current_best_accuracy, current_worst_accuracy)
            current_best_accuracy <- accuracyLog$best
            current_worst_accuracy <- accuracyLog$worst
        }
    } else {
        current_model_id <- current_model_id + 1

        model <- ModelTraining.Execute(df$trainset, df$testset, settings)$model

        result <- LogModelStats(model, result)
        result$ModelId <- current_model_id

        model_results <- rbind(model_results, result)

        accuracyLog <- LogCurrentAccuracy(result$BalancedAccuracy, current_best_accuracy, current_worst_accuracy)
        current_best_accuracy <- accuracyLog$best
        current_worst_accuracy <- accuracyLog$worst
    }

    return(list(results = model_results, best_accuracy = current_best_accuracy, worst_accuracy = current_worst_accuracy, model_id = current_model_id))
}

#################################################################################
# Model Selectors
#################################################################################
ModelTuning.SelectBestPerformers <- function(tuning_results, selector) {
    bm_stats <- data.frame()
    for (r in 1:nrow(tuning_results)) {
        bm_stats <- rbind(bm_stats, data.frame(
        model_id = tuning_results[r,]$ModelId,
        bm_sensitivity = tuning_results[r,]$Model$model$stats$summary$sensitivity,
        bm_specificity = tuning_results[r,]$Model$model$stats$summary$specificity,
        bm_balanced_accuracy = tuning_results[r,]$Model$model$stats$summary$balanced_accuracy,
        bm_f1 = tuning_results[r,]$Model$model$stats$summary$f1,
        bm_kappa_unweighted = tuning_results[r,]$Model$model$stats$summary$kappa_unweighted))
    }

    model_selector <- ModelTuning.ModelSelectorLogic(bm_stats, selector)

    ContainsModel <- function(m, id) { return(length(m[m$model_id == id,]) > 0) }
    AddModel <- function(m, id) { return(rbind(m, data.frame(model_id = id))) }

    best_performers <- data.frame()
    best_performers <- AddModel(best_performers, model_selector$best_sensitivity$model_id)

    if (!ContainsModel(best_performers, model_selector$best_specificity$model_id)) {
        best_performers <- AddModel(best_performers, model_selector$best_specificity$model_id)
    }
    
    models <- list()
    for (m in 1:nrow(best_performers)) {
        b_model <- tuning_results[tuning_results$ModelId == best_performers[m, 1],]$Model$model
        b_model$model_id <- best_performers[m, 1]
        models[[m]] <- b_model
    }

    return(models)
}

ModelTuning.SelectTopModels <- function(best_performers, selector) {
    bm_stats <- data.frame()
    for (m in 1:length(best_performers)) {
        bm_stats <- rbind(bm_stats, data.frame(
        performer_id = best_performers[[m]]$performer_id,
        model_id = best_performers[[m]]$model_id,
        bm_sensitivity = best_performers[[m]]$stats$summary$sensitivity,
        bm_specificity = best_performers[[m]]$stats$summary$specificity,
        bm_balanced_accuracy = best_performers[[m]]$stats$summary$balanced_accuracy,
        bm_f1 = best_performers[[m]]$stats$summary$f1,
        bm_kappa_unweighted = best_performers[[m]]$stats$summary$kappa_unweighted))
    }

    model_selector <- ModelTuning.ModelSelectorLogic(bm_stats, selector)

    ContainsModel <- function(m, pid) { return(length(m[m$performer_id == pid,]) > 0) }
    AddModel <- function(m, pid) { return(rbind(m, data.frame(performer_id = pid))) }

    top_models <- data.frame()
    top_models <- AddModel(top_models, model_selector$best_sensitivity$performer_id)

    if (!ContainsModel(top_models, model_selector$best_specificity$performer_id)) {
        top_models <- AddModel(top_models, model_selector$best_specificity$performer_id)
    }

    models <- list()
    counter <- 1
    for (tm in 1:nrow(top_models)) {
        for (bm in 1:length(best_performers)) {
            if (best_performers[[bm]]$performer_id == top_models[tm, 1]) {
                models[[counter]] <- best_performers[[bm]]
                counter <- counter + 1
            }
        }
    }

    return(models)
}

ModelTuning.SelectPairPerformers <- function(performers) {
    bm_df <- data.frame()
    for (m in 1:length(performers)) {
        bm_df <- rbind(bm_df, data.frame(
        performer_id = performers[[m]]$performer_id,
        bm_sensitivity = performers[[m]]$stats$summary$sensitivity,
        bm_specificity = performers[[m]]$stats$summary$specificity))
    }

    m_sensitivity <- bm_df[order(-bm_df$bm_sensitivity),]
    m_specificity <- bm_df[order(-bm_df$bm_specificity),]

    m_pairs <- data.frame()
    for (m_sens in 1:nrow(m_sensitivity)) {
        for (m_spec in 1:nrow(m_specificity)) {
            if (nrow(m_pairs[(m_pairs$sensitivity_performer_id == m_sensitivity[m_sens, ]$performer_id & m_pairs$specificity_performer_id == m_specificity[m_spec, ]$performer_id) |
                             (m_pairs$sensitivity_performer_id == m_specificity[m_spec, ]$performer_id & m_pairs$specificity_performer_id == m_sensitivity[m_sens, ]$performer_id), ]) == 0) {
                selected <- list()

                model_1 <- sapply(performers, function(m) m$performer_id == m_sensitivity[m_sens,]$performer_id)
                selected[[1]] <- performers[model_1][[1]]

                if (m_sensitivity[m_sens, ]$performer_id != m_specificity[m_spec, ]$performer_id) {
                    model_2 <- sapply(performers, function(m) m$performer_id == m_specificity[m_spec,]$performer_id)
                    selected[[2]] <- performers[model_2][[1]]
                }

                ModelPerformance.PrintStats.Models(selected)
                test <- Process.Testing(models = selected, settings = settings)

                m_pairs <- rbind(m_pairs, data.frame(sensitivity_performer_id = m_sensitivity[m_sens,]$performer_id, specificity_performer_id = m_specificity[m_spec,]$performer_id, result = test[test$Completed == 100,]$TestAccuracy))
            }
        }
    }

    best_pair <- m_pairs[order(-m_pairs$result),][1,]
    best_pair_model <- list()

    model_1 <- sapply(performers, function(m) m$performer_id == best_pair$sensitivity_performer_id)
    best_pair_model[[1]] <- performers[model_1][[1]]

    if (best_pair$sensitivity_performer_id != best_pair$specificity_performer_id) {
        model_2 <- sapply(performers, function(m) m$performer_id == best_pair$specificity_performer_id)
        best_pair_model[[2]] <- performers[model_2][[1]]
    }

    Environment.Csv.SaveModelTestingSummary(m_pairs)

    return (best_pair_model)
}

ModelTuning.ModelSelectorLogic <- function(bm_stats, selector) {
    best_sensitivity <- 0
    best_specificity <- 0

    # filter out on values > 0 only
    bm_stats_sensitivity <- bm_stats[bm_stats$bm_balanced_accuracy > 0 & bm_stats$bm_f1 > 0 & bm_stats$bm_kappa_unweighted > 0 & bm_stats$bm_sensitivity > 0,]
    bm_stats_specificity <- bm_stats[bm_stats$bm_balanced_accuracy > 0 & bm_stats$bm_f1 > 0 & bm_stats$bm_kappa_unweighted > 0 & bm_stats$bm_specificity > 0,]

    # apply logic
    if (selector == 1) {
        ## Sensitivity ##
        # order by best sensitivity then other ratios
        best_sensitivity <- bm_stats_sensitivity[order(-bm_stats_sensitivity$bm_sensitivity, -bm_stats_sensitivity$bm_balanced_accuracy, -bm_stats_sensitivity$bm_f1, -bm_stats_sensitivity$bm_kappa_unweighted),][1,]

        ## Specificity ##
        # order by best specificity then other ratios
        best_specificity <- bm_stats_specificity[order(-bm_stats_specificity$bm_specificity, -bm_stats_specificity$bm_balanced_accuracy, -bm_stats_specificity$bm_f1, -bm_stats_specificity$bm_kappa_unweighted),][1,]
    }

    if (selector == 2) {
        ratio <- 0.015

        ## Sensitivity ##
        # order by sensitivity
        best_sensitivity_order <- bm_stats_sensitivity[order(-bm_stats_sensitivity$bm_sensitivity, -bm_stats_sensitivity$bm_balanced_accuracy, -bm_stats_sensitivity$bm_f1, -bm_stats_sensitivity$bm_kappa_unweighted),][,]

        # get top sensitivity and calculate ratio for selection
        b_sens_up <- best_sensitivity_order[1,]$bm_sensitivity
        b_sens_ratio <- b_sens_up * ratio
        b_sens_down <- b_sens_up - b_sens_ratio

        # select top sensitivity by descending on specificity
        best_sensitivity_top <- best_sensitivity_order[best_sensitivity_order$bm_sensitivity > b_sens_down,]
        best_sensitivity <- best_sensitivity_top[order(best_sensitivity_top$bm_specificity, -best_sensitivity_top$bm_balanced_accuracy, -best_sensitivity_top$bm_f1, -best_sensitivity_top$bm_kappa_unweighted),][1,]

        ## Specificity ##
        # order by specificity
        best_specificity_order <- bm_stats_specificity[order(-bm_stats_specificity$bm_specificity, -bm_stats_specificity$bm_balanced_accuracy, -bm_stats_specificity$bm_f1, -bm_stats_specificity$bm_kappa_unweighted),][,]

        # get top specificity and calculate ratio for selection
        b_spec_up <- best_specificity_order[1,]$bm_specificity
        b_spec_ratio <- b_spec_up * ratio
        b_spec_down <- b_spec_up - b_spec_ratio

        # select top specificity by descending on sensitivity
        best_specificity_top <- best_specificity_order[best_specificity_order$bm_specificity > b_spec_down,]
        best_specificity <- best_specificity_top[order(best_specificity_top$bm_sensitivity, -best_specificity_top$bm_balanced_accuracy, -best_specificity_top$bm_f1, -best_specificity_top$bm_kappa_unweighted),][1,]
    }

    return(list(best_sensitivity = best_sensitivity, best_specificity = best_specificity))
}