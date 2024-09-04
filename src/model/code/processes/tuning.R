Process.Tuning <- function(settings) {
    # inputs
    titanic.results <- data.frame()
    titanic.top.models <- list()
    titanic.best.performers <- list()
    titanic.best.pair <- list()
    titanic.all.models <- list()
    all_counter <- 1
    p_counter <- 1

    # start tuning
    for (model_type in settings$tuning$type) {
        settings$model$type <- model_type

        # tune model
        tuning <- ModelTuning.Execute(settings)

        # add to results
        titanic.results <- rbind(titanic.results, tuning[-length(tuning)])

        # add to all models
        for (r in 1:nrow(tuning)) {
            titanic.all.models[[all_counter]] <- tuning[r,]
            all_counter <- all_counter + 1
        }

        # get best performers
        best_performers <- ModelTuning.SelectBestPerformers(tuning, settings$tuning$selector)

        # save performers
        for (m in 1:length(best_performers)) {
            best_performers[[m]]$performer_id <- p_counter
            titanic.best.performers[[p_counter]] <- best_performers[[m]]
            p_counter <- p_counter + 1
        }
    }

    # select top model
    titanic.top.models <- ModelTuning.SelectTopModels(titanic.best.performers, settings$tuning$selector)

    # print out top models
    ModelPerformance.PrintStats.Models(titanic.top.models)

    # save results
    Environment.Csv.SaveModelTuningResults(titanic.results)

    # select best pair
    titanic.best.pair <- ModelTuning.SelectPairPerformers(titanic.best.performers)

    # print out best pair
    ModelPerformance.PrintStats.Models(titanic.best.pair)

    # returns
    return(list(all_models = titanic.all.models,
                best_performers = titanic.best.performers,
                top_models = titanic.top.models,
                best_pair = titanic.best.pair))
}