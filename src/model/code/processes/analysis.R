Process.Analysis <- function(settings) {
    # inputs
    titanic.data.clean <- DataQuality.SetFullFactorLevels(Environment.Csv.LoadCleanData())
    str(titanic.data.clean)

    # survavial rate
    titanic.survived <- table(titanic.data.clean$Survived)
    titanic.survivedPct <- round(prop.table(titanic.survived) * 100, digits = 2)
    Environment.Log1(titanic.survivedPct)

    # survival by gender
    mosaicplot(titanic.data.clean$Sex ~ titanic.data.clean$Survived,
               main = "Gender by Survival",
               xlab = "Gender", ylab = "Survived",
               color = c("red", "lightgreen"))

    # survival by class
    Environment.Log2("Class by Survival")
    CrossTable(x = titanic.data.clean[, Constants.Columns.Survived],
               y = titanic.data.clean[, Constants.Columns.Pclass],
               dnn = c("Survived", "Class"),
               chisq = FALSE,
               prop.chisq = FALSE,
               prop.r = FALSE,
               prop.c = TRUE,
               prop.t = FALSE)

    # survival by fare
    mosaicplot(titanic.data.clean$Fare ~ titanic.data.clean$Survived,
               main = "Fare by Survival",
               xlab = "Fare", ylab = "Survived",
               color = c("red", "lightgreen"))

    # survival by age
    mosaicplot(titanic.data.clean$Age ~ titanic.data.clean$Survived,
               main = "Age by Survival",
               xlab = "Age", ylab = "Survived",
               color = c("red", "lightgreen"))

    # survival by no of siblings/spouses (# of siblings / spouses aboard the Titanic)
    mosaicplot(titanic.data.clean$SibSp ~ titanic.data.clean$Survived,
               main = "No of Siblings/Spouses by Survival",
               xlab = "No of Siblings/Spouses", ylab = "Survived",
               color = c("red", "lightgreen"))

    # survival by no of parents/children (# of parents / children aboard the Titanic)
    mosaicplot(titanic.data.clean$Parch ~ titanic.data.clean$Survived,
               main = "No of Parents/Children by Survival",
               xlab = "No of Parents/Children", ylab = "Survived",
               color = c("red", "lightgreen"))

    # variable importance
    features <- random.forest.importance(Survived ~ ., titanic.data.clean, importance.type = 1)
    Environment.Log1(features)
    Environment.Log1(cutoff.k(features, 6))

    # returns
    return(0)
}