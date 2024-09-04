Process.Testing <- function(models, settings) {
    # inputs
    titanic.data.test <- DataPreparation.PrepareData()$testset

    # run tests
    titanic.data.results <- ModelTesting.Execute(models = models,
                                                 testCases = titanic.data.test,
                                                 settings = settings)

    # record results
    Environment.Csv.SaveModelTestingResults(titanic.data.results)

    # returns
    return(titanic.data.results)
}