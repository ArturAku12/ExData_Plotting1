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
#Creates a grid
png("plot4.png", width=480, height=480)
par(mfrow = c(2,2))

x <- electricity$Timestamp
y_1 <- electricity$Global_active_power
plot(x, y_1, type="l", xlab="", ylab="Global Active Power ")

y_2 <- electricity$Voltage
plot(x, y_2, type="l", xlab="datetime", ylab="Voltage")

y_3_1 <- electricity$Sub_metering_1
y_3_2 <- electricity$Sub_metering_2
y_3_3 <- electricity$Sub_metering_3

plot(x, y_3_1, type = "l", ylab = "Energy sub metering")
points(x, y_3_2, type="l", col = "red")
points(x, y_3_3, type="l", col = "blue")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, col=c("black", "red", "blue"), text.font = 1, cex = 0.4, box.lty=0)

y_4 <- electricity$Global_reactive_power
plot(x, y_4, type = "l", xlab = "datetime", ylab ="Global_reactive_power", lwd=1)
dev.off()
