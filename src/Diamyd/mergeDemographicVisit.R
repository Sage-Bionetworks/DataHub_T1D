library(data.table)
library(dplyr)
library(tidyr)
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
write.csv(mergedData, file="Datahub_Diamyd_clinicalMerged.csv")

## Store in Synapse
