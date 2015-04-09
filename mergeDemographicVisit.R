library(data.table)
library(dplyr)
library(tidyr)
library(synapseClient)
synapseLogin()

## Get demographic data
demoFile <- synGet("syn3536994")
demoData <- fread(getFileLocation(demoFile), data.table=FALSE)

## Get visit data

## Merge them on patient ID

## Store in Synapse


