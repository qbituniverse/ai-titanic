#################################################################################
# Model Performance
#################################################################################
ModelPerformance.CalculateStats.Model <- function(model, df, settings) {
    Environment.Log2("Calculate Model Stats")

    CalculatePerformanceFull <- function(df, model, settings) {
        if (settings$model$type == Constants.AlgorithmType.DecisionTree.CTREE && !settings$tuning$withEnsembles) {
            return(data.frame(
                actual = df[, Constants.Columns.Survived],
                predicted = model$prediction,
                probability_perished = DataQuality.AsPercentWithTwoDecimal(sapply(model$probability, '[[', 1)),
                probability_survived = DataQuality.AsPercentWithTwoDecimal(sapply(model$probability, '[[', 2))))
        } else if (ncol(model$probability) == 1 && !settings$tuning$withEnsembles) {
            return(data.frame(
                actual = df[, Constants.Columns.Survived],
                predicted = model$prediction,
                probability_perished = DataQuality.AsPercentWithTwoDecimal(1 - model$probability[, 1]),
                probability_survived = DataQuality.AsPercentWithTwoDecimal(model$probability[, 1])))
        } else {
            return(data.frame(
                actual = df[, Constants.Columns.Survived],
                predicted = model$prediction,
                probability_perished = DataQuality.AsPercentWithTwoDecimal(model$probability[, 1]),
                probability_survived = DataQuality.AsPercentWithTwoDecimal(model$probability[, 2])))
        }
    }

    CalculatePreformanceTable <- function(cf) {
        cl <- cf$byClass
        metrics_df <- data.frame()

        metrics_l <- list(sensitivity = list(perished = 0, survived = 0, total = 0),
                          specificity = list(perished = 0, survived = 0, total = 0),
                          precision = list(perished = 0, survived = 0, total = 0),
                          recall = list(perished = 0, survived = 0, total = 0),
                          f1 = list(perished = 0, survived = 0, total = 0),
                          balanced_accuracy = list(perished = 0, survived = 0, total = 0))

        metrics_l$sensitivity = DataQuality.AsPercentWithTwoDecimal(cl[1])
        metrics_l$specificity = DataQuality.AsPercentWithTwoDecimal(cl[2])
        metrics_l$precision = DataQuality.AsPercentWithTwoDecimal(cl[5])
        metrics_l$recall = DataQuality.AsPercentWithTwoDecimal(cl[6])
        metrics_l$f1 = DataQuality.AsPercentWithTwoDecimal(cl[7])
        metrics_l$balanced_accuracy = DataQuality.AsPercentWithTwoDecimal(cl[11])

        metrics_df <- rbind(metrics_df, data.frame(sensitivity = metrics_l$sensitivity,
                                                   specificity = metrics_l$specificity,
                                                   precision = metrics_l$precision,
                                                   recall = metrics_l$recall,
                                                   f1 = metrics_l$f1,
                                                   balanced_accuracy = metrics_l$balanced_accuracy))

        return(list(as_df = metrics_df, as_list = metrics_l))
    }

    CalculateKappa <- function(t) { return(Kappa(t)) }

    CalculateModelAccuracy <- function(df, model, settings) {
        ModelAccuracy <- function(ct) {
            HasValue <- function(t, c) { return(c %in% colnames(t$prop.col) && c %in% rownames(t$prop.row)) }
            GetValue <- function(t, c) { return(as.integer(t$prop.col[c, c] * 100)) }
            AssignValue <- function(t, c) { if (HasValue(t, c)) { return(GetValue(t, c)) } else { return(0) }}

            perished <- AssignValue(ct, Constants.Survived.No)
            survived <- AssignValue(ct, Constants.Survived.Yes)
            total <- (perished + survived) / 2

            accuracy <- list(perished = perished,
                             survived = survived,
                             total = total)

            return(accuracy)
        }

        total <- 0

        u = union(model$prediction, df$Survived)
        t = table(factor(model$prediction, u), factor(df$Survived, u))
        cf <- confusionMatrix(t)

        ct <- CrossTable(x = factor(model$prediction, u),
                         y = factor(df$Survived, u),
                         dnn = c("Prediction", "Testset"),
                         chisq = FALSE,
                         prop.chisq = FALSE,
                         prop.r = FALSE,
                         prop.c = TRUE,
                         prop.t = FALSE)

        return(DataQuality.WithTwoDecimal(ModelAccuracy(ct)$total))
    }

    model_stats <- list()
    model_stats$performance_full <- CalculatePerformanceFull(df, model, settings)

    confusion_matrix <- confusionMatrix(model_stats$performance_full$predicted, model_stats$performance_full$actual)
    cross_table <- table(model_stats$performance_full$predicted, model_stats$performance_full$actual)
    kappa <- CalculateKappa(cross_table)
    performance_table <- CalculatePreformanceTable(confusion_matrix)
    accuracy <- CalculateModelAccuracy(df, model, settings)

    model_stats$performance_table <- performance_table
    model_stats$confusion_matrix <- confusion_matrix
    model_stats$cross_table <- cross_table
    summary <- data.frame(
        sensitivity = performance_table$as_list$sensitivity,
        specificity = performance_table$as_list$specificity,
        precision = performance_table$as_list$precision,
        recall = performance_table$as_list$recall,
        f1 = performance_table$as_list$f1,
        kappa_weighted = DataQuality.AsPercentWithTwoDecimal(kappa$Weighted[1]),
        kappa_unweighted = DataQuality.AsPercentWithTwoDecimal(kappa$Unweighted[1]),
        balanced_accuracy = performance_table$as_list$balanced_accuracy,
        accuracy = accuracy,
        error_rate = 100 - accuracy)
    rownames(summary) <- c(1:nrow(summary))
    model_stats$summary <- summary

    return(model_stats)
}

#################################################################################
# Model Selector
#################################################################################
ModelPerformance.PrintStats.Model <- function(model) {
    Environment.Log2("Model Stats")
    Environment.Log1(paste("Algorithm: ", model$type))
    if (DataQuality.HasListItem(model, "performer_id")) { Environment.Log1(paste("Performer Id: ", model$performer_id)) }
    if (DataQuality.HasListItem(model, "model_id")) { Environment.Log1(paste("Model Id: ", model$model_id)) }
    Environment.Log0()
    Environment.Log1(model$stats$summary)
    Environment.Log0()
    Environment.Log1(model$stats$cross_table)
    Environment.Log0()
    Environment.Log0()
    Environment.Log1("# # # # # # # # # # # #")
    Environment.Log0()
}

ModelPerformance.PrintStats.Models <- function(models) {
    for (m in 1:length(models)) { ModelPerformance.PrintStats.Model(models[[m]]) }
}

ModelPerformance.GetStats.Model <- function(model) {
    return(list(type = model$type, summary = model$stats$summary))
}

ModelPerformance.GetStats.Models <- function(models) {
    c <- 1
    stats <- list()
    for (m in 1:length(models)) {
        stat <- ModelPerformance.GetStats.Model(models[[m]])
        stats[[c]] <- stat
        c <- c + 1
    }
    return(stats)
}

#################################################################################
# Model Analysis
#################################################################################
ModelPerformance.VariableAnalysis.Model <- function(model) {
    if (model$type != Constants.AlgorithmType.DecisionTree.C50 &&
        model$type != Constants.AlgorithmType.DecisionTree.RPART &&
        model$type != Constants.AlgorithmType.RuleLearner.RIPPER) { return(0) }

    Environment.Log2("Variable Analysis")
    Environment.Log1(paste("Algorithm: ", model$type))
    if (DataQuality.HasListItem(model, "performer_id")) { Environment.Log1(paste("Performer Id: ", model$performer_id)) }
    if (DataQuality.HasListItem(model, "model_id")) { Environment.Log1(paste("Model Id: ", model$model_id)) }
    Environment.Log0()
    importance = varImp(model$model, scale = FALSE)
    Environment.Log1(importance)
    Environment.Log0()
    Environment.Log1("# # # # # # # # # # # #")
    Environment.Log0()
}

ModelPerformance.VariableAnalysis.Models <- function(models) {
    for (m in 1:length(models)) { ModelPerformance.VariableAnalysis.Model(models[[m]]) }
}