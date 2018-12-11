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
      hr(),
      
      # Copy the line below to make a select box 
      selectInput("select", label = h3("Select the Udpipe Model"), 
                  choices = list("English" = 1, "Hindi" = 2, "Spanish" = 3), 
                  selected = 1),
      hr(),
      #verbatimTextOutput("udpipevalue"),
      #fluidRow(column(3, verbatimTextOutput("udpipevalue"))),           
      
     
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
                           p("After uploading the file, Select the UDPipe model."),
                           p("By Default English Model would be selected, end user can select as their wish"),
                           p("Then select the Part of Speech"),
                           p("Now traverse through the tabs within the application")
                           ),
                  tabPanel("Data",
                           verbatimTextOutput("textdata")),
                  tabPanel("Model",
                           verbatimTextOutput("udpipevalue")),
                  tabPanel("Co Occurence graph", 
                           plotOutput("plot1"),
                           verbatimTextOutput("info"))
                  
                  
      ) # end of tabsetPanel
    )
  )
))
