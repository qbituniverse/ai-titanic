#################################################################################
# Modifiers
#################################################################################
DataQuality.SetFullFactorLevels <- function(df) {
    df <- DataQuality.SetPredictionFactorLevels(df)
    df$Survived <- factor(df$Survived, levels = Constants.Vector.Survived)
    return(df)
}

DataQuality.SetPredictionFactorLevels <- function(df) {
    df$Sex <- factor(df$Sex, levels = Constants.Vector.Sex)
    df$Age <- as.numeric(df$Age)
    df$Pclass <- factor(df$Pclass, levels = Constants.Vector.Pclass)
    df$Fare <- as.numeric(df$Fare)
    df$SibSp <- as.integer(df$SibSp)
    df$Parch <- as.integer(df$Parch)
    return(df)
}

#################################################################################
# Value Checks
#################################################################################
DataQuality.GetNaPercentage <- function(df) { return(round(sum(is.na(df) == TRUE) / length(df) * 100, digits = 5)) }

DataQuality.GetNaByColumn <- function(df) {
    for (c in 1:length(df)) {
        Environment.Log1(paste("Column:", c, "=> NA Count:", DataQuality.CountNaValues(df, c)))
    }
}

DataQuality.HasNaValues <- function(df, col) { return(length(which(is.na(df[, col]))) > 0) }

DataQuality.CountNaValues <- function(df, col) { return(length(which(is.na(df[, col])))) }

DataQuality.HasOtherValues <- function(df, col, val) { return(length(which(df[, col] == val)) > 0) }

DataQuality.CountOtherValues <- function(df, col, val) { return(length(which(df[, col] == val))) }

#################################################################################
# Modifiers
#################################################################################
DataQuality.FixNaValues <- function(df, col, new) {
    if (DataQuality.HasNaValues(df, col)) { df[, col][which(is.na(df[, col]))] = new }
    return(df)
}

DataQuality.RemoveNaValues <- function(df, col) {
    if (DataQuality.HasNaValues(df, col)) { df <- df[-which(is.na(df[, col])),] }
    return(df)
}

DataQuality.FixOtherValues <- function(df, col, val, new) {
    if (DataQuality.HasOtherValues(df, col, val)) { df[, col][which(df[, col] == val)] = new }
    return(df)
}

DataQuality.RemoveOtherValues <- function(df, col, val) {
    if (DataQuality.HasOtherValues(df, col, val)) { df <- df[-which(df[, col] == val),] }
    return(df)
}

#################################################################################
# Data Presentation
#################################################################################
DataQuality.AsPercentWithTwoDecimal <- function(v) {
    if (is.null(v)) { return(0) }
    ifelse(is.na(v), return(0), return(round(v * 100, digits = 2)))
}

DataQuality.WithTwoDecimal <- function(v) {
    if (is.null(v)) { return(0) }
    ifelse(is.na(v), return(0), return(round(v, digits = 2)))
}

#####################v############################################################
# Data Checks
#################################################################################
DataQuality.HasColumn <- function(df, col) { return(col %in% colnames(df)) }
DataQuality.HasListItem <- function(l, i) { return(i %in% names(l)) }