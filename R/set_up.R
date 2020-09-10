rm(list = ls())

library(jsonlite)
library(readr)
library(dplyr)
library(Biostrings)
library(stringi)

.properties <- read_json("properties.json")