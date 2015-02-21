# data downloaded from - https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip

library(dplyr)
library(ggplot2)

# reading data - RDS files have to be in current WD
DF_NEI = readRDS('./summarySCC_PM25.rds')
DF_SCC = readRDS('./Source_Classification_Code.rds')

# question 5 - emissions from motor vehicles sources - Baltimore; make plot
DF_SCC_mv = as.character(unique(DF_SCC[grep("[Vv]ehicles", DF_SCC$EI.Sector),])$SCC)
DF_NEI_mv = DF_NEI[DF_NEI$SCC %in% DF_SCC_mv,]

DF_NEI_temp = filter(DF_NEI_mv, fips == '24510')
myyears = unique(DF_NEI_temp$year)
DF_NEI_sums = data.frame()

for(i in myyears) {
    DF_NEI_temp2 = filter(DF_NEI_temp, year == i)
    DF_NEI_temp3 = round(sum(DF_NEI_temp2$Emissions), digits = 0)
    DF_NEI_sums = rbind(DF_NEI_sums, DF_NEI_temp3)
    colnames(DF_NEI_sums) = 'emission_sum'
} 

DF_NEI_sums = mutate(DF_NEI_sums, year = myyears)

qplot(year, emission_sum, data = DF_NEI_sums, geom = c('smooth', 'point'),
      xlab = 'Year', ylab = 'Emission sum (pm25 tons)', 
      main = 'Yearly motor vehicle-based pm25 emission in Baltimore',
      method = 'loess', col = I("burlywood"))

dev.copy(png, file = './plot5.png') 
dev.off()


rm(list = ls())
closeAllConnections()