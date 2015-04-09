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

## Merge them on patient ID
mergedData <- demoData %>% 
  left_join(visitData, by=c("Patient Number", "Sex", "Age at Baseline", "Treatment"))

## Store in Synapse


