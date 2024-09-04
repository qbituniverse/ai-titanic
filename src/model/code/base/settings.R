#################################################################################
# SETTABLE
#################################################################################
# core
settings <- list(project = 0,
                 seed = 7619453,
                 tuning = 0,
                 model = 0)

# project
settings$project <- list(name = "ai_titanic",
                         raw = "titanic_raw.csv",
                         clean = "titanic_clean.csv",
                         test = "titanic_test.csv",
                         temp = "titanic_temp.csv",
						 publish = "ai_titanic_model.rds")

# tuning
settings$tuning <- list(type = list(c(Constants.AlgorithmType.NA)),
                        withEnsembles = FALSE,
                        selector = 1,
                        models = 0,
                        ensembles = 0)

# tuning models
settings$tuning$models <- list(naivebayes = list(laplace = seq(from = 1, to = 30, by = 1)),
                               c50 = list(trials = seq(from = 1, to = 10, by = 1)),
                               nnet = list(size = seq(from = 10, to = 20, by = 1),
                                           maxit = c(50, 60)),
                                           #maxit = c(10, 50, 60, 70, 80, 90, 100, 200, 300, 400)),
                               ksvm = list(kernel = c("rbfdot", "polydot", "vanilladot", "laplacedot", "besseldot")),
                               svm = list(kernel = c("radial", "linear", "polynomial", "sigmoid")))

# tuning ensembles
settings$tuning$ensembles <- list(naivebayes = expand.grid(.fL = seq(from = 1, to = 30, by = 1),
                                                           .usekernel = c(TRUE, FALSE),
                                                           .adjust = c(TRUE, FALSE)),
                                  c50 = expand.grid(.model = c("tree", "rules"),
                                                    .trials = seq(from = 1, to = 30, by = 1),
                                                    .winnow = c(TRUE, FALSE)),
                                  nnet = expand.grid(.size = seq(from = 1, to = 30, by = 1),
                                                     .decay = c(1e-7, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1)),
                                  rpart = expand.grid(.cp = seq(from = 0, to = 10, by = 0.5)),
                                  ctree = expand.grid(.mincriterion = seq(from = 0, to = 10, by = 0.5)),
                                  svm = expand.grid(.C = seq(from = 1, to = 30, by = 1)),
                                  adaboost = expand.grid(.nIter = seq(from = 1, to = 30, by = 1),
                                                         .method = c("Adaboost.M1", "Real adaboost")),
                                  rf = expand.grid(.mtry = c(2, 4, 8, 16)))

#################################################################################
# DO NOT SET
#################################################################################
# model (keep for modelling - do not set)
settings$model <- list(type = Constants.AlgorithmType.NA,
                       naivebayes = list(laplace = 0),
                       c50 = list(trials = 0),
                       nnet = list(size = 0, maxit = 0),
                       ksvm = list(kernel = ""),
                       svm = list(kernel = ""))