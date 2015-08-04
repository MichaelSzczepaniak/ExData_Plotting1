library(dplyr)


readHouseholdPowerData <-
    function(fileName, startRow, readCount) {
        colClasses <- c("character", "character", rep("numeric", 7))
        con <- file(fileName)
        open(con)
        headers <- unlist(read.table(con, sep = ";", nrows = 1,
                                     colClasses = "character",
                                     header = FALSE)[1, ])
        data <- read.table(con, header = TRUE, sep = ";",
                           skip = (startRow - 1), nrows = readCount)
        names(data) <- make.names(headers) #, allow_ = FALSE)
        close(con)
        
        return(data)
    }

# Read just the data from the data 2007-02-01 and 2007-02-02. This data starts
# at row 66638 and continue for 2880 records
data <- readHouseholdPowerData(fileName = "household_power_consumption.txt",
                               startRow = 66638, readCount = 2880)
hist(data$Global_active_power, main = "Global Active Power",
     col = "red", xlab = "Global Active Power (kilowatts)")
# create/write output png. Default size is 480 x 480 pixels, but be explicit
dev.copy(png, file = "plot1.png", width = 480, height = 480, units = "px")
dev.off()