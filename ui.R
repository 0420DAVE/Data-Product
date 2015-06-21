# The user-interface definition of the Shiny web app.
#setwd("~/Documents/## Github Repo/Data-Product")
library(shiny)
library(BH)
library(rCharts)
require(markdown)
require(data.table)
library(DT)
options(RCHART_LIB = 'polycharts')
shinyUI(
  navbarPage("US Hospital Comparer", 
             # multi-page user-interface that includes a navigation bar.
             tabPanel("Explore the Data",
                      sidebarPanel(
                        checkboxGroupInput("index", 
                                    "Disease Category:", 
                                    choices=c("Heart Attack"="Heart Attack",
                                              "Heart Failure"="Heart Failure",
                                              "Pneumonia"="Pneumonia"),selected="1"),
                           
                        uiOutput("themesControl"), # the id
                        actionButton(inputId = "clearAll", 
                                     label = "Clear selection", 
                                     icon = icon("square-o")),
                         actionButton(inputId = "selectAll", 
                                     label = "Select all", 
                                     icon = icon("check-square-o"))
                        
                      ),
                      mainPanel(
                        tabsetPanel(
                          # Data 
                          tabPanel(p(icon("table"), "Dataset"),
                                   DT::dataTableOutput(outputId="dTable")
                          ), # end of "Dataset" tab panel
                          
                          tabPanel(p(icon("line-chart"), "Visualize the Data"), 
                                   
                                   h4('Rank of Hospital by Mortality Rate'),# align = "center"
                                   h5('Mortality rate relative to average of the state selected'),
                                   showOutput("hospitalByMortality", "nvd3")      
                          ) # end of "Visualize the Data" tab panel
                          
                        )
                        
                      )     
             ), # end of "Explore Dataset" tab panel
             
             tabPanel("About",
                      mainPanel(
                        includeMarkdown("README.md")
                      )
             ) # end of "About" tab panel
  )
  
)
