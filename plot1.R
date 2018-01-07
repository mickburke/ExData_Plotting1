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

png("plot1.png")
hist(data$Global_active_power, 
     xlab="Global Active Power (kilowatts)", 
     ylab="Frequency", 
     col="red", 
     main="Global Active Power")
dev.off()