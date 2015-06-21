# setwd("~/Documents/## Github Repo/Data-Product")
library(ggplot2)
library(reshape)
library(DT)
library(rCharts)
require(data.table)

# unzip("rprog-data-ProgAssignment3-data.zip")
outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
outcome<-outcome[,c(1:11,17,23)]
# Delete empty column
outcome<-outcome[,-c(4,5)]
outcome[,9:11]<-sapply(outcome[,9:11],as.numeric)
outcome<-data.table(outcome)
# Explore the data set
names<-names(outcome);names
table(sapply(outcome,class))

setnames(outcome, "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack", "Heart Attack")
setnames(outcome, "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure", "Heart Failure")
setnames(outcome, "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia", "Pneumonia")

# Exploratory data analysis
sum(is.na(outcome))
table(outcome$State) 
state <- sort(unique(outcome$State))

# Reshape data.table
outcome<-melt(outcome,id=1:8,measure=9:11)
outcome$value[outcome$value=="Not Available"]<-NA

outcome$variable<-as.character(outcome$variable)

# Aggregate result by State
groupByState <- function(dt, Index, state) {
  result <- subset(dt,variable %in% Index & State %in% state) 
  result<-result[order(result$value),]
  result<-na.omit(result)
  result<-head(result,100)
  return(result)
}
# x<-groupByState(outcome,"Heart Attack",c("AL","AR"))
#x$relative<-x$value-mean(x$value)

# Take relative value of mortality rate, given the state selected
relative <- function(dt, Index,state) {
  dt <- groupByState(dt, Index, state) 

  result<-data.frame(dt,relative=dt$value-mean(dt$value))
  return(result)
}
#x<-relative(outcome,"Heart Attack",c("AL","AR"))

# Plot groupByState
plotGroupByState <- function(dt,  dom= "hospitalByMortality", 
                                 xAxisLabel = "Hospital", 
                                 yAxisLabel = "Mortality Rate") {
  
  hospitalByMortality <- nPlot(
    relative ~ Hospital.Name,
    dom=dom,
    data = dt,
    color="State",
    type = "multiBarHorizontalChart"
  )
  
  #hospitalByMortality$chart(margin = list(left = 230))
  #hospitalByMortality$chart(color = c('red', 'blue'))
  #hospitalByMortality$yAxis(axisLabel = yAxisLabel, width = 200)
  #hospitalByMortality$xAxis(axisLabel = xAxisLabel, width = 2000,
  #                       rotateLabels = -10, height = 100)
  #hospitalByMortality
  
}
# Deploy to shinyApp
#library(shinyapps)
#shinyapps::deployApp('~/Documents/## Github Repo/Data-Product')

