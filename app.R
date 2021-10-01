# If Shiny is not installed
# install.packages("shiny")
# Other installations:
# install.packages("leaflet")
# install.packages("sf")

# to run app (the "shinyapp" folder should be in working directory)
# library(shiny)
# runapp("shinyapp")

library(shiny)
library(leaflet)
library(sf)



ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Choose SHP File", accept = ".shp"),
      checkboxInput("header", "Header", TRUE),
      fileInput("file2", "Choose CSV File", accept = ".csv"),
      checkboxInput("header", "Header", TRUE)
    ),
    mainPanel(
      tableOutput("contents")
    )),
  leafletOutput("mymap"),
  p(),
  actionButton("recalc", "New points")
)

server <- function(input, output, session) {
  
  points <- eventReactive(input$recalc, {
    cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
  }, ignoreNULL = FALSE)
  
  output$contents <- renderTable({
    file <- input$file1
    ext <- tools::file_ext(file$datapath)
    
    req(file)
    validate(need(ext == "shp", "Please upload a shp file"))
    
    ff <- st_read(file)
    file2 <- input$file2
    ext <- tools::file_ext(file2$datapath)
    req(file)
    validate(need(ext == "csv", "Please upload a csv file"))
    csv_data <- read.csv(file2)
    pal <- colorNumeric(
      palette = "Blues",
      domain = csv_data)
    
  })
  
  output$mymap <- renderLeaflet({
    for (each in ff$geometry) {
      fillcolor <- 
    leaflet() %>%
      addPolygons(data = each, fill=TRUE, color = ~pal(each), weight = 1, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.5)
  }
  })
}

shinyApp(ui, server)