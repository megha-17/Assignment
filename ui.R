#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Building a Shiny App around the UDPipe NLP workflow"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      # UPLOADING THE FILE
      fileInput("textfile", "Upload the text File",
                accept = c(
                  "text/txt",
                  "text/textdocument,text/plain",
                  ".txt")
      ),
      textOutput("choose"),
      hr(),           
      
      
      fileInput("file1", "Upload udpipe Model",
                accept = c(
                  "text/txt",
                  "text/textdocument,text/plain",
                  ".txt")
      ),
      hr(),
      # SELECTING THE CHECKBOX
      # Copy the chunk below to make a group of checkboxes
      checkboxGroupInput("checkGroup", label = h3("Select Part of Speech"), 
                         choices = list("adjective (JJ)" = 1, "noun(NN)" = 2, "proper noun (NNP)" = 3,
                                        "adverb (RB)" = 4, "verb (VB)" = 5),
                         selected = c(1,2,3)),
      
      hr()
      
    ),
    
    # Main Code
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  tabPanel("Overview",
                           h4(p("Data input")),
                           p("This app supports only text file i.e. (.txt file)",align="justify"),
                           p("After uploading the file, go to the next tab for view the cooccurence graph.")),
                  tabPanel("Co Occurence graph", 
                           plotOutput("plot1", click = "plot_click"),
                           verbatimTextOutput("info")),
                  tabPanel("Data",
                           verbatimTextOutput("textdata"))
                  
                  
      ) # end of tabsetPanel
    )
  )
))
