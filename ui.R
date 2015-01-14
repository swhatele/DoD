#setwd("/Users/Sarah/Dropbox/UMass_Research_PhD/2014-2015/SERDP/tool/")
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
# devtools::install_github('rstudio/shinyapps') #To install shinyapps

library(shiny)
library(shinyapps) #to run in browser type 'deployApp()', otherwise 'runApp()'
library(markdown)
library(RJSONIO)
library(RCurl)
library(networkD3)
require(rCharts)
require(igraph)

shinyUI(navbarPage("Decision-Scaling Tool", 
    # Load D3.js
    tags$head(
      tags$script(src = 'http://d3js.org/d3.v3.min.js')
    ),
    "Phase 1",
    tabPanel("Phase 1: Project Screening",
       mainPanel(
         simpleNetworkOutput("simple")
       )
    ),
    "Phase 2",
    tabPanel("Phase 2: Initial Analysis",
       mainPanel(
         simpleNetworkOutput("phase2")
       )
    ),
    "Phase 3",
    tabPanel("Phase 3: Climate Stress Test",
      sidebarLayout(
        sidebarPanel(
          selectInput("location",label="Select Location",
            choices = list("US Air Force Academy, CO"="Colorado", "Fort Hood"="FortHood", "Fort Benning"="FortBenning", "Edwards Air Force Base, CA"="Edwards")
            ),
          selectInput("metric",label="Select Performance Metric",
            choices = list("Water Supply Reliability"="Rel", "KDMI"="KDMI", "Days with Fire Training Restriction"="Heat")
          )
          ),
          mainPanel(
            plotOutput(outputId="responsesurface",width="60%")
          )
        )
      ),
    "Phase 4",
    tabPanel("Phase 4: Climate Risk Management") 
  )
)

