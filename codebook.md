# Codebook
Raw data: UCI HAR dataset on Human Activity Recognition.
Detailed description of raw data has already been provided together with the UCI dataset. Please refer to their description. Here, I only describe my tidy data set and summarize files I combined together to obtain it. This codebook can be used together with README.md to clarify processing steps.

## My tidy data set `tidy.ds`
It contains mean and standard deviation measurements (aka variables) extracted from UCI HAR raw data set. Each record contains: a measurement name _x_, subject.id of the subject for which measurements were provided, values of the measurement _x_ for _six_ activities performed by the subject. A sample record in `tidy.ds` will be like this:

variable			      | subjectid	| LAY		| SITT	| STAND	| WALK	| WALKDOWNSTAIRS	| WALKUPSTAIRS

tBodyAcc-mean()-X	  | 1			    | 0.221	| 0.261	| 0.278	| 0.277	| 0.289			      | 0.255

## Necessaary files in UCI HAR dataset and steps to combine them to obtain `tidy.ds`
Note that in file names provided here, the underscore is replaced by dot (to avoid italics), so you should refer to original file names in UCI HAR data set.

1. X.train.txt and X.test.txt files: contain feature data frames. Each record in these data frames  is a feature vector of 561 features. Train and test data frames are merged to form a single data frame `X.all`, which contains totally 10299 records.
2. y.train.txt and y.test.txt : contains class/activity labels for each record. `y.train` and `y.test` are also merged to form `y.all`.
2. features.txt: contains descriptive names of features. This is used to map feature name to the corresponding variable in the feature data frame. I used `grep()` to map all feature names containing "mean" or "std" to their column indices in feature data frame so that I can __extract mean and standard deviation measurements__ to my `first.ds`. I also __renamed variables__ in `first.ds` with their descriptive names (instead of meaningless indices).
3. activity.labels.txt: used to map activity name to its class label, e.g. WALKING has label 1, WALKING UPSTAIRS has label 2. I mapped the label vector `y.all` to _activity name_ vector `y.all$act`.
4. subject_train.txt: contains subject.ids for each record in feature data frame.
5. Create a `second.ds` by pasting `first.ds` with subject ids, activity names in `y.all$act`.
6. Finally, to get mean of each  variable (aka column) in `second.ds` for each __combination of subject and activity__, a function `getMean(col)` has been defined. In `getMean()`, the main step is using `tapply()` to obtain mean for each combination. Output of `getMean()` is a _data frame_ which contains _30_ records for _30_ volunteers in original data set.  Then, we only need to use `ldply()` from __plyr__ package to get means for __all variables__ in `second.ds` and combine all the means into a single `tidy.ds`.

