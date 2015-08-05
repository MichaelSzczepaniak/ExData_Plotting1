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
png(file = "plot2.png", width = 480, height = 480, units = "px")
with(data, plot(datetime, Global_active_power, type = "l",
                xlab = "", ylab = "Global Active Power (kilowatts)"))
# 2 lines below were used when writing first to screen then copy to png
#with(data, lines(datetime, Global_active_power))
#dev.copy(png, file = "plot2.png", width = 480, height = 480, units = "px")
dev.off()