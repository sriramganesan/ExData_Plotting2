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

permEmissionsByYear <- ddply(pm25, "year", summarise, total = sum(Emissions))

png(filename="total_emits_over_time.png")
plot(x    = permEmissionsByYear$year,
     y    = permEmissionsByYear$total / 1000,
     type = "l",
     ylab = "Total Emissions",
     xlab = "Year"
)
dev.off()