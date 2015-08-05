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
                                     header = FALSE)[1, ])
        data <- read.table(con, header = TRUE, sep = ";",
                           skip = (startRow - 1), nrows = readCount)
        names(data) <- make.names(headers) #, allow_ = FALSE)
        close(con)
        
        return(data)
    }

# Read just the data from 2007-02-01 and 2007-02-02. This data starts at
# row 66638 and continues for 2880 records. The values 66638 and 2280 were
# obtained by inspecting the data using Notepad ++ but a better way would be
# to do the following from the command line:
# raw <- readLines("household_power_consumption.txt") # took ~10 sec's on my pc
# day1 <- grep("^1/2/2007", raw) # need ^ to eliminate things like 11/2/2007
# day1[1]
# [1] 66638
# day2 <- grep("^2/2/2007", raw) # need ^ to eliminate things like 12/2/2007
# length(day1) + length(day2)
# [1] 2880
data <- readHouseholdPowerData(fileName = "household_power_consumption.txt",
                               startRow = 66638, readCount = 2880)
# create/write output png. Default size is 480 x 480 pixels, but be explicit
png(file = "plot1.png", width = 480, height = 480, units = "px")
hist(data$Global_active_power, main = "Global Active Power",
     col = "red", xlab = "Global Active Power (kilowatts)")
# If you write to screen device, use next line to copy it to png file.
#dev.copy(png, file = "plot1.png", width = 480, height = 480, units = "px")
dev.off()