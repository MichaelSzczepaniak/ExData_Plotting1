# Read just the data from the data 2007-02-01 and 2007-02-02
fileName <- "household_power_consumption.txt"
colClasses <- c("character", "character", rep("numeric", 7))
con <- file(fileName)
open(con)
headers <- unlist(read.table(con, sep = ";", nrows = 1,
                             colClasses = "character",
                             header = FALSE)[1, ])
# inital run took 16 sec's of elapsed time, reduced to 0.25 sec's after
# reading in only the 2880 rows needed for project
#system.time({
    data <- read.table(con, header = TRUE, sep = ";",
                       skip = 66637, nrows = 2880)
    names(data) <- make.names(headers) #, allow_ = FALSE)
#})
close(con)