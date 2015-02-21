# data downloaded from - https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip

library(dplyr)
library(ggplot2)

# reading data - RDS files have to be in current WD
DF_NEI = readRDS('./summarySCC_PM25.rds')
DF_SCC = readRDS('./Source_Classification_Code.rds')

# question 3 - total yearly pm25 emission by source in Baltimore; make plot
DF_NEI_temp = filter(DF_NEI, fips == '24510')
myyears = unique(DF_NEI_temp$year)
sources = unique(DF_NEI_temp$type)
DF_NEI_sums = data.frame()

for(i in sources) {
    DF_NEI_temp2 = filter(DF_NEI_temp, type == i)
    
    for(j in myyears) {
        DF_NEI_temp3 = filter(DF_NEI_temp2, year == j)
        DF_NEI_temp4 = round(sum(DF_NEI_temp3$Emissions), digits = 0)
        DF_NEI_sums = rbind(DF_NEI_sums, DF_NEI_temp4)
        colnames(DF_NEI_sums) = 'emission_sum'
    }    
}

DF_NEI_sums = mutate(DF_NEI_sums, 
                     type = c(rep(sources[1], 4), rep(sources[2], 4), 
                              rep(sources[3], 4), rep(sources[4], 4)), 
                     year = rep(myyears, 4))

qplot(year, emission_sum, data = DF_NEI_sums, col = type, geom = c('smooth', 'point'),
      xlab = 'Year', ylab = 'Emission sum (pm25 tons)', 
      main = 'Total yearly pm25 emission by source in Baltimore', method = 'loess')

dev.copy(png, file = './plot3.png') 
dev.off()


rm(list = ls())
closeAllConnections()