## Create a class "myDate" to coerce character string in the format DD-MM-YYYY into Date class upon import
setClass("myDate")
setAs("character","myDate", function(from) as.Date(from, format = "%d/%m/%Y"))

## Create a class "myTime" to coerce character string in the format HH:MM:SS into POSIXct class upon import
setClass("myTime")
setAs("character", "myTime", function(from) strptime(from, "%H:%M:%S"))

## Read all data
largeData <- read.table("./household_power_consumption.txt",                     ## data file path in working directory
                        sep = ";",                                               ## data separated by semi-colon
                        header = TRUE,                                           ## variable names in first row
                        colClasses = c("Date" = "myDate", "Time" = "myTime"),    ## set classes of Date and Time data upon import
                        stringsAsFactors = FALSE,                                ## character strings should not default to factors
                        na.strings = "?")                                        ## missing values are denoted by a question mark

## Coerce date and time character strings into a single variable
library(lubridate)
largeData$Time <- with(largeData, dmy(Date) + hms(Time))                         ## Time variable now includes data information
largeData <- largeData[,2:9]                                                     ## remove Date variable (now superfluous)

## Subset data from the dates 2007-02-01 and 2007-02-02
subsetbyDate <- with(largeData, subset(largeData, date(Time) == "2007-02-01" | date(Time) == "2007-02-02"))

## Open PNG device
png(filename = "plot2.png", width = 480, height = 480, units = "px")

## Plot data for plot2
plot(subsetbyDate$Time, subsetbyDate$Global_active_power,                        ## specify x- and y-variables
                        type = "l",                                              ## line graph with no point markers
                        xlab = "",                                               ## set no x-axis label
                        ylab = "Global Active Power (kilowatts)")                ## set y-axis label

# Close PNG device
dev.off()