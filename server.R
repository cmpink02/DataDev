library(shiny)

# Rely on the 'HairEyeColor' dataset in the datasets
# package (which generally comes preloaded).
library(datasets)

# Define a server for the Shiny app
shinyServer(function(input, output) {
  
  # Allow the inputs to determine which values of the HairEyeColor dataset will be used.
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
  # In this case, I decided to use the mosaicplot layout.
  output$hairEyePlot <- renderPlot({
    x<-dataInput()
    
    if (input$transpose == 'Eye Color') {
      colorlist <- c("brown","blue","#594C26", "green") #List of eye colors used to color the plot
      y_title = "Eye Color"
      x_title = "Hair Color"
    }
    else {
      x<-t(x)
      colorlist <- c("black", "brown", "red", "#FAF0BE") #List of hair colors used to color the plot
      y_title = "Hair Color"
      x_title = "Eye Color"
    }
    
    # Render a mosaicplot with the appropriate colors
    mosaicplot(x, 
            main=c("Relationship between hair and eye color:", input$sex),
            ylab=y_title, cex.axis=.85,
            xlab=x_title, color=colorlist)
    
  })
  
  # This generates the text about the most/least common combinations.
  output$popularity <- renderText({
  
    y<-as.data.frame(dataInput())
    
    # Max --> These are the most common combinations; Pick the first in the event of a tie.
    hair <- y[which(y$Freq == max(y$Freq)), "Hair"][1]
    eye <- y[which(y$Freq == max(y$Freq)), "Eye"][1]
    
    # Min --> These are the least common combinations; Pick the first in the event of a tie.
    hair2 <- y[which(y$Freq == min(y$Freq)), "Hair"][1]
    eye2 <- y[which(y$Freq == min(y$Freq)), "Eye"][1]
    
    paste("Most common: ", 
            paste(as.character(hair)), " hair and ", paste(as.character(eye)), 
            " eyes. Least common: ", 
            paste(as.character(hair2)), " hair and ", paste(as.character(eye2)), " eyes."
            
      )
  })
})
