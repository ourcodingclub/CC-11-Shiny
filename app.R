#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)
library(agridat) # The package where "beaven.barley" comes from
Barley <- as.data.frame(beaven.barley)

# ui.R
ui <- 
  fluidPage(
    titlePanel(title = (h4("Barley Yield", align = "center"))),
    sidebarLayout(  #Controls the layout of panels
      position = "right", #controls the position of the sidebarPanel
      sidebarPanel(h3("This is a sidebarPanel"), 
                   h4("This is smaller"),
                   selectInput("gen", "1. Select phenotype", choices = c("A" = "a","B" = "b","C" = "c","D" = "d","E" = "e","F" = "f","G" = "g","H" = "h"), selected = "a"),
                   br(),
                   selectInput("col", "2. Select histogram colour", choices = c("blue","green","red","purple","grey"), selected = "grey"),
                   br(),
                   sliderInput("bin", "Select number of histogram bins", min=1, max=25, value= c(10)),
                   br(),
                   textInput("text", "3. Enter some text to be displayed", ""),
                   tags$div(style="color:red",
                            tags$p(style = "color:blue", "EXAMPLE TEXT"),
                            tags$p("EXAMPLE TEXT"),
                            tags$a(href = "EXAMPLE", "EXAMPLE")),
                   tags$div("EXAMPLE1")
      ),
      mainPanel(
        plotOutput("myhist"),
        tableOutput("mytable"),
        textOutput("mytext")
        
      )
    )
  )



# server.R
server <- function(input, output) {
  output$myhist <- renderPlot(ggplot(Barley, aes(x = yield)) + geom_histogram(bins = input$bin, 
                                                                              fill = input$col, 
                                                                              group=input$gen, 
                                                                              data=Barley[Barley$gen == input$gen,]))
  output$mytext <- renderText(input$text)
  
  output$mytable <- renderTable(Barley %>%
                                  filter(gen == input$gen))
}

# Run the application 
shinyApp(ui = ui, server = server)
