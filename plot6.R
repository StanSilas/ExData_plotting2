# data downloaded from - https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip

library(dplyr)
library(ggplot2)

# reading data - RDS files have to be in current WD
DF_NEI = readRDS('./summarySCC_PM25.rds')
DF_SCC = readRDS('./Source_Classification_Code.rds')

# question 6 - comparison of motor-vehicle emission in Baltimore and LA (fips == 06037); make plot
DF_SCC_mv = as.character(unique(DF_SCC[grep("[Vv]ehicles", DF_SCC$EI.Sector),])$SCC)
DF_NEI_mv = DF_NEI[DF_NEI$SCC %in% DF_SCC_mv,]

# baltimore
DF_NEI_temp = filter(DF_NEI_mv, fips == '24510')
myyears = unique(DF_NEI_temp$year)
DF_NEI_sums = data.frame()

for(i in myyears) {
    DF_NEI_temp2 = filter(DF_NEI_temp, year == i)
    DF_NEI_temp3 = round(sum(DF_NEI_temp2$Emissions), digits = 0)
    DF_NEI_sums = rbind(DF_NEI_sums, DF_NEI_temp3)
    colnames(DF_NEI_sums) = 'emission_sum'
} 

DF_NEI_sums = mutate(DF_NEI_sums, year = myyears, region = "Baltimore")

# LA
DF_NEI_la = filter(DF_NEI_mv, fips == '06037')
myyears = unique(DF_NEI_la$year)
DF_NEI_latotal = data.frame()

for(i in myyears) {
    DF_NEI_la2 = filter(DF_NEI_la, year == i)
    DF_NEI_la3 = round(sum(DF_NEI_la2$Emissions), digits = 0)
    DF_NEI_latotal = rbind(DF_NEI_latotal, DF_NEI_la3)
    colnames(DF_NEI_latotal) = 'emission_sum'
} 

DF_NEI_latotal = mutate(DF_NEI_latotal, year = myyears, region = "LA")

DF_NEI_compare = rbind(DF_NEI_sums, DF_NEI_latotal)


qplot(year, emission_sum, data = DF_NEI_compare, geom = c('smooth', 'point'),
      xlab = 'Year', ylab = 'Emission sum (pm25 tons)', 
      main = 'Yearly motor vehicle-based emission in Baltimore & LA - trend',
      method = lm, col = region)

dev.copy(png, file = './plot6.png') 
dev.off()


rm(list = ls())
closeAllConnections()