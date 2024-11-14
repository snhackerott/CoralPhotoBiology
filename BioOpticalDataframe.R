#### Script to Organize Bio-Optical Phenotype Data ####
## Author: Serena Hackerott, November 2024

## Converts Processed LIT Phenotype data (Protocol 2) into single dataframes. 
## Raw data files are originally saved from the LIT SD card. 
## Processed data files are created in and downloaded from the Coral Bio-Optical Shiny App.
## Proceseed data files are saved in a single folder that only contains those files to be analyzed in R. 


#### Load Required Packages ####
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("stringr")) install.packages("stringr")

library(tidyverse) #Required for data organization 
library(stringr) #Required for subsetting by matching strings


#### Upload and Organize Data ####

##Set WD to overall Project Folder
setwd("ProjectWD") #Replace this with the actual path

##Upload Meta Data file
CoralMeta<-read.csv("ProjectWD/CoralMeta.csv", header=TRUE)

##Temporarily set WD to folder containing Phenotype Data
setwd("ProjectWD/BioOpticalPhenotypeDataFolder") #Replace this with the actual path

##Read in each file
temp = list.files(pattern="\\.CSV$")

temp.df <- lapply(temp, read.csv)

##Add LIT_ID from end of File name
for (i in 1:length(temp.df)) temp.df[[i]]$LIT_ID<-rep(sub('.*\\.', '', names(temp.df[[i]])[7]), nrow(temp.df[[i]]))

##Rename value column
for (i in 1:length(temp.df)) names(temp.df[[i]])[7]<-"value"

##Bind into single dataframe
df <- do.call("rbind", temp.df)

##Remove X column
df<-df[,-1]

##Pivot to wide format
df.wide<-df %>% pivot_wider(id_cols=LIT_ID, names_from=uni, values_from=value)

##Re-Set WD to overall Project Folder
setwd("ProjectWD") #Replace this with the actual path


#### Merge with Meta Data and Save ####

##Long Format
Phenotype<-merge(df, CoralMeta)

##Wide Format
Phenotype.w<-merge(df.wide, CoralMeta)

##Save Organized Bio-Optical Data
write.csv(Phenotype, "Phenotype.csv", row.names=FALSE)
write.csv(Phenotype.w, "Phenotype.wide.csv", row.names=FALSE)

