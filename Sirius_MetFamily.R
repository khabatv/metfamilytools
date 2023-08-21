#To set the working directory interactively in R
setwd(choose.dir())

install.packages("readxl")
# Load the readxl package
library(readxl)

# Step 1: open canopus_compound_summary.xlsx and Extract the first and sixth columns
# open canopus_compound_summary.xlsx 

df <- read_excel("canopus_compound_summary.xlsx")

# Extract the first and sixth columns
df_subset <- df[, c(1, 6)]

# Write the selected columns to a text file
write.table(df_subset, file = "annot-canopus.txt", sep = "\t", row.names = FALSE)

# Step 2:read the data from file
df <- read.table("annot-canopus.txt", header = FALSE, sep = "\t")

# remove everything after the underscore in the first column
df$V1 <- gsub("_.*", "", df$V1)

# reduce one from the number left. this step is needed only for the data outputs of SIRIUS before Juley 2023 updates.
df$V1 <- as.numeric(df$V1) - 1

# save the modified data back to the same file
write.table(df, "annot-canopus.txt", quote = FALSE, sep = "\t", row.names = FALSE, col.names = FALSE)


## Step 3: generate HexCode"for annotation extracted from canopus_compound_summary.xlsx
# Read the file into a data frame
df <- read.table("annot-canopus.txt", header = FALSE, sep = "\t")

# Add "AnnotationColors={HexCode}" to the first row of the third column
df[1, 3] <- "AnnotationColors={HexCode}"

# Copy the second column and remove duplicates
col4 <- unique(df[, 2])

# Add "=" after each element of col4
col4 <- paste0(col4, "=")

# Add a random string from the given list to each element of col4
strings_list <- c("#000000", "#FFFFFF", "#FF0000", "#00FF00", "#0000FF", "#FFFF00", "#FF00FF", "#00FFFF", "#800000", "#008000", "#000080", "#808000", "#800080", "#008080", "#808080", "#C0C0C0", "#FFA500", "#FFC0CB", "#FFD700", "#A52A2A")
col4 <- paste0(col4, sample(strings_list, length(col4), replace = TRUE))

# Format col4 into a single line with comma-separated values
col5 <- paste(col4, collapse = ", ")

# Replace "HexCode" in the first row of the third column with col5
df[1, 3] <- gsub("HexCode", col5, df[1, 3])

# Write the updated data frame to the file
write.table(df, "annot-canopus.txt", sep = "\t", row.names = FALSE, col.names = FALSE)


# Step 4: join the tables PrecursorMatrix.csv and annot-canopus.txt
# Read the CSV and TXT files
precursor_matrix <- read.csv("PrecursorMatrix.csv", header = TRUE, sep = ",", row.names = NULL)
annot_canopus <- read.table("annot-canopus.txt", header = TRUE, sep = "\t")

# Load required packages
library(readxl)
library(openxlsx)
library(dplyr)
# Task 1: Convert PrecursorMatrix.csv to PrecursorMatrix.xlsx, this step has error and It must  to be done manually
precursor_matrix <- read.csv("PrecursorMatrix.csv", header = TRUE, sep = ",", row.names = NULL)
write.xlsx(precursor_matrix, "PrecursorMatrix.xlsx")

# Load required packages
library(readxl)
library(dplyr)
# Open PrecursorMatrix.xlsx
df <- read.xlsx("PrecursorMatrix.xlsx", sheet = 1)


# Copy and paste the columns to a new data frame
temp_df <- data.frame(df[, 4], df[, 3])
names(temp_df) <- c("col1", "col2")

# Save the temp_df to a text file
write.table(temp_df, "temp.txt", sep = "\t", row.names = FALSE)

library(fuzzyjoin)
library(readxl)

# Read the Excel files
annot_df <- read_excel("annot-canopus.xlsx")
temp_df <- read_excel("temp.xlsx")

# Join the tables based on fuzzy string matching of their first columns
join_df <- stringdist_left_join(temp_df, annot_df, by = "col1", max_dist = 0.1)

# Write the result to a file
write.table(join_df, "join.txt", sep = "\t", row.names = FALSE)

# Read the Excel files
precursor_df <- read.xlsx("PrecursorMatrix.xlsx", sheet = 1)
join_df <- read.table("join.txt", header = TRUE)

# Replace column 3 in precursor_df with column 4 from join_df
precursor_df[, 3] <- join_df[, 4]

# Write the result to a file
write.xlsx(precursor_df, "PrecursorMatrix_updated.xlsx", rowNames = FALSE)

library(openxlsx)

# Read the Excel files
precursor_df <- read.xlsx("PrecursorMatrix_updated.xlsx", sheet = 1)
join_df <- read.xlsx("join.xlsx", sheet = 1)

# Replace the cell value
precursor_df[2, 3] <- names(join_df)[5]

# Write the result to a file
write.xlsx(precursor_df, "PrecursorMatrix_updated.xlsx", rowNames = FALSE)

