# data downloaded from - https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip

library(dplyr)
library(ggplot2)

# reading data - RDS files have to be in current WD
DF_NEI = readRDS('./summarySCC_PM25.rds')
DF_SCC = readRDS('./Source_Classification_Code.rds')

# question 4 - emissions from coal combustion-related sources - Baltimore; make plot
coalcombust = c('Fuel Comb - Comm/Institutional - Coal', 
                'Fuel Comb - Electric Generation - Coal', 
                'Fuel Comb - Industrial Boilers, ICEs - Coal')
DF_SCC_coal = as.character(
    unique(
        DF_SCC[grep(
            paste(coalcombust, collapse = '|'), DF_SCC$EI.Sector),])
    $SCC)

DF_NEI_coal = DF_NEI[DF_NEI$SCC %in% DF_SCC_coal,]

myyears = unique(DF_NEI_coal$year)
DF_NEI_sums = data.frame()

for(i in myyears) {
    DF_NEI_temp = filter(DF_NEI_coal, year == i)
    DF_NEI_temp2 = round(sum(DF_NEI_temp$Emissions), digits = 0)
    DF_NEI_sums = rbind(DF_NEI_sums, DF_NEI_temp2)
    colnames(DF_NEI_sums) = 'emission_sum'
} 

DF_NEI_sums = mutate(DF_NEI_sums, year = myyears)

qplot(year, emission_sum, data = DF_NEI_sums, geom = c('smooth', 'point'),
      xlab = 'Year', ylab = 'Emission sum (pm25 tons)', 
      main = 'Yearly coal cobustion-based pm25 emission in US',
      method = 'loess', col = I("magenta4"))

dev.copy(png, file = './plot4.png') 
dev.off()


rm(list = ls())
closeAllConnections()