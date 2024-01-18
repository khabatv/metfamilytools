library(shiny)
library(data.table)

# Define the Shiny UI
ui <- fluidPage(

  # Application title
  titlePanel("Annotation tool for MetFamily PrecursorMatrix"),

  # Sidebar with inputs
  sidebarLayout(
    sidebarPanel(

      # Select TSV file
      fileInput("file", "Choose TSV File"),

      # Select CSV file
      fileInput("file2", "Choose CSV File", accept = c(".csv")),

      # Show annotation
      actionButton("submit_part1", "Show canopus annotations"),

      # Column number of annotation
      numericInput("column_number", "Column Number of Annotion:", value = 8),

      # Create precursor matrix with annotation
      actionButton("submit_part2", "Creat PrecursorMatrix with canopus annotation"),

      # Download precursor matrix with annotation
      downloadButton("download_part2", "Download PrecursorMatrix with canopus annotation")
    ),

    # Main panel with output
    mainPanel(
      uiOutput("headers"),
      textOutput("message")
    )
  )
)
