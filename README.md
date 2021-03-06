Getting and Cleaning Data Course Project Assignment
===================================================

This project downloads and summarizes the 
[Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) data set from University of California Irvine.

It makes use of the [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html) and [data.table](https://cran.r-project.org/web/packages/data.table/index.html) packages, and was developed on R version 3.2.3.

Running `run_analysis.R` will download and extract the dataset into a folder `UCI HAR Dataset` in the current directory. It will then create `means_by_subject_and_activity.csv`, containing the output from the script as described in CodeBook.md.
