library(sqldf)

filename <- "household_power_consumption.txt"
if (!file.exists(filename))
{
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                destfile="household_power_consumption.zip")
  unzip("household_power_consumption.zip")
}

#using read.csv.sql to select only the required dates
data <- read.csv.sql(filename, 
                     sql = "select * from file 
                     where Date = '1/2/2007' or Date = '2/2/2007'",
                     sep = ";",
                     header = TRUE)
closeAllConnections() #close SQL connections

data$Date <- strptime(paste(data$Date, data$Time), 
                      format = "%d/%m/%Y %H:%M:%S")
data <- data[-2]#remove Time column which was merged into Date above

png("plot3.png")
plot(data$Date, 
     data$Sub_metering_1, 
     xlab="", 
     ylab="Energy sub metering", 
     type="n")
lines(data$Date, data$Sub_metering_1)
lines(data$Date, data$Sub_metering_2, col="red")
lines(data$Date, data$Sub_metering_3, col="blue")
legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), 
       pch = NA,#na as using a line
       bty = "o",#put box around legend
       cex = 0.75,#reduce size to match
       lty=1)#use lines instead of a pch
dev.off()

