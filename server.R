library(shiny)

# Rely on the 'WorldPhones' dataset in the datasets
# package (which generally comes preloaded).
library(datasets)

# Define a server for the Shiny app
shinyServer(function(input, output) {
  
  dataInput <- reactive({
    if (input$sex == 'Both') {
      x <- as.table(apply(HairEyeColor, c(1,2), sum))
    }
    else if (input$sex == 'Male') {
      x <- as.table(HairEyeColor[,,1])
    }
    else {
      x <- as.table(HairEyeColor[,,2])
    }
    return(x)
  })
  # Fill in the spot we created for a plot
  output$hairEyePlot <- renderPlot({
    x<-dataInput()
    
    if (input$transpose == 'Eye Color') {
      colorlist <- c("brown","blue","#594C26", "green")
      y_title = "Eye Color"
      x_title = "Hair Color"
    }
    else {
      x<-t(x)
      colorlist <- c("black", "brown", "red", "#FAF0BE")
      y_title = "Hair Color"
      x_title = "Eye Color"
    }
    
    # Render a mosaicplot with the appropriate colors
    mosaicplot(x, 
            main=c("Relationship between hair and eye color:", input$sex),
            ylab=y_title, cex.axis=.85,
            xlab=x_title, color=colorlist)
    
  })
  
  output$popularity <- renderText({
  
    y<-as.data.frame(dataInput())
    hair <- y[which(y$Freq == max(y$Freq)), "Hair"][1]
    eye <- y[which(y$Freq == max(y$Freq)), "Eye"][1]
    hair2 <- y[which(y$Freq == min(y$Freq)), "Hair"][1]
    eye2 <- y[which(y$Freq == min(y$Freq)), "Eye"][1]
    
    paste("Most common: ", 
            paste(as.character(hair)), " hair and ", paste(as.character(eye)), 
            " eyes. Least common: ", 
            paste(as.character(hair2)), " hair and ", paste(as.character(eye2)), " eyes."
            
      )
  })
})
