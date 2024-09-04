#################################################################################
# Prepare Data
#################################################################################
DataPreparation.PrepareData <- function() {
    Environment.Log2("Prepare Data")

    trainset <- DataQuality.SetFullFactorLevels(Environment.Csv.LoadCleanData())
    testset <- DataQuality.SetFullFactorLevels(Environment.Csv.LoadTestData())

    return(list(trainset = trainset,
                testset = testset))
}