#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  #Actual part from where the text will be loaded
  Dataset <- reactive({
    
    if (is.null(input$textfile)) {   # locate 'textfile' from ui.R
      
      return(NULL) } else{
        
        datacontent <- readLines(input$textfile$datapath)
        datacontent
        #return (datacontent)
      }
  })

  # You can access the value of the widget with input$file, e.g.
  output$value <- renderPrint({
    str(input$file)
  })
  
  output$value <- renderPrint({
    str(input$file1)
  })
  
  # You can access the values of the widget (as a vector)
  # with input$checkGroup, e.g.
  output$value <- renderPrint({ input$checkGroup })

  output$plot1 <- renderPlot({
    plot(mtcars$wt, mtcars$mpg)
  })
  
  output$info <- renderText({
    paste0("x=", input$plot_click$x, "\ny=", input$plot_click$y)
  })
  
  output$textdata <- renderText({
    fileText <- paste(Dataset(), collapse = "\n")
    fileText
  })
  
})
