This code have been designed to extracts annotation columns from Sirius outputs (before Juley 2023 updates) and integrates in to the Metfamily project file. It also, assigns the color code to the annotations terminology. It includes following steps


Setting Working Directory and Installing Package:
The working directory is set interactively using choose.dir().
The "readxl" package is installed.
The "readxl" package is loaded using library(readxl).
Step 1: Data Extraction and Manipulation:
The code reads an Excel file named "canopus_compound_summary.xlsx" using read_excel() from the "readxl" package.
The first and sixth columns of the data are extracted and stored in a new data frame df_subset.
The selected columns are written to a text file named "annot-canopus.txt" using write.table().

Step 2: Read and Modify Data from File:
The data from "annot-canopus.txt" is read into a data frame named df.
The code removes everything after the underscore in the first column of df using regular expressions (gsub() function).
For all the data files from SIRIUS before 2023 updates, one is subtracted from the numeric values in the first column of df. 
The modified data is saved back to the same "annot-canopus.txt" file using write.table().

Step 3: Generating Annotation HexCodes necessary for Metfamily.
The data from "annot-canopus.txt" is read again into the data frame df.
The code adds the text "AnnotationColors={HexCode}" to the first row of the third column (Number of color codes is limited to 20).
The unique values from the second column of df are copied, and "=" is added after each element.
A random string is appended from the provided list to each element in the previous step.
The modified values are concatenated into a single line with comma-separated values.
The "HexCode" in the first row of the third column is replaced with the modified values.
The updated data frame is written back to "annot-canopus.txt".
Step 4: Data Joining and Manipulation:

The code reads CSV file named "PrecursorMatrix.csv" (the project output from Metfamily) and a text file "annot-canopus.txt" into data frames.
Several R packages are loaded: "readxl", "openxlsx", "dplyr", "fuzzyjoin".
The "PrecursorMatrix.csv" is converted to an Excel file named "PrecursorMatrix.xlsx".
The Excel file is read into a data frame.
Columns from the data frame are selected and stored in a temporary data frame named temp_df, which is then saved to a text file named "temp.txt".
The "annot-canopus.xlsx" and "temp.xlsx" files are read into data frames.
Fuzzy string matching is performed on the "col1" column of both data frames using the "stringdist_left_join()" function from the "fuzzyjoin" package.
The resulting joined data frame is saved to a text file named "join.txt".
The data from the "join.txt" file and the "PrecursorMatrix.xlsx" file are read into data frames.
A specific column from the join result is used to update a column in the "PrecursorMatrix.xlsx" data frame.
The updated "PrecursorMatrix.xlsx" file is written.
The "PrecursorMatrix_updated.xlsx" file is read into a data frame, and a value in the data frame is replaced with a value from the "join.xlsx" file.
The final result is written back to "PrecursorMatrix_updated.xlsx".

PrecursorMatrix_updated.xlsx is ready to be uploaded in the Metfamily as a project file as it is.
