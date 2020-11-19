#Libraries loaded
library(dplyr)
library(lubridate)
library(tidyr)
#Create a data directory
if(!file.exists("data")) {
  dir.create("data")
}

file.info("./data/household_power_consumption.txt")$size #Finds the size of the file

#Load in the file and make into a tibble for better and easier usage
electricity_whole <- read.table("./data/household_power_consumption.txt", sep = ";", na.strings = "?", header = TRUE)
electricity_whole <- tbl_df(electricity_whole)
electricity <- filter(electricity_whole, Date == "1/2/2007"| Date == "2/2/2007") #select desired rows

#First combines the two columns and then transforms them into a yyyy:mm:dd:hh:mm:ss format timestamp
electricity <- unite(electricity, "Timestamp", Date:Time)
electricity <- mutate(electricity, Timestamp = strptime(Timestamp, format = '%d/%m/%Y_%H:%M:%S'))
par(mfrow = c(1,1))
x <- electricity$Timestamp
meter1 <- electricity$Sub_metering_1
meter2 <- electricity$Sub_metering_2
meter3 <- electricity$Sub_metering_3
png("plot3.png", width = 480, height = 480)
plot(x, meter1, type = "l", ylab = "Energy sub metering")
points(x, meter2, type = "l", col = "red")
points(x, meter3, type = "l", col = "blue")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, col=c("black", "red", "blue"), text.font = 1)
dev.off()
