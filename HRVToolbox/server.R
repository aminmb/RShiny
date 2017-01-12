#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
options(shiny.maxRequestSize = 27*1024^2)
options(rgl.useNULL=TRUE)


library(rgl)
library(rglwidget)
library(shiny)
library(shinyRGL)
library(scatterplot3d)
library(knitr)
knit_hooks$set(webgl = hook_webgl)


# Define server logic required to draw a histogram
shinyServer(
  function(input, output, session) {
    
    
    
    output$rglplot <- renderRglwidget({
      inFile <- input$physionetFile
      if (is.null(inFile))
        return(NULL)
      DataRaw <- read.csv(inFile$datapath, header = input$header, sep = input$sep)
      physionetSignalTime <- DataRaw [ , 1 ]
      physionetSignalECG  <- DataRaw [ , 2 ]
      physionetSignalEMG  <- DataRaw [ , 3 ]
      physionetSignalFGSR <- DataRaw [ , 4 ]  # Foot GSR
      physionetSignalHGSR <- DataRaw [ , 5 ]  # Hand GSR
      
      Data_Length <- length ( physionetSignalECG )
      V <- physionetSignalECG
      tau = input$physionetTau
      
      ###### Initializing Delayed Signals  ########
      V_tau = rep (0, Data_Length)  # V (t-tau)
      V_2_tau = rep (0, Data_Length)  # V (t-2*tau)
      
      ###### Calculating Delayed Signals  ########
      for (i in 1: Data_Length) {
        if ( i < tau ) {
          V_tau [i] = 0
          V_2_tau [i] = 0
        } else if ( i >= tau && i <= 2*tau ) {
          V_tau [i] <- V [ i - tau + 1 ]
          V_2_tau [i] = 0
        } else{
          V_tau [i] <- V [ i - tau + 1 ]
          V_2_tau [i] <- V [ i - 2*tau + 1 ]
        }
      }  
      plot3d ( V, V_tau , V_2_tau )
      #plot3d ( V, V_tau , V_2_tau, main = 'ECG tau = 15')
      rglwidget()
    })
    
    output$myPlot <- renderPlot ({
      if (input$experiment == "PhysioNet Automobile Driver Stress"){
        inFile <- input$physionetFile
        if (is.null(inFile)) {
          return(NULL)
        }
        DataRaw <- read.csv(inFile$datapath, header = input$header, sep = input$sep)
        physionetSignalTime <- DataRaw [ , 1 ]
        physionetSignalECG  <- DataRaw [ , 2 ]
        physionetSignalEMG  <- DataRaw [ , 3 ]
        physionetSignalFGSR <- DataRaw [ , 4 ]  
        physionetSignalHGSR <- DataRaw [ , 5 ]
        
        if ( input$physionetPlotType == "TimeSeries") {
          Data_Length <- length ( physionetSignalECG )
          if (input$physionetSignal == "ECG") {
            plot ( physionetSignalECG, type = "l", xlim = c (0, Data_Length))
          } 
          else if ( input$physionetSignal == "EMG") {
            plot ( physionetSignalEMG, type = "l")
          }
          else if ( input$physionetSignal == "HGSR" ) {  
            plot ( physionetSignalHGSR, type = "l")
          }
          else {
            plot ( physionetSignalFGSR, type = "l")
          }
        }
      }
      else {
        inFile <- input$empaticaFile
        if (is.null(inFile)) {
          return(NULL)
        }
        DataRaw <- read.csv ( inFile$datapath, header = input$header, sep = input$sep )
        empaticaSignalTime <- DataRaw [ , 5 ]
        empaticaSignalIBI  <- DataRaw [ , 2 ]
        empaticaSignalEDA  <- DataRaw [ , 3 ]
        empaticaSignalBVP  <- DataRaw [ , 4 ]
        if ( input$empaticaSignal == "IBI" ){ 
          plot ( empaticaSignalIBI, type = "l" )
        }
        else if ( input$empaticaSignal == "BVP" ) {
          plot ( empaticaSignalEDA, type = "l" )
        }
        else if ( input$empaticaSignal == "HR" ) {
          plot ( empaticaSignalBVP, type = "l" )
        }
      }
    })
  })
