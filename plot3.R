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

# Read data for just 2007-02-01 and 2007-02-02. This data starts at row 66638
# and continues for 2880 records. See comments in plot1.R for details.
data <- readHouseholdPowerData(fileName = "household_power_consumption.txt",
                               startRow = 66638, readCount = 2880)
dtFormat <- "%d/%m/%Y %H:%M:%S"
# dplyr mutate doesn' support POSIXlt, so use base R method
data$datetime <- strptime(paste(data$Date, data$Time), dtFormat)
# write directly to the png device (bypassing window) to fix legend trunc'n:
# http://stackoverflow.com/questions/9400194/legend-truncated-when-saving-as-pdf-using-saveplot
png(file = "plot3.png", width = 480, height = 480, units = "px")
with(data, plot(datetime, Sub_metering_1, type = "n",
                xlab = "", ylab = "Energy sub metering"))
with(data, lines(datetime, Sub_metering_1, col = "black"))
with(data, lines(datetime, Sub_metering_2, col = "red"))
with(data, lines(datetime, Sub_metering_3, col = "blue"))
legend("topright", lty = 1, col = c("black", "red", "blue"),
       legend = c(names(data[7]), names(data[8]), names(data[9])))
dev.off()