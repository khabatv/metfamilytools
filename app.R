library(shiny)

# Load UI and server modules
source("ui.R")
source("server.R")

# Run the shiny app
shinyApp(ui = ui, server = server)
