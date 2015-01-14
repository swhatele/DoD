#setwd("/Users/Sarah/Dropbox/UMass_Research_PhD/2014-2015/SERDP/tool/")
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinyapps)
library(RCurl)
library(networkD3)
require(rCharts)
require(igraph)

shinyServer(function(input, output,session) {
  source("Load_data.R")
  output$simple <- renderSimpleNetwork({
    src <- c("Desktop screening questions", "Context analysis", "Context analysis", "Context analysis", "Context analysis", "Context analysis", "Climate sensitive?","Climate sensitive?", "No")
    target <- c("Context analysis", "Choices", "Consequences", "Connections", "unCertainties", "Climate sensitive?", "No","Yes-move to next phase", "Climate Screening Worksheet")
    networkData <- data.frame(src, target)
    simpleNetwork(networkData, opacity = 1,fontSize=14,linkDistance = 100,charge = -1000,nodeColour="#000080")
  })
  output$phase2 <- renderSimpleNetwork({
    src <- c("Climate sensitive?", "Yes", "Simple system model?", "Simple system model?","No","Build simple system model","Yes-","Climate dominant factor?","Climate dominant factor?","No-")
    target <- c("Yes", "Simple system model?", "Yes-", "No","Build simple system model","Climate dominant factor?","Climate dominant factor?","Yes--move to next phase","No-","Climate Risk Statement")
    networkData <- data.frame(src, target)
    simpleNetwork(networkData, opacity = 1,fontSize=14,linkDistance = 100,charge = -1000)
  })
  
  metricInput <- reactive({
    CONTOUR_VARIABLE <- eval(parse(text=paste(input$location,input$metric,sep="_")))
  })

output$responsesurface <- renderPlot({

  CONTOUR_VARIABLE <- metricInput()

  if (paste(input$location,input$metric,sep="_")=="Colorado_Rel"){
    prcp_change <- c(0.9,0.95,1,1.05,1.1)
    temp_change <- c(-2,-1,0,1,2,3,4,5,6,7)
    TRESHOLD <- 0.95
  
    tt <- "WATER SUPPLY RELIABILITY"
    n <- 30
    lwd = 5
    xgrid <- temp_change
    ygrid <- prcp_change
    ylabel <- "Precipitation Mean (% Change)"
    xlabel <- "Temperature Mean Change (F)"
    zlim <- c(0,1)
    level <- pretty(zlim, n)
    color = colorRampPalette(c("red","white","blue"))(length(level)-1)
    w <- which(abs(level-TRESHOLD)==min(abs(level-TRESHOLD)))
    level[w] <- TRESHOLD
    color1 = colorRampPalette(c("red","white"))(w-1)
    color2 = colorRampPalette(c("#6868FF","blue"))(length(level)-w)
    color = c(color1,color2)
    par(font.lab=2,font.axis=2)
    filled.contour(ygrid,xgrid,CONTOUR_VARIABLE,ylab=xlabel,xlab=ylabel,main=tt,col=color,zlim=zlim,levels=level,axes=FALSE,
    plot.axes = { points(DELTA_PRCP,DELTA_TEMP,pch=16); 
    contour(ygrid,xgrid,CONTOUR_VARIABLE,level=c(TRESHOLD),lty=c("solid"),add=TRUE,lwd=lwd,zlim = zlim,drawlabels=FALSE,axes=FALSE);
    axis(1,at=ygrid,labels=prcp_change);
    axis(2,at=xgrid,labels=temp_change)},
    key.axes = axis(4, seq(0, 1, by = 0.1))
    )
  } else if (paste(input$location,input$metric,sep="_")==paste(input$location,"KDMI",sep="_")) {
    nlev <- 30
    prcp_base <- which(Prcp_Change==1)
    temp_base <- which(Temp_Change==0) 
    cur_Baseline <- CONTOUR_VARIABLE[prcp_base,temp_base]
    min_var <- 0
    max_var <- 365
    key_levels <- c(0,30,60,90,120,150,180,210,240,270,300,330,365)
    Trigger_level2 <- cur_Baseline+7
    zlim <- c(min_var,max_var)
    PERCENT_SPACE_BELOW_THRESHOLD <- floor((Trigger_level2-min_var)*100/(diff(zlim)))/100
    PERCENT_SPACE_ABOVE_THRESHOLD <- 1-PERCENT_SPACE_BELOW_THRESHOLD
    Number_of_levels_below_threshold <- floor(nlev*PERCENT_SPACE_BELOW_THRESHOLD)
    if (Number_of_levels_below_threshold>=(nlev-1)) {Number_of_levels_below_threshold <- Number_of_levels_below_threshold-1}
    if (Number_of_levels_below_threshold<=1) {Number_of_levels_below_threshold <- 2}
    Number_of_levels_above_threshold <- nlev-Number_of_levels_below_threshold
    level1 <-seq(min_var,Trigger_level2,length.out=Number_of_levels_below_threshold)
    level2 <- seq(Trigger_level2,max_var,length.out=Number_of_levels_above_threshold+1)
    mylevel <- c(level1,level2[2:length(level2)])
    color1 <- colorRampPalette(c("blue","MediumBlue"))(Number_of_levels_below_threshold-1)
    color2 <- colorRampPalette(c("white","red"))(Number_of_levels_above_threshold)
    mycolors = c(color1,color2)
    ##PLOT 2
    par(cex.lab=1.3,cex.axis=1.3)
    xvar <- Prcp_Change*100
    yvar <- Temp_Change
    zvar <- t(t(CONTOUR_VARIABLE))
    xxlab <- "Precipitation Mean (% Change)"
    yylab <- "Temperature Mean (C)"
    #contour 2050
    filled.contour(xvar,yvar,zvar,main=tt,zlim=zlim,level=mylevel,
    xlab=xxlab,ylab=yylab,font.lab=2,font.axis=2,col=mycolors,key.axes=axis(4,key_levels),
    plot.axes={axis(1);axis(2);contour(xvar,yvar,zvar,levels=c(Trigger_level2),add=TRUE,lwd=5,lty=1,labels="");
    points(Prcp_Temp_Projections3_2050[,1],Prcp_Temp_Projections3_2050[,2],pch=19,col="black",cex=1.4);
    }
    )
  } else {
    nlev <- 30
    RH_base <- which(RH_Change==0)
    temp_base <- which(Temp_Change==0)
    cur_Baseline <- CONTOUR_VARIABLE[RH_base,temp_base]
    min_var <- 0
    max_var <- 365
    key_levels <- c(0,30,60,90,120,150,180,210,240,270,300,330,365)
    Trigger_level2 <- 100
    zlim <- c(min_var,max_var)
    PERCENT_SPACE_BELOW_THRESHOLD <- floor((Trigger_level2-min_var)*100/(diff(zlim)))/100
    PERCENT_SPACE_ABOVE_THRESHOLD <- 1-PERCENT_SPACE_BELOW_THRESHOLD  
    Number_of_levels_below_threshold <- floor(nlev*PERCENT_SPACE_BELOW_THRESHOLD)
    if (Number_of_levels_below_threshold>=(nlev-1)) {Number_of_levels_below_threshold <- Number_of_levels_below_threshold-1}
    if (Number_of_levels_below_threshold<=1) {Number_of_levels_below_threshold <- 2}
    Number_of_levels_above_threshold <- nlev-Number_of_levels_below_threshold
    level1 <-seq(min_var,Trigger_level2,length.out=Number_of_levels_below_threshold)
    level2 <- seq(Trigger_level2,max_var,length.out=Number_of_levels_above_threshold+1)
    mylevel <- c(level1,level2[2:length(level2)])
    color1 <- colorRampPalette(c("blue","MediumBlue"))(Number_of_levels_below_threshold-1)
    color2 <- colorRampPalette(c("white","red"))(Number_of_levels_above_threshold)
    mycolors = c(color1,color2)
    par(cex.lab=1.3,cex.axis=1.3)
    yvar <- Temp_Change
    xvar <- RH_Change
    zvar <- t(t(CONTOUR_VARIABLE))
    xxlab <- "Relative Humidity Mean (% Change)"
    yylab <- "Temperature Mean (C)"
    #contour
    filled.contour(xvar,yvar,zvar,main=tt,zlim=zlim,level=mylevel,
    xlab=xxlab,ylab=yylab,font.lab=2,font.axis=2,col=mycolors,key.axes=axis(4,key_levels),
    plot.axes={axis(1);axis(2);contour(xvar,yvar,zvar,levels=c(Trigger_level2),add=TRUE,lwd=5,lty=1,labels="")
    }
    )  
  }
})  
  
})