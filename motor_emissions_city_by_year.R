library(plyr)
library(ggplot2)

if (!file.exists("NEI_data.zip")) {
  download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "NEI_data.zip", method = "curl")
}

if (!file.exists("Source_Classification_Code.rds")) {
  unzip("NEI_data.zip")
}

scCode <- readRDS(file = "Source_Classification_Code.rds");
permEmissions25 <- readRDS(file = "summarySCC_PM25.rds");

subPermEmissions25 <- permEmissions25[permEmissions25$fips == "24510" | permEmissions25$fips == "06037",]

motorSources <- scCode[grepl("*Vehicles", scCode$EI.Sector),]
motorPermEmissions25 <- subPermEmissions25[subPermEmissions25$SCC %in% motorSources$SCC,]

emissionsByYear <- ddply(motorPermEmissions25, c("year", "fips"), summarise, total = sum(Emissions))

emissionsByYear$city <- ifelse(emissionsByYear$fips == "24510", "Baltimore", "Los Angeles")

png(filename="motor_emissions_in_cities_by_year.png")
qplot(x      = year,
      xlab   = "Year",
      y      = total,
      ylab   = "Total Emissions",
      data   = emissionsByYear,
      color  = city,
      geom   = c("point", "smooth"),
      method = "loess")
dev.off()