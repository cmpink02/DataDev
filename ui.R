library(shiny)

# Rely on the 'HairEyeColor' dataset in the datasets
# package (which generally comes preloaded).
library(datasets)

# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(    
    
    # Give the page a title
    titlePanel("Popularity of Hair and Eye Color Combinations by Sex?"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      
      # Define the sidebar with one input
      sidebarPanel(
        h4("Which combination would you like to see?"),
        h6("Choose below and be amazed!"),
        selectInput("sex", "MALE, FEMALE, or BOTH?", 
                    choices=c(dimnames(HairEyeColor)$Sex, "Both")),
        selectInput("transpose", "Color of EYES or HAIR?", 
                    choices=c("Eye Color", "Hair Color")),
        hr(),
        h6("Data from Snee (1974) and Friendly (2000).")
      ),
      
      # Create a spot for the mosaicplot
      mainPanel(
        plotOutput("hairEyePlot")
        
      )
      
    ),
    
    h6("Most and least popular hair/eye combinations:"),
    verbatimTextOutput("popularity")
  )
)