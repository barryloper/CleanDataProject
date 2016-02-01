Codebook Supplimental
=====================

More information may be found in the [original dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). 

The original dataset's codebook will be copied into `./UCI HAR Dataset/features_info.txt` after running run_analysis.R.

`run_analysis.R` operates only on features with "mean()" or "std()" in their name. 

Features in the output data `means_by_subject_and_activity.csv` have been grouped by subject and by activity, then averaged. Feature names correspond to those in the original data set, with the exception that the characters [-()] have been removed and the names have been coerced to camelCase. 