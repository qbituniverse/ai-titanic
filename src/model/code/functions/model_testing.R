#################################################################################
# Test Methods
#################################################################################
ModelTesting.Execute <- function(models, testCases, settings) {
    test_results <- data.frame()
    if (is.null(models)) { return(test_results) }

    SetResultValue <- function(expected, actual) {
        if (expected == actual) { return(Constants.Result.Pass) }
        else { return(Constants.Result.Fail) }
    }

    total_cases <- nrow(testCases)
    total_accuracy <- 0
    fail_no <- 0
    completed <- 0

    for (test in 1:total_cases) {
        test_case <- ModelTraining.ComposePredictionRequest(testCases[test, Constants.Columns.Sex],
                                                            testCases[test, Constants.Columns.Age],
                                                            testCases[test, Constants.Columns.Pclass],
                                                            testCases[test, Constants.Columns.Fare],
                                                            testCases[test, Constants.Columns.SibSp],
                                                            testCases[test, Constants.Columns.Parch])

        test_pred <- 0
        test_pred <- ModelTraining.Predict.Many(models = models, df = test_case, settings = settings)

        test_run <- ModelTraining.ComposePredictionResponse(test_pred)

        if (testCases[test, Constants.Columns.Survived] != test_run$survived$result) { fail_no = fail_no + 1 }
        total_accuracy <- DataQuality.WithTwoDecimal(100 - ((fail_no / test) * 100))
        completed <- DataQuality.AsPercentWithTwoDecimal(test / total_cases)

        test_result <- data.frame(Sex = as.character(testCases[test, Constants.Columns.Sex]),
                                  Age = testCases[test, Constants.Columns.Age],
                                  Pclass = testCases[test, Constants.Columns.Pclass],
                                  Fare = testCases[test, Constants.Columns.Fare],
                                  SibSp = testCases[test, Constants.Columns.SibSp],
                                  Parch = testCases[test, Constants.Columns.Parch],
                                  Survived = testCases[test, Constants.Columns.Survived],
                                  Predicted = test_run$survived$result,
                                  Confidence = test_run$survived$confidence,
                                  Result = SetResultValue(testCases[test, Constants.Columns.Survived], test_run$survived$result),
                                  Confidence_Perished = test_run$confidence$perished,
                                  Confidence_Survived = test_run$confidence$survived,
                                  Models = test_run$models,
                                  Failures = fail_no,
                                  TestNo = test,
                                  TotalTests = total_cases,
                                  Completed = completed,
                                  TestAccuracy = total_accuracy)

        test_results <- rbind(test_results, test_result)

        Environment.Log1(paste("Failures:", fail_no))
        Environment.Log1(paste("Current Test:", test))
        Environment.Log1(paste("Total Tests:", total_cases))
        Environment.Log1(paste("% Completed:", completed))
        Environment.Log1(paste("Run Accuracy => ", total_accuracy, "%"))
    }

    Environment.Log0()
    Environment.Log1(paste("Final Accuracy => ", total_accuracy, "%"))

    return(test_results)
}