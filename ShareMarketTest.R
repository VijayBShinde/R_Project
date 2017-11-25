# Below commands to install the software packages and load the package into existing program
install.packages("dplyr")
install.packages("downloader")
install.packages("stringr")
library("dplyr")
library("downloader")
library("stringr")

# Set working directory, the file will be download into this directory
setwd("D:/ShareMarketData")

# NSE site URL to download the data
url <- "http://www.nseindia.com/content/historical/EQUITIES/2017/NOV/cm24NOV2017bhav.csv.zip"

# File name variable
filename <- "cm24NOV2017bhav.csv.zip"

# Below code will check if file already exist in a directory.
# If file not exist it will download the file from NSEIndia.com, then it will unzip the file.
if(!file.exists(filename)) download(url, filename)
unzip(zipfile = filename)

# Read downloaded file
sampleData <- read.csv("cm24NOV2017bhav.csv")

#Remove the 'X' column from data
transformData <- select(sampleData, -X)

# Below function will show you the column available in NSE dataset
colnames(transformData)

# Generic filter trades
filterData <- filter(transformData,str_detect(SERIES, 'EQ'))
result <- filterData %>% mutate(high_low = HIGH - LOW, Gainers = CLOSE - OPEN)
View(result)

# vIEW SOME SPECIFIC COLUMNS
specificColData <- result[,c(1,3,4,5,14,15)]
View(specificColData)

# Filter the bank related stocks data for further analysis

filterData <- filter(transformData,str_detect(SERIES, 'EQ'), str_detect(SYMBOL, 'BANK'))
result <- filterData %>% mutate(high_low = HIGH - LOW, Gainers = CLOSE - OPEN)
View(result)

# Below function will show the data first 5 rows of data
head(filterData)

