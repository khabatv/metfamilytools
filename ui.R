# ui.R
fluidPage(
  tags$div(
    style = "border: 1px solid #ccc; padding: 10px; margin-bottom: 20px;",
    tags$h4("Annotation tool for MetFamily PrecursorMatrix"),
    tags$li("you can add annotations from different sources using this tool, if they have identical alingment ID with Metfamily or MsDial data."),
    tags$h4("Instructions"),
    tags$ol(
      tags$li("Upload canopus_compound_summary.tsv  and metFamily's PrecursorMatrix files."),
      tags$li("Press 'Show canopus annotations'."),
      tags$li("From the table, select the number of the annotation column and write it in the 'Column Number of Annotion' text box."),
      tags$li("Press 'Creat PrecursorMatrix with canopus annotation'.")
    )
  ),
  # File inputs
  fileInput("file", "Choose TSV File"),
  fileInput("file2", "Choose CSV File", accept = c(".csv")),
  # Buttons and numeric input
  actionButton("submit_part1", "Show canopus annotations "),
  verbatimTextOutput("headers"),  # Add this line to display the column headers
  numericInput("column_number", "insert Column Number of the annotation:", value = 8),
  actionButton("submit_part2", "Creat PrecursorMatrix with canopus annotation"),
  downloadButton("download_part2", "Download PrecursorMatrix with canopus annotation"),
  textOutput("message")
)
