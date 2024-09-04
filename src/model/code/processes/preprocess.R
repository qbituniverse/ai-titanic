Process.Preprocess <- function(settings) {
    # inputs
    titanic.data.raw <- Environment.Csv.LoadRawData()
    summary(titanic.data.raw)
    str(titanic.data.raw)

    # check columns for NA and fix
    DataQuality.GetNaByColumn(titanic.data.raw)

    # remove not required columns
    titanic.data.raw <- titanic.data.raw[, c(-1, -4, -9, -11, -12)]
    str(titanic.data.raw)

    # set NA Age to average Age per Pclass
    DataQuality.CountNaValues(titanic.data.raw, 4)
    table(titanic.data.raw$Pclass)
    table(titanic.data.raw$Age, titanic.data.raw$Pclass)

    str(titanic.data.raw[-which(is.na(titanic.data.raw[, 4])),])
    age_data <- titanic.data.raw[-which(is.na(titanic.data.raw[, 4])),]

    age_class_1 <- DataQuality.WithTwoDecimal(aggregate(age_data[, 4], list(age_data$Pclass), mean)[1, 2])
    age_class_2 <- DataQuality.WithTwoDecimal(aggregate(age_data[, 4], list(age_data$Pclass), mean)[2, 2])
    age_class_3 <- DataQuality.WithTwoDecimal(aggregate(age_data[, 4], list(age_data$Pclass), mean)[3, 2])

    titanic.data.raw[titanic.data.raw$Pclass == "1",]$Age <- DataQuality.FixNaValues(titanic.data.raw[titanic.data.raw$Pclass == "1",], 4, age_class_1)$Age
    titanic.data.raw[titanic.data.raw$Pclass == "2",]$Age <- DataQuality.FixNaValues(titanic.data.raw[titanic.data.raw$Pclass == "2",], 4, age_class_2)$Age
    titanic.data.raw[titanic.data.raw$Pclass == "3",]$Age <- DataQuality.FixNaValues(titanic.data.raw[titanic.data.raw$Pclass == "3",], 4, age_class_3)$Age

    # rename Survived values from integers 0, 1 to no, yes
    titanic.data.raw[titanic.data.raw$Survived == 0,]$Survived <- Constants.Survived.No
    titanic.data.raw[titanic.data.raw$Survived == 1,]$Survived <- Constants.Survived.Yes

    # final check for NA again
    DataQuality.GetNaByColumn(titanic.data.raw)

    # reorder
    titanic.data.raw <- titanic.data.raw[, c(3, 4, 2, 7, 5, 6, 1)]
    str(titanic.data.raw)

    # convert to factors
    titanic.data.clean <- DataQuality.SetFullFactorLevels(titanic.data.raw)

    summary(titanic.data.clean)
    str(titanic.data.clean)

    # save clean data
    Environment.Csv.SaveCleanData(titanic.data.clean)

    # returns
    return(titanic.data.clean)
}