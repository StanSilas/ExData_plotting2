# data downloaded from - https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip

library(dplyr)
library(ggplot2)

# reading data - RDS files have to be in current WD
DF_NEI = readRDS('./summarySCC_PM25.rds')
DF_SCC = readRDS('./Source_Classification_Code.rds')

# question 2 - total pm25 emission in Baltimore (fips == '24510'); make plot
DF_NEI_temp = filter(DF_NEI, fips == '24510')
myyears = unique(DF_NEI_temp$year)
DF_NEI_sums = data.frame()

for(i in myyears) {
    DF_NEI_temp2 = filter(DF_NEI_temp, year == i)
    DF_NEI_temp3 = round(sum(DF_NEI_temp2$Emissions), digits = 0)
    DF_NEI_sums = rbind(DF_NEI_sums, DF_NEI_temp3)
    colnames(DF_NEI_sums) = "emission_sum" 
} 

DF_NEI_sums = mutate(DF_NEI_sums, year = myyears)

plot(DF_NEI_sums$year, DF_NEI_sums$emission_sum, type = "l", 
     xlab = "Year", ylab = "Emission sum (pm25 tons)", col = "tomato3", lwd = 2,
     main = "Yearly total pm25 emission in Baltimore")

dev.copy(png, file = "./plot2.png") 
dev.off()


rm(list = ls())
closeAllConnections()