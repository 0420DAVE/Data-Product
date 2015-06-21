library(shiny)

# Load data processing file
source("data_processing.R")
state <- sort(unique(outcome$State))

# Shiny server
shinyServer(
  function(input, output) {
    #     output$text1 <- renderText({input$text1})
    #     output$text2 <- renderText({input$text2})
    #     output$text3 <- renderText({
    #       input$goButton
    #       isolate(paste(input$text1, input$text2))
    #     })

    
    # Initialize reactive values
    values <- reactiveValues()
    values$state <- state
    
    # Create event type checkbox
    output$themesControl <- renderUI({
      checkboxGroupInput('state', 'State:', 
                         state, selected = values$state)
    })
    
    # Add observer on select-all button
    observe({
      if(input$selectAll == 0) return()
      values$state <- state
    })
    
    # Add observer on clear-all button
    observe({
      if(input$clearAll == 0) return()
      values$state <- c() # empty list
    })
    
    # Prepare dataset
    dataTable <- reactive({
      groupByState(outcome, input$index, input$state)
    })
    
    relativeTable<-reactive({
      relativeTable<-relative(outcome,input$index,input$state)
    })
    
    
    # Render datatable 
    output$dTable <- DT::renderDataTable({
      dataTable()
    } #, options = list(bFilter = FALSE, iDisplayLength = 50)
    )
    
    # Render chart
    output$hospitalByMortality <- renderChart({
      plotGroupByState(relativeTable())
    })
    
  } # end of function(input, output)
)







