#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

options(rgl.useNULL=TRUE)
library(rgl)
library(rglwidget)
library(shiny)
library(shinyRGL)
library(rgl)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Physiological Data Visualization"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout (
    sidebarPanel (
      selectInput ("experiment", "Please select the experiment",
                   choices=c("PhysioNet Automobile Driver Stress","Empatica E4")),
      conditionalPanel (condition = "input.experiment == 'Empatica E4'",
                        radioButtons ("empaticaUpload", label = h3("Please select the database"),
                                      choices = list ("Upload the .CSV file" = 1, "Using Libraries" = 2), selected = 1),
                        conditionalPanel (condition = "input.empaticaUpload == 1",
                                          fileInput('empaticaFile', 'Choose file to upload',
                                                    accept = c('text/csv','text/comma-separated-values','text/tab-separated-values',
                                                               'text/plain','.csv', '.tsv')
                                          ),
                                          checkboxInput('header', 'Header', TRUE),
                                          radioButtons('sep', 'Separator', c(Comma=',',Semicolon=';', Tab='\t'),',')
                        ),
                        conditionalPanel (condition = "input.empaticaUpload == 2",
                                          selectInput ("empaticaDate", "Please select the date",
                                                       choices=c("June 30, 2016","July 22, 2016","July 29, 2016",
                                                                 "August 19, 2016","October 12, 2016")
                                          )
                        ),
                        selectInput ("empaticaSignal", "Please select the physiological measurement from Empatica E4",
                                     choices=c("HR","BVP","IBI","EDA","Temp", "AccelX","AccelY","AccelZ")),
                        selectInput ("empaticaPlotType", "Please select the type of plot",
                                     choices=c("Time Series","3D Scatterplot")),
                        conditionalPanel (condition = "input.empaticaPlotType == '3D Scatterplot'",
                                          sliderInput ("empaticaTau", "Please select the delay time (tau):",
                                                       min = 1, max = 120, value = 10, step = 1)
                        )
      ),
      conditionalPanel (condition = "input.experiment == 'PhysioNet Automobile Driver Stress'",
                        radioButtons ("physionetUpload", label = h3("Please select the database"),
                                      choices = list ("Upload the .CSV file" = 1, "Using Libraries" = 2), selected = 1),
                        conditionalPanel (condition = "input.physionetUpload == 1",
                                          fileInput('physionetFile', 'Choose file to upload',
                                                    accept = c('text/csv','text/comma-separated-values','text/tab-separated-values',
                                                               'text/plain','.csv', '.tsv')
                                          ),
                                          checkboxInput('header', 'Header', TRUE),
                                          radioButtons('sep', 'Separator', c(Comma=',',Semicolon=';', Tab='\t'),',')
                        ),
                        conditionalPanel (condition = "input.physionetUpload == 2",
                                          selectInput ("physionetDate", "Please select the dataset",
                                                       choices=c("driver01","driver02","driver03", "driver04","driver05")
                                          )
                        ),
                        selectInput ("physionetSignal", "Please select the physiological measurement from Empatica E4",
                                     choices=c("ECG","EMG","HGSR","FGSR")),
                        selectInput ("physionetPlotType", "Please select the type of plot",
                                     choices=c("Time Series","3D Scatterplot")),
                        conditionalPanel (condition = "input.physionetPlotType == '3D Scatterplot'",
                                          sliderInput ("physionetTau", "Please select the delay time (tau):",
                                                       min = 1, max = 120, value = 10, step = 1)
                        )
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("2D Plot", plotOutput("myPlot")),
        tabPanel("3D Plot", rglwidgetOutput("rglplot"))
      )
    )
    
    #fluidRow(
    # splitLayout(cellWidths = c("50%", "50%"), rglwidgetOutput("rglplot"), plotOutput("myPlot"))
    
    
  )
)
)

