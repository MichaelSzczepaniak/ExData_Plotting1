## Reads in the data to generate plot
## fileName - location of the data file, e.g. "household_power_consumption.txt"
## startRow - first row of the data file to be read
## readCount - number of rows of the data file to be read
readHouseholdPowerData <-
    function(fileName, startRow, readCount) {
        colClasses <- c("character", "character", rep("numeric", 7))
        con <- file(fileName)
        open(con)
        headers <- unlist(read.table(con, sep = ";", nrows = 1,
                                     colClasses = "character",
                                     header = FALSE,
                                     stringsAsFactors = FALSE)[1, ]
        )
        data <- read.table(con, header = TRUE, sep = ";",
                           colClasses = colClasses,
                           skip = (startRow - 1), nrows = readCount,
                           stringsAsFactors = FALSE)
        names(data) <- make.names(headers) #, allow_ = FALSE)
        close(con)
        
        return(data)
    }

# Read just the data from the data 2007-02-01 and 2007-02-02. This data starts
# at row 66638 and continue for 2880 records
data <- readHouseholdPowerData(fileName = "household_power_consumption.txt",
                               startRow = 66638, readCount = 2880)
dtFormat <- "%d/%m/%Y %H:%M:%S"
data$datetime <- strptime(paste(data$Date, data$Time), dtFormat) # add date-time
png(file = "plot4.png", width = 480, height = 480, units = "px")
par(mfcol = c(2, 2))  # set up 2 x 2 grid of charts
with(data, {
    # build top-left chart 1st: similar to plot2.R
    plot(datetime, Global_active_power, type = "l",
         xlab = "", ylab = "Global Active Power")
    # build bottom-left chart 2nd: similar to plot3.R
    plot(datetime, Sub_metering_1, type = "l", col = "black",
         xlab = "", ylab = "Energy sub metering")
    lines(datetime, Sub_metering_2, col = "red")
    lines(datetime, Sub_metering_3, col = "blue")
    # use bty = "n" to remove box around legend
    legend("topright", lty = 1, col = c("black", "red", "blue"), bty = "n",
           legend = c(names(data[7]), names(data[8]), names(data[9])))
    # build top-right chart 3rd: voltage vs. time
    plot(datetime, Voltage, type = "l", xlab = "datetime", ylab = "Voltage")
    # build bottom-right chart last: Global Reactive Power vs. time
    plot(datetime, Global_reactive_power, type = "l",
         xlab = names(data[10]), ylab = names(data[4]))
})

dev.off()