library(shiny)
library(data.table)

# Event handler for 'Show canopus annotations' button
observeEvent(input$submit_part1, {

  # Read the TSV file
  data <- read.delim(input$file$datapath, header = TRUE, sep = "\t")

  # Duplicate the first column and extract the Metfamily Alignment ID in the first column
  data$Duplicated_Column <- data[, 1]
  data[, 1] <- sub(".*_", "", data[, 1])

  # Change the header of the first column to "Alignment ID"
  colnames(data)[1] <- "Alignment ID"

  # Insert one empty columns before the first column with specified headers
  data <- cbind("Annotation" = character(nrow(data)), data)

  # Add a column after the last column with the header "AnnotationColors={HexCode}"
  data <- cbind(data, "AnnotationColors={HexCode}" = character(nrow(data)))

  # Save the result back to the file
  write.table(data, "canopus_compound_summary_annot.tsv", sep = "\t", row.names = FALSE)

  # Render the column headers
  output$headers <- renderText({
    data <- fread("canopus_compound_summary_annot.tsv", header = TRUE, sep = "\t")
    col_names <- colnames(data)
    col_numbers <- seq_along(col_names)
    paste(col_numbers, col_names, sep = ". ")
  })
})

# Event handler for 'Creat PrecursorMatrix with canopus annotation' button
observeEvent(input$submit_part2, {

  # Generate HexCode" for annotation extracted from canopus_compound_summary.tsv
  # Read previously generated file and perform additional processing
  df <- read.table("canopus_compound_summary_annot.tsv", header = FALSE, sep = "\t")

  # Add "AnnotationColors={HexCode}" to the first row of the 25th column
  df[1, 25] <- "AnnotationColors={HexCode}"

  # Copy the selected column by user, Remove duplicates and exclude the first row
  uniqueAnnotions <- unique(df[2:nrow(df), input$column_number])

  # Add "=" after each element of uniqueAnnotions
  uniqueAnnotions <- paste0(uniqueAnnotions, "=")

  # Add a random string from the hex color list to each element of uniqueAnnotions
  strings_list <- c("#000000", "#FFFFFF", "#FF0000", "#00FF00", "#0000FF", "#FFFF00", "#FF00FF", "#00FFFF", "#800000", "#008000", "#000080", "#808000", "#800080", "#008080", "#808080", "#C0C0C0", "#FFA500", "#FFC0CB", "#FFD700", "#A52A2A")
  uniqueAnnotions <- paste0(uniqueAnnotions, sample(strings_list, length(uniqueAnnotions), replace = TRUE))

  # Format uniqueAnnotions into a single line with comma-separated values
  unqAntHexs <- paste(uniqueAnnotions, collapse = ", ")

  # Replace "HexCode" in the first row of the 25th column with unqAntHexs
  df[1, 25] <- gsub("HexCode", unqAntHexs, df[1, 25])

  # Write the updated data frame to the file
  write.table(df, "canopus_compound_summary_annot_Hex.tsv", sep = "\t", row.names = FALSE, col.names = FALSE)


  #select the PrecursorMatrix.csv for converting to PrecursorMatrix.tsv
  inputFile <- input$file2$datapath
  outputFile <- "PrecursorMatrix.tsv"
  #converting PrecursorMatrix.
