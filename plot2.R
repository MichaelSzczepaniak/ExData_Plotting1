library(dplyr)


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
# dplyr mutate doesn' support POSIXlt, so use base R method
data$DateTime <- strptime(paste(data$Date, data$Time), dtFormat)

with(data, plot(DateTime, Global_active_power, type = "n",
                xlab = "", ylab = "Global Active Power (kilowatts)"))
with(data, lines(DateTime, Global_active_power))
dev.copy(png, file = "plot2.png", width = 480, height = 480, units = "px")
dev.off()