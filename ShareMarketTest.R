# Below commands to install the software packages and load the package into existing program
install.packages("dplyr")
install.packages("downloader")
install.packages("stringr")
library("dplyr")
library("downloader")
library("stringr")

# Set working directory, the file will be download into this directory
setwd("D:/ShareMarketData")

filename <- "cm15DEC2017bhav.csv.zip"
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

# Generic filter trades
filterData <- filter(transformData,str_detect(SERIES, 'EQ'), OPEN < 1000 & OPEN > 10)
result <- filterData %>% mutate(high_low = CLOSE - PREVCLOSE, 
                                '%Increase' = ((CLOSE - PREVCLOSE)/PREVCLOSE)*100)
View(result)

filterData2 <- filter(result,high_low > 1)

# vIEW SOME SPECIFIC COLUMNS
specificColDataResult <- filterData2[,c(1,3,4,5,6,8,14,15)]
View(specificColDataResult)

# Filter the bank related stocks data for further analysis
filterData <- filter(transformData,str_detect(SERIES, 'EQ'), str_detect(SYMBOL, 'BANK'))
result <- filterData %>% mutate(high_low = HIGH - LOW, Gainers = CLOSE - OPEN)
View(result)
