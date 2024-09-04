# R Model Code Overview

## Project Structure

Location: **src/model**

|Folder|Description|
|-----|-----|
|**code**|The core R code that is used to explore, wrangle, convert data, and train, tune and test AI models.|
|**input**|Input data files, raw, clean, test or validation sets.<br />Files are in CSV format and are not modified in any way, i.e. loaded directly in project as provided from Kaggle.<br />Clean data file needs to be copied into this folder when ready for model build.|
|**models**|Trained AI models stored in RDS format.<br />These are automatically saved into this folder once the model build process is completed.|
|**output**|Output data files stored in CSV format.<br />Clean Data: This file needs to be copied into *input* folder if the intention is to use it for AI model training.<br />Tuning Results: model tuning results.<br />Testing Results: model testing results.<br />Testing Summary: model testing summary.|

## Code Overview

### Root

Location: **src/model/code**

|File|Description|
|-----|-----|
|**startup.R**|Project startup file, run it every time you start the ai-titanic API or Model build.<br />It links all R files, pre-loads functions and libraries.|

### Configuration

Location: **src/model/code/base**

|File|Description|
|-----|-----|
|**constants.R**|Static constant variables, such as integer, string, boolean.<br />Primitive data type.<br />Naming convention: *Constants.CONSTANT_NAME*.|
|**environment.R**|Core methods to provide environment wide functionality such as saving/loading files or logging.<br />Naming convention: *Environment.FUNCTION_NAME()*.|
|**settings.R**|Project settings, such as data input files names, models, model parameters.<br />List data type.<br />Naming convention: *settings$SETTING_NAME*.|

### Functions

Location: **src/model/code/functions**

|File|Description|
|-----|-----|
|**data_preparation.R**|Functions for preparing data for training and testing.<br />Takes CVS data and produces DataFrames.<br />Naming convention: *DataPreparation.FUNCTION_NAME()*.|
|**data_quality.R**|Functions for cleaning and wrangling data.<br />Takes DataFrames and produces clean versions of these.<br />Naming convention: *DataQuality.FUNCTION_NAME()*.|
|**model_performance.R**|Functions for measuring AI model performance.<br />Takes a trained Model object and settings for model parameters.<br />Naming convention: *ModelPerformance.FUNCTION_NAME()*.|
|**model_testing.R**|Functions for testing trained models.<br />Takes a trained Model object, test cases in DataFrame and settings for model parameters.<br />Naming convention: *ModelTesting.FUNCTION_NAME()*.|
|**model_training.R**|Functions for training new models and making predictions.<br />Takes DataFrame with train data and settings for model parameters.<br />Naming convention: *ModelTraining.FUNCTION_NAME()*.|
|**model_tuning.R**|Functions for tuning new models while training, simply runs iterations per model to create best/worst performers.<br />Takes train data sets in DataFrame format and trained Model object.<br />Naming convention: *ModelTuning.FUNCTION_NAME()*.|

### Processes

Location: **src/model/code/processes**

|File|Description|
|-----|-----|
|**analysis.R**|Performs analysis on the data inputs.<br />Generates graphics, plots and tabular outputs on the screen.<br />Naming convention: *Process.Analysis()*.|
|**preprocess.R**|Performs data cleaning and wrangling operations.<br />Generates clean data set in CSV format into the *output* folder.<br />Naming convention: *Process.Preprocess()*.|
|**publish.R**|Publishes trained RDS model as an API endpoint.<br />Takes trained model from the *models* folder.| 
|**testing.R**|Tests trained model against test data set.<br />Takes trained model and test data and produces test report in CSV format in the *output* folder.<br />Naming convention: *Process.Testing()*.|
|**tuning.R**|Performs model training and tuning.<br />Runs iterations of model settings, trains model per iteration, runs statistic checks and generates report in CSV format in the *output* folder.<br />Naming convention: *Process.Tuning()*.|

### Build

Location: **src/model/code/build**

|File|Description|
|-----|-----|
|**api.R**|Builds R API. Loads *startup.R*, loads model from *models* folder and runs process from *publish.R* process to expose the AI model via API endpoint.|
|**model.R**|Builds R Model. Loads *startup.R*, runs selection of processes from *preprocess.R*, *analysis.R*, *tuning.R* and *testing.R* to build the AI model.|

### Scratch

Location: **src/model/code/scratch**

Use this for development and experimentation only - no production use.