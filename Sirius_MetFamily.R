# Read the TSV file
data <- read.delim("canopus_compound_summary.tsv", header = TRUE, sep = "\t")

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


##generate HexCode"for annotation extracted from canopus_compound_summary.xlsx
# Read the file into a data frame
df <- read.table("canopus_compound_summary_annot.tsv", header = FALSE, sep = "\t")

# Add "AnnotationColors={HexCode}" to the first row of the third column
df[1, 25] <- "AnnotationColors={HexCode}"

# Copy the 8th column, Remove duplicates and exclude the first row
uniqueAnnotions <- unique(df[2:nrow(df), 8])

# Add "=" after each element of uniqueAnnotions
uniqueAnnotions <- paste0(uniqueAnnotions, "=")

# Add a random string from the given list to each element of uniqueAnnotions
strings_list <- c("#000000", "#FFFFFF", "#FF0000", "#00FF00", "#0000FF", "#FFFF00", "#FF00FF", "#00FFFF", "#800000", "#008000", "#000080", "#808000", "#800080", "#008080", "#808080", "#C0C0C0", "#FFA500", "#FFC0CB", "#FFD700", "#A52A2A")
uniqueAnnotions <- paste0(uniqueAnnotions, sample(strings_list, length(uniqueAnnotions), replace = TRUE))

# Format uniqueAnnotions into a single line with comma-separated values
unqAntHexs <- paste(uniqueAnnotions, collapse = ", ")

# Replace "HexCode" in the first row of the third column with unqAntHexs
df[1, 25] <- gsub("HexCode", unqAntHexs, df[1, 25])

# Write the updated data frame to the file
write.table(df, "canopus_compound_summary_annot_Hex.tsv", sep = "\t", row.names = FALSE, col.names = FALSE)


###converting inputFile <- "PrecursorMatrix.csv" to "PrecursorMatrix.tsv"
# Install the necessary packages if you haven't already
if (!requireNamespace("data.table", quietly = TRUE)) {
  install.packages("data.table")
}

library(data.table)

# Set the file paths
inputFile <- "PrecursorMatrix.csv"
outputFile <- "PrecursorMatrix.tsv"

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



###copy the hex color code for annotations to PrecursorMatrix
# Read the content of canopus_compound_summary_annot_Hex.tsv
df_hex <- read.table("canopus_compound_summary_annot_Hex.tsv", header = FALSE, sep = "\t")

# Copy the cell [1, 25] which contains the the hex color code for annotations
annotation_colors <- df_hex[1, 25]

# read.delim() instead of read.table() to read the tab-delimited file.
precursor_matrix <- read.delim("PrecursorMatrix.tsv", header = FALSE, sep = "\t")

# Replace the content of cell [3, 2] with annotation_colors
precursor_matrix[2, 3] <- annotation_colors

# Write the updated data frame to the file
write.table(precursor_matrix, "PrecursorMatrix_hex.tsv", sep = "\t", row.names = FALSE, col.names = FALSE)

###worked
#perform the lookup and update for all values in the fourth column (V4) of precursor_matrix
# Read the TSV files
canopus_summary <- read.delim("canopus_compound_summary_annot_Hex.tsv", header = FALSE)
precursor_matrix <- read.delim("PrecursorMatrix_hex.tsv", header = FALSE)

# Iterate through all values in the fourth column (V4) of precursor_matrix, excluding first three rows
for (i in 4:nrow(precursor_matrix)) {
  # Perform the lookup
  matching_indices <- which(canopus_summary$V2 == precursor_matrix$V4[i])
  
  # Check if any matches were found
  if (length(matching_indices) > 0) {
    # Update PrecursorMatrix (assuming V3 is the column to be updated)
    precursor_matrix[i, "V3"] <- canopus_summary[matching_indices[1], "V8"]
  } else {
    # Handle the case where no match was found (you can add custom logic here)
    warning(paste("No match found for row", i, "in PrecursorMatrix"))
  }
}

# Save the updated PrecursorMatrix as a new TSV file containing the annotation from sirius  (Canopus)
write.table(precursor_matrix, file = "PrecursorMatrix_hex_annot.tsv", sep = "\t", row.names = FALSE, col.names = FALSE)
