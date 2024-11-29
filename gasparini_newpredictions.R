#####################################################################################################################################################################################################################################################################################################################################################
#####################################################################################################################################################################################################################################################################################################################################################
## GENERATING NEW PREDICTIONS OF LANGUAGE OUTCOME
##
## Creators: Loretta Gasparini, Daisy Shepherd, Melissa Wake, Angela Morgan
## Corresponding author: Loretta Gasparini (gasparini.lorett@gmail.com)
## Affiliations: The Murdoch Children's Research Institute & The University of Melbourne
## Code originally developed in November 2024
## Last updated: November 2024
##
## Background: Three previous studies (Gasparini et al., 2023; 2024a; 2024b) developed a set of parent-reported predictors that can be asked when children are 2-3 years old that yielded >70% sensitivity and specificity for predicting 11-year language outcomes. A language outcome collected in late childhood allows identification of children with persisting language difficulties, a feature of Language Disorder, rather than children presenting with early language delays, which in many cases resolves without intervention.
## Purpose: This code allows you to generate predictions about whether 2-3-year-old children are likely to have persisting language difficulties, to aid with recruiting children into research studies
## Exclusions: The predictor set is expected to misclassify a large number of children, so is not suitable to screen for or diagnose language disorder
##
## Please cite as:      Gasparini, L., Shepherd, D. A., Wake, M., & Morgan, A. T. (2024). languagepredictions. https://github.com/lottiegasp/languagepredictions
## 
## Further background:  Gasparini, L., Shepherd, D. A., Lange, K., Wang, J., Verhoef, E., Bavin, E. L., Reilly, S., St. Pourcain, B., Wake, M., & Morgan, A. T. (2024). Combining genetic and behavioral predictors of 11-year language outcome: A multi-cohort study [Preregistration]. Open Science Framework. https://osf.io/mrxdg/ 
##                      Gasparini, L., Shepherd, D.A., Wang, J., Wake, M. & Morgan, A.T. (2024) Identifying early language predictors: A replication of Gasparini et al. (2023) confirming applicability in a general population cohort. International Journal of Language & Communication Disorders, 1–15. https://doi.org/10.1111/1460-6984.13086
##                      Gasparini, L., Shepherd, D. A., Bavin, E. L., Eadie, P., Reilly, S., Morgan, A. T., & Wake, M. (2023). Using machine-learning methods to identify early-life predictors of 11-year language outcome. Journal of Child Psychology & Psychiatry, 64(8), 1242-1252. https://doi.org/10.1111/jcpp.13733 

#####################################################################################################################################################################################################################################################################################################################################################
#####################################################################################################################################################################################################################################################################################################################################################

# Refer to the attached README file for instructions on how to collect the data to run below

# Run the following code the first time to install packages
# install.packages(c("SuperLearner","glmnet","party","xgboost","earth","tidyverse"))

# Load packages
## The following packages are needed to generate the predictions on your data
library(SuperLearner)
library(glmnet)
library(party)
library(xgboost)
library(earth)
## The following package is for modifying your dataset, running the mutate() function below
library(tidyverse)

# Set your working directory (change from "newpredictions" to whatever your folder path is)
setwd("~/newpredictions")

# Optional: simulate data, to practice running the below
newdata <- data.frame(matrix(ncol = 6, nrow = 500))
newdata$X1 = as.factor(1:500)
newdata$X2 = rbinom(n=500,size=1,prob=0.77)
newdata$X3 = rbinom(n=500,size=1,prob=0.87)
newdata$X4 = rbinom(n=500,size=1,prob=0.73)
newdata$X5 = rbinom(n=500,size=1,prob=0.92)
newdata$X6 = rbinom(n=500,size=1,prob=0.73)

# Otherwise, bring in your dataset (rename from "newdata" to your filename and change file type if needed)
## Note that you need complete data for all participants, the prediction model cannot generate predictions for participants with any missing values of the five predictors
# newdata <- readRDS("newdata.rds")

# Modify your dataset (real or simulated) so it's in the right format
## Rename columns
### If you brought in your own data, replace "X1","X2","X3","X4","X5","X6" below with your existing column names that correspond to child ID number and the 5 predictors
colnames(newdata)[colnames(newdata) == c("X1","X2","X3","X4","X5","X6")] <- c("child_id","dolly","circle","accident","kangaroo","forget")
## Rename variable levels
### If you brought in your own data, change below from "1" to the existing name of your variables that correspond with the new level names below
### E.g. if your variable levels are "Says" and "Not yet", change from "1" to "Says" - see the example 4 lines below and repeat this for all variables 
newdata$dolly<-as.factor(ifelse(newdata$dolly==1,"this dolly big and this dolly little","this dolly big"))
summary(newdata$dolly)
newdata$circle<-as.factor(ifelse(newdata$circle==1,"Yes","No"))
### Or, for example: newdata$circle<-as.factor(ifelse(newdata$circle=="Says","Yes","No"))
summary(newdata$circle)
newdata$accident<-as.factor(ifelse(newdata$accident==1,"Yes","No"))
summary(newdata$accident)
newdata$kangaroo<-as.factor(ifelse(newdata$kangaroo==1,"Yes","No"))
summary(newdata$kangaroo)
newdata$forget<-as.factor(ifelse(newdata$forget==1,"Yes","No"))
summary(newdata$forget)

## Check all your columns are in the right format
summary(newdata)

# Load in SuperLearner predictions generated from ELVS and LSAC data
sl_elvslsac_newpredictions <- readRDS("https://github.com/lottiegasp/languagepredictions/blob/main/sl_elvslsac_newpredictions.rds")
## If that doesn't work, download "sl_elvslsac_newpredictions.rds" from https://github.com/lottiegasp/languagepredictions/blob/main/sl_elvslsac_newpredictions.rds onto your machine and run the following line
# sl_elvslsac_newpredictions <- readRDS("sl_elvslsac_newpredictions.rds")

# Get dataset into the right format
## Reduce dataset to just the 5 predictors and child_id
newdata<-newdata[c("child_id","dolly","circle","accident","kangaroo","forget")]
## Turn child_id into the row name
rownames(newdata) <- newdata[,1]
## Remove missing data
newdata<-na.omit(newdata)
## Remove the child_id column
newdata <- newdata[,-1]

# Generate new predictions
predictions<-predict(object=sl_elvslsac_newpredictions, newdata)
# Add the new predictions to your dataset
newdata$predict<-predictions$pred

# Re-add child_id as a variable
newdata <- mutate(newdata, child_id = rownames(newdata))

# Optional: remove all predictor variables so you just have the child_id and predictions
newdata<-newdata[c("child_id","predict")]

# Select a cut-off depending on your goal
## The predictions are continuous numbers, where a higher number represents a greater expected likelihood of a child having persisting language disorder or difficulties (LD)
## To make a binary decision (e.g. lower/higher chance of LD; recruit/don't recruit into this trial), you need to select a cut-off for the predictions
## Deciding the appropriate cut-off is always a trade-off between misclassifying more children with higher chance of LD (false negatives) or misclassifying more children with lower chance of LD (false positives)
## The right cut-off depends on your research or recruitment goals
## The below shows different possible goals, and the corresponding prediction cut-off and predictive performance
## Refer to the RMarkdown PDF "elvslsac_prediction_results" for more details
## Contact the corresponding author if you would like a new cut-off calculated based on a different goal

# Goal:                                  Maximise sensitivity  >80% sensitivity      Balance sens/spec     >80% specificity      >90% specificity      >95% specificity      Maximise PPV

# Cut-off:                               0.015                 0.035                 0.0395                0.045                 0.11                  0.14                  0.2           

# Sensitivity                            0.88 (0.78, 0.94)     0.82 (0.71, 0.90)     0.74 (0.62, 0.84)     0.71 (0.59, 0.81)     0.48 (0.36, 0.60)     0.16 (0.09, 0.27)     0.11 (0.05, 0.20)
# Specificity                            0.54 (0.52, 0.57)     0.70 (0.68, 0.72)     0.78 (0.76, 0.79)     0.81 (0.79, 0.83)     0.91 (0.90, 0.93)     0.97 (0.96, 0.98)     0.98 (0.98, 0.99)
# Positive predictive value (PPV)        0.07 (0.05, 0.09)     0.10 (0.07, 0.12)     0.11 (0.09, 0.15)     0.13 (0.10, 0.16)     0.18 (0.13, 0.24)     0.19 (0.10, 0.30)     0.21 (0.10, 0.37)
# Negative predictive value (NPV)        0.99 (0.98, 1.00)     0.99 (0.98, 0.99)     0.99 (0.98, 0.99)     0.99 (0.98, 0.99)     0.98 (0.97, 0.98)     0.97 (0.96, 0.98)     0.97 (0.96, 0.97)
# Correctly classified proportion        0.55 (0.53, 0.58)     0.70 (0.68, 0.72)     0.77 (0.75, 0.79)     0.81 (0.79, 0.82)     0.90 (0.88, 0.91)     0.94 (0.93, 0.95)     0.95 (0.94, 0.96)

## Notes on interpretation: 
### We use the "Balance sens/spec" cut-off as an example
### *Sensitivity* of 0.74 means that for every 100 children with a language disorder who are tested, we expect 74 will correctly be identified as having higher chance of LD, and 26 will incorrectly be identified as having a lower chance of LD
### *Specificity* of 0.78 means that for every 100 children without a language disorder who are tested, we expect 78 will correctly be identified as having lower chance of LD, and 22 will incorrectly be identified as having a higher chance of LD
### *PPV* of 0.11 means that for every 100 children whom the tool identifies as having higher chance of LD, we expect 11 will truly have a language disorder, and 89 will truly not have a language disorder
### *NPV* of 0.99 means that for every 100 children whom the tool identifies as having lower chance of LD, we expect 99 will truly not have a language disorder, and 1 will truly have a language disorder
### *Correctly classified proportion* of 0.77 means that for every 100 children who are tested, 77 will be correctly classified, and 23 will be be incorrectly classified
### Note that the prevalance for language disorder is about 7-10%, so for every 1 child in the population with language disorder, about 9-13 do not have language disorder. This is why it is so difficult to yield a high PPV even when sensitivity and specificity are satisfactory, because in the general population, any random child is likelier to not have a language disorder than to have a language disorder

## Create a factor(s) dichotomising at the cut-off(s) that corresponds to your goal(s)
### This provides for each participant a binary prediction of whether they have a lower or higher chance of persisting language disorder or difficulties (LD) depending on the cut-off you select
### For example, if you are recruiting children into an early language intervention study, you would recruit children classified as "Higher chance of LD"
newdata$maxsens <- as.factor(ifelse(newdata$predict < 0.015, "Lower chance of LD", "Higher chance of LD"))
newdata$sens80 <- as.factor(ifelse(newdata$predict < 0.035, "Lower chance of LD", "Higher chance of LD"))
newdata$balancesensspec <- as.factor(ifelse(newdata$predict < 0.0395, "Lower chance of LD", "Higher chance of LD"))
newdata$spec80 <- as.factor(ifelse(newdata$predict < 0.045, "Lower chance of LD", "Higher chance of LD"))
newdata$spec90 <- as.factor(ifelse(newdata$predict < 0.11, "Lower chance of LD", "Higher chance of LD"))
newdata$spec95 <- as.factor(ifelse(newdata$predict < 0.14, "Lower chance of LD", "Higher chance of LD"))
newdata$maxppv <- as.factor(ifelse(newdata$predict < 0.2, "Lower chance of LD", "Higher chance of LD"))

# Look at how many children are classified as lower or higher chance of LD with each cut-off
summary(newdata$maxsens)
summary(newdata$sens80)
summary(newdata$balancesensspec)
summary(newdata$spec80)
summary(newdata$spec90)
summary(newdata$spec95)
summary(newdata$maxppv)

# Save your predictions as an .rds file
saveRDS(newdata, file="sl_newpredictions.rds")

# Refer to the attached README file for instructions on how to use the results

# Cite the following packages
citation("SuperLearner")
citation("glmnet")
citation("party")
citation("xgboost")
citation("earth")
citation("tidyverse")
# Record your R session information to aid reproducibility of your findings
sessionInfo()
