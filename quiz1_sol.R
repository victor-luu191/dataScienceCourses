library("xlsx")
library("XML")
library("data.table")

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", 
              destfile = "house_idaho.csv", method = "curl")

read.csv("house_idaho.csv") -> house.idaho.ds
names(house.idaho.ds)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf", 
              destfile = "codebook_hid.pdf", method = "curl")
str(house.idaho.ds$VAL)
sum(!is.na(house.idaho.ds$VAL) & (house.idaho.ds$VAL == 24) )

str(house.idaho.ds$FES)
house.idaho.ds$FES

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx", 
              destfile = "NGAP.xlsx", method = "curl")

read.xlsx(file = "NGAP.xlsx", startRow = 18, endRow = 23, colIndex = 7:15, sheetIndex = 1) -> dat
sum(dat$Zip*dat$Ext,na.rm=T)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml", 
              destfile = "restaurants.xml", method = "curl")

xmlTreeParse(file = "restaurants.xml", useInternalNodes = T) -> doc
root <- xmlRoot(doc)
xmlSApply(root, xmlName) -> tags
tags
xpathSApply(root, "//zipcode", xmlValue) -> zipcodes
sum(zipcodes == "21231")

fread(input = "house_idaho.csv", sep = ",") -> DT
DT[ , mean(pwgtp15), by=SEX]
mean(DT$pwgtp15, by=SEX)
