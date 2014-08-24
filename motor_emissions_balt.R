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

baltPermEmissions25<- permEmissions25[permEmissions25["fips"] == "24510",]

motorSources <- scc[grepl("*Vehicles", scc$EI.Sector),]
motorPermEmissions <- baltPermEmissions25[baltPermEmissions25$SCC %in% motorSources$SCC,]

emissionsByYear <- ddply(motorPermEmissions, "year", summarise, total = sum(Emissions))

png(filename="motor_emissions_in_baltimore_by_year.png")
qplot(x = year,
      xlab = "Year",
      y = total,
      ylab = "Total Emissions (tons)",
      data = emissionsByYear,
      geom = c("point", "smooth"),
      method = "loess")
dev.off()