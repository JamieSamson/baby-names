#Load packages
library(shiny)
library(babynames)
###UI
ui<-fluidPage(
  
  #Application title
  titlePanel("Baby name generator"),
  
  #Sidebar layout
  sidebarLayout(
    sidebarPanel(
      
      #Slider to select the number of names to show
      sliderInput("number",
                  "Number of names:",
                  min = 1,
                  max = 50,
                  value = 30),
      
      #Slider to select the age range to draw names from
      sliderInput("year",
                  "Year:",
                  min = 1880,
                  max = 2017,
                  value = 2017,sep=""),
      
      #Select input for the popularity rating
      selectInput("popularity","Popularity:",c("High","Medium","Low"),selected="High"),
      
      #Select input for the gender
      selectInput("gender","Gender:",c("M","F"),selected="M")
    ),
    
    #Table output
    mainPanel(
      tableOutput("name")
    )
  )
)

####Server
server<-function(input, output) {
  
  output$name<-renderTable(colnames=F,{
    
    #Setting up the subsets for the inputs
    d<-subset(babynames,babynames[,1]==input$year & babynames[,2]==input$gender)
    
    d<-data.frame(d)
    
    #Cutting the popularity data and binning it
    d$cat<-cut(as.numeric(d[,5]), seq(0,0.001,length=4),right=FALSE,labels=c("Low","Medium","High"))
    d<-subset(d,d$cat==input$popularity)
    
    #Return a sample of names. Determined by the slider input in the ui
    sample(d$name,size=input$number)
    
  })
  
}

#Run the application
shinyApp(ui = ui, server = server)