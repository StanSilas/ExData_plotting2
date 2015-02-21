# data downloaded from - https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip

library(dplyr)
library(ggplot2)

# reading data - RDS files have to be in current WD
DF_NEI = readRDS('./summarySCC_PM25.rds')
DF_SCC = readRDS('./Source_Classification_Code.rds')

# question 1 - filter and calculate yearly pm25 emission sums; make plot
myyears = c('1999', '2002', '2005', '2008')
DF_NEI_sums = data.frame()

for(i in myyears) {
    DF_NEI_temp = filter(DF_NEI, year == i)
    DF_NEI_temp2 = round(sum(DF_NEI_temp$Emissions), digits = 0)
    DF_NEI_sums = rbind(DF_NEI_sums, DF_NEI_temp2)
    colnames(DF_NEI_sums) = "emission_sum"
} 

DF_NEI_sums = mutate(DF_NEI_sums, year = myyears)

plot(DF_NEI_sums$year, DF_NEI_sums$emission_sum, type = "l", 
     xlab = "Year", ylab = "Emission sum (pm25 tons)", col = "royalblue", lwd = 2,
     main = "Yearly total pm25 emission in US")

dev.copy(png, file = "./plot1.png") 
dev.off()


rm(list = ls())
closeAllConnections()
