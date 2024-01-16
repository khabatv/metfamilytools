#5.1.14 worked for short part of code. selectin column number, two action bottons, with two input and show headers ood number of canopus_compound_summary_annot.tsv  in shiny app
# move selection and action button 2 after action button 1. manual added
# added the rest of code to it and fine tune
#added onstop cleanup
#download added
#better marking
#debug and remove double quotes
#changed column 25 to 1 for fabricating new annotation from canopus
#################
#change the canopus file for producing of annotation hex to updated precursore matrix
library(shiny)
library(data.table)

# Increase maximum upload size
options(shiny.maxRequestSize = 3000 * 1024^2)  # Set to 30 MB (adjust as needed)

# Define the Shiny UI
ui <- fluidPage(
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

# server logic
server <- function(input, output) {
  # Event handler for 'Show canopus annotations' button
  observeEvent(input$submit_part1, {
    req(input$file)
    req(input$file2)
    inFile <- input$file
    if (is.null(inFile))
      return(NULL)
    
    # Read the TSV file
    data <- read.delim(inFile$datapath, header = TRUE, sep = "\t")
    # Duplicate the first column and extract the Metfamily Alignment ID in the first column
    data$Duplicated_Column <- data[, 1]
    data[, 1] <- sub(".*_", "", data[, 1])
    # Change the header of the first column to "Alignment ID"
    colnames(data)[1] <- "Alignment ID"
    # Insert one empty columns before the first column with specified headers
    data <- cbind("AnnotationColors={HexCode}" = character(nrow(data)), data)
    # Add a column after the last column with the header "AnnotationColors={HexCode}"
    #data <- cbind(data, "AnnotationColors={HexCode}" = character(nrow(data)))
    # Save the result back to the file
    write.table(data, "canopus_compound_summary_annot.tsv", sep = "\t", row.names = FALSE)
    
    # Render the column headers
    output$headers <- renderPrint({
      data <- fread("canopus_compound_summary_annot.tsv", header = TRUE, sep = "\t")
      col_names <- colnames(data)
      col_numbers <- seq_along(col_names)
      paste(col_numbers, col_names, sep = ". ")
    })
    
    # Show a modal dialog to instruct the user
    showModal(modalDialog(
      title = "canopus annotations for the metFamily's PrecursorMatrix were created successfully",
      "From the popup table, select the desired number of the annotation column and write it in the 'Column Number of Annotion' text box."
    ))
  })
  
  # Show a modal dialog to instruct the user
  observeEvent(input$submit_part2, {
    req(input$file)
    req(input$file2)
    req(input$column_number)  # Ensure column number is provided
    inFile <- input$file
    if (is.null(inFile))
      return(NULL)
    
    #select the PrecursorMatrix.csv for converting to PrecursorMatrix.tsv
    inputFile <- input$file2$datapath
    outputFile <- "PrecursorMatrix.tsv"
    #converting PrecursorMatrix.csv to PrecursorMatrix.tsv
    # Function to check and fix the file
    check_and_fix_file <- function(input_file, output_file) {
      # Read the file line by line
      file_lines <- readLines(input_file)
      # Check and fix the file
      for (i in 1:length(file_lines)) {
        line <- file_lines[i]
        fields <- unlist(strsplit(line, ","))
        # If there is only 1 field, add an empty field to the line
        if (length(fields) == 1) {
          file_lines[i] <- paste(fields, "", sep = ",")
        }
      }
      # Write the corrected file to a new location
      writeLines(file_lines, output_file)
    }
    
    # Call the function to check and fix the file
    check_and_fix_file(inputFile, outputFile)
    
    
    
    ## Perform the lookup and update for all values in the fourth column (V4) of precursor_matrix
    # Read the TSV files
    canopus_summary <- read.delim("canopus_compound_summary_annot.tsv", header = FALSE)
    precursor_matrix <- read.delim("PrecursorMatrix.tsv", header = FALSE)
    
    # Check if the selected column number is valid
    if (input$column_number < 1 || input$column_number > ncol(canopus_summary)) {
      stop("Invalid column number selected.")
    }
    
    # Iterate through all values in the fourth column (V4) of precursor_matrix, excluding first three rows
    for (i in 4:nrow(precursor_matrix)) {
      # Perform the lookup
      matching_indices <- which(canopus_summary$V2 == precursor_matrix$V4[i])
      # Check if any matches were found
      if (length(matching_indices) > 0) {
        selected_value <- canopus_summary[matching_indices[1], input$column_number]
        precursor_matrix[i, "V3"] <- selected_value
      } else {
        # Handle the case where no match was found (you can add custom logic here)
        warning(paste("No match found for row", i, "in PrecursorMatrix"))
      }
    }
    
    # Save the a new metfamily's PrecursorMatrix file containing the annotation from canopus_compound_summary
    write.table(precursor_matrix, file = "PrecursorMatrix_annot.tsv", sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)
   
   
    
    
    if (input$column_number < 1 || input$column_number > ncol(canopus_summary)) {
      stop("Invalid column number selected.")
    }
    
    ##generate HexCode"for annotation extracted from canopus_compound_summary.tsv
    # Read previously generated file and perform additional processing
    df <- read.table("PrecursorMatrix_annot.tsv", header = FALSE, sep = "\t")
    # Add "AnnotationColors={HexCode}" to the first row of the 25th column
    df[2, 3] <- "AnnotationColors={HexCode}"
    # Copy the selected column by user, Remove duplicates and exclude the first row
    #uniqueAnnotions <- unique(df[2:nrow(df), input$column_number])
    uniqueAnnotions <- unique(df[4:nrow(df), 3])
    # Add "=" after each element of uniqueAnnotions
    uniqueAnnotions <- paste0(uniqueAnnotions, "=")
    # Add a random string from the hex color list to each element of uniqueAnnotions
    strings_list <- c("#000000", "#FFFFFF", "#FF0000", "#00FF00", "#0000FF", "#FFFF00", "#FF00FF", "#00FFFF", "#800000", "#008000", "#000080", "#808000", "#800080", "#008080", "#808080", "#C0C0C0", "#FFA500", "#FFC0CB", "#FFD700", "#A52A2A")
    uniqueAnnotions <- paste0(uniqueAnnotions, sample(strings_list, length(uniqueAnnotions), replace = TRUE))
    # Format uniqueAnnotions into a single line with comma-separated values
    unqAntHexs <- paste(uniqueAnnotions, collapse = ", ")
    # Replace "HexCode" in the first row of the 25th column with unqAntHexs
    df[2, 3] <- gsub("HexCode", unqAntHexs, df[2, 3])
    # Write the updated data frame to the file
    write.table(df, "PrecursorMatrix_annot_Hex.tsv", sep = "\t", row.names = FALSE, col.names = FALSE)
    
    ###copy the hex color code form canopus_compound_summary_annot_Hex.tsv to PrecursorMatrix.tsv
    # Read the content of canopus_compound_summary_annot_Hex.tsv
    #df_hex <- read.table("canopus_compound_summary_annot_Hex.tsv", header = FALSE, sep = "\t")
    # Copy the cell [1, 25] which contains the the hex color code for annotations
    #annotation_colors <- df_hex[1, 1]
    # read.delim() instead of read.table() to read the tab-delimited file.
    #precursor_matrix <- read.delim("PrecursorMatrix.tsv", header = FALSE, sep = "\t")
    # Replace the content of cell [2, 3] with annotation_colors
    #precursor_matrix[2, 3] <- annotation_colors
    # Write the hex color codes to the PrecursorMatrix_hex.tsv
    #write.table(precursor_matrix, "PrecursorMatrix_hex.tsv", sep = "\t", row.names = FALSE, col.names = FALSE)
    
     
    # Show a modal dialog to inform the user
    showModal(modalDialog(
      title = "Done",
      "Creat PrecursorMatrix with canopus annotation"
    ))
  })
  
  # Download button for new metfamily's PrecursorMatrix file containing the annotation from canopus_compound_summary 
  output$download_part2 <- downloadHandler(
    filename = function() {
      "PrecursorMatrix_updated.tsv"
    },
    content = function(file) {
      file.copy("PrecursorMatrix_annot_Hex.tsv", file)
    }
  )
  
  # Cleanup on app close
  onStop(function() {
    files_to_delete <- c("PrecursorMatrix_annot.tsv", "PrecursorMatrix_annot_Hex.tsv",  "canopus_compound_summary_annot.tsv", "canopus_compound_summary_annot_Hex.tsv", "PrecursorMatrix_hex.tsv", "PrecursorMatrix.tsv", "PrecursorMatrix_hex_annot.tsv")
    for (file in files_to_delete) {
      file_path <- file.path(getwd(), file)
      if (file.exists(file_path)) {
        file.remove(file_path)
      }
    }
  })
}

shinyApp(ui, server)
