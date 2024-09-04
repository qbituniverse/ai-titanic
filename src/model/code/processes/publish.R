#* Test ping message
#' @serializer unboxedJSON
#* @get /api/ping
function() {
    return("Ok")
}

#* Get current models stats
#* @get /api/stats
function() {
    return(ModelPerformance.GetStats.Models(model_publish))
}

#* Calculate Titanic survival prediction
#* @get /api/predict
function(sex, age, pclass, fare, sibsp, parch) {
    request <- ModelTraining.ComposePredictionRequest(sex, age, pclass, fare, sibsp, parch)
    response <- ModelTraining.Predict.Many(models = model_publish, df = request, settings = settings)
    return(ModelTraining.ComposePredictionResponse(response))
}

#* Error
#* @get /api/error
function(res) {
    msg <- "Your request did not include a required parameter."
    res$status <- 400
    return(list(error = jsonlite::unbox(msg)))
}
