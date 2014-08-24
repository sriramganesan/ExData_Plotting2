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

baltPermEmissions25 <- permEmissions25[permEmissions25["fips"] == "24510",]
baltPermEmissions25$typefactor <- factor(baltPermEmissions25$type)

baltEmissionsByYear <- ddply(baltPermEmissions25, "year", summarise, total = sum(Emissions))

png(filename="baltimore_total_emissions.png")
plot(x    = baltEmissionsByYear$year,
     y    = baltEmissionsByYear$total / 1000,
     type = "l",
     ylab = "Total Emissions from All Sources (kilotons)",
     xlab = "Year"
)
dev.off()