Shiny App README
Table of Contents
Introduction
Instructions
Usage
File Requirements
App Components
Running the App
Result Output
Cleanup
Contact
1. Introduction
This Shiny app is designed to facilitate the processing of input files and create a modified version of the PrecursorMatrix file with canopus (Sirius) annotations.

2. Instructions
Before running the app, please follow these steps:

Upload the canopus_compound_summary.tsv and metFamily's PrecursorMatrix files.
Press 'Show canopus annotations'.
From the table, select the number of the annotation column and write it in the 'Column Number of Annotion' text box.
Press 'Creat PrecursorMatrix with canopus annotation'.
3. Usage
3.1 File Upload
The app provides two file input options:

Upload canopus_compound_summary.tsv
Upload CSV File (metFamily's PrecursorMatrix)
3.2 Show canopus annotations
Upon pressing the 'Show canopus annotations' button, the app processes the input files and creates a new file named canopus_compound_summary_annot.tsv.
A modal dialog will appear, instructing the user to select the desired annotation column from the popup table.
3.3 Create PrecursorMatrix with canopus annotation
After selecting the annotation column, pressing 'Creat PrecursorMatrix with canopus annotation' performs further processing.
The app creates additional files (canopus_compound_summary_annot_Hex.tsv, PrecursorMatrix.tsv, PrecursorMatrix_hex.tsv, PrecursorMatrix_hex_annot.tsv) and updates the PrecursorMatrix with canopus annotations.
A final modal dialog confirms the successful completion of the process.
3.4 Download PrecursorMatrix with canopus annotation
The 'Download PrecursorMatrix with canopus annotation' button allows the user to download the final modified PrecursorMatrix file (PrecursorMatrix_hex_annot.tsv).
4. File Requirements
canopus_compound_summary.tsv: Contains data for the canopus compound summary.
CSV File (metFamily's PrecursorMatrix): CSV file for metFamily's PrecursorMatrix.
5. App Components
Instructions Section: Describes the steps to follow.
File Upload Section: Allows the user to upload required files.
Show canopus annotations Button: Initiates the process of showing canopus annotations.
Select Annotation Column: Allows the user to select the annotation column.
Create PrecursorMatrix Button: Initiates the process of creating the PrecursorMatrix with canopus annotation.
Download Button: Allows the user to download the final PrecursorMatrix with canopus annotation.
Result Output Section: Displays the column headers and any messages from the app.
6. Running the App
To run the app locally:

Ensure that the required R packages (shiny and data.table) are installed.
Copy the provided code into a script or R file.
Run the script in R or RStudio.
7. Result Output
Column headers and messages are displayed in the app interface.
The final modified PrecursorMatrix file (PrecursorMatrix_hex_annot.tsv) can be downloaded using the 'Download PrecursorMatrix with canopus annotation' button.
8. Cleanup
The app performs cleanup upon closing, removing temporary files created during the processing.
Files deleted: canopus_compound_summary_annot.tsv, canopus_compound_summary_annot_Hex.tsv, PrecursorMatrix_hex.tsv, PrecursorMatrix.tsv, PrecursorMatrix_hex_annot.tsv.
9. Contact
For any questions or issues, please contact [kvahabi@ipb-halle.de/sneumann@ipb-halle.de].
