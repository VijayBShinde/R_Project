# Code for intraday prediction
library("dplyr")
library("downloader")
library("stringr")

# Set working directory, the file will be download into this directory
setwd("D:/ShareMarketData")

# File name variable
filename <- "cm15DEC2017bhav.csv.zip"
selectedStockList <- c("KTKBANK","BANKBARODA","YESBANK","BANKINDIA","CANBK",
                       "NTPC","COALINDIA","HINDALCO","ITC","RECLTD","ANDHRABANK",
                       "BHEL","DISHTV","FEDERALBNK","GRANULES","ICIL","IDEA","IGL",
                       "INDIACEM","JISLJALEQS","MCLEODRUSS","NCC","NMDC","ORIENTBANK","PFC","PNB","POWERGRID","PTC")

# NSE site URL to download the data
url <- paste0("http://www.nseindia.com/content/historical/EQUITIES/2017/DEC/",filename)

# Below code will check if file already exist in a directory.
# If file not exist it will download the file from NSEIndia.com, then it will unzip the file.
if(!file.exists(filename)) download(url, filename)
unzip(zipfile = filename)

# Read downloaded file
filename2 <- str_replace(filename, ".zip","")
sampleData <- read.csv(filename2)
#Remove the 'X' column from data
transformData <- select(sampleData, -X)
# Below function will show you the column available in NSE dataset
colnames(transformData)
# Filter the bank related stocks data for further analysis
filterData <- filter(transformData,str_detect(SERIES, 'EQ'), str_detect(SYMBOL, paste(selectedStockList,collapse = '|')))
#result <- filterData %>% mutate(high_low = HIGH - LOW, Gainers = CLOSE - OPEN)
result <- filterData %>% 
                mutate(Pivot = (HIGH + LOW + CLOSE)/3, 
                       Pivot2Y = Pivot*2, 
                       R1 = Pivot2Y-LOW, 
                       R2 = Pivot + (HIGH - LOW), 
                       S1 = Pivot2Y - HIGH, 
                       S2 = Pivot - (HIGH - LOW))

View(result)

# vIEW SOME SPECIFIC COLUMNS
specificColDataResult <- result[,c("SYMBOL", "R1", "R2", "S1", "S2", "OPEN","HIGH","LOW","CLOSE","LAST","PREVCLOSE")]
View(specificColDataResult)

