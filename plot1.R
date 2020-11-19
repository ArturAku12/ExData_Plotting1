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
x <- electricity$Global_active_power #x-axis
y <- seq(0, 1200, by = 200) #y-axis
png("plot1.png", width=480, height=480) #open png device
hist(x, col = "red", #color
     main = "Global Active Power", #title
     ylim = range(y), #y-axis breaks
     xlab = "Global Active Power (kilowatts)", #x-axis label
     ylab = "Frequency") #y-axis label
dev.off() #close png device - saved to the wd
