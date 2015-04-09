library(data.table)
library(dplyr)
library(rGithubClient)
library(synapseClient)
synapseLogin()

## Get demographic data
demoFile <- synGet("syn3536994")
demoData <- fread(getFileLocation(demoFile), data.table=FALSE)

## Get visit data
visitFile <- synGet("syn3536997")
visitData <- fread(getFileLocation(visitFile), data.table=FALSE)

## Merge on identical columns
mergedData <- demoData %>% 
  left_join(visitData, by=c("Patient Number", "Sex", "Age at Baseline", "Treatment"))

## Write to a file
write.csv(mergedData, file="DataHub_Diamyd_clinicalMerged.csv")

## Get the current remote commit of this file
repo <- getRepo("Sage-Bionetworks/DataHub_T1D")
script  <- getPermlink(repo, repositoryPath="src/Diamyd/mergeDemographicVisit.R")

mergedFile <- File("DataHub_Diamyd_clinicalMerged.csv", parentId="syn3375423")
synSetAnnotations(mergedFile) <- list(contributor="Diamyd", phase="III", trial="GAD65",
                                      treatmentGroup= "placebo", dataLevel="patient")
act <- Activity(name="Merge", description="Merge demographic and visit data",
                used=c(demoFile, visitFile), executed=script)
generatedBy(mergedFile) <- act
mergedFile <- synStore(mergedFile)
