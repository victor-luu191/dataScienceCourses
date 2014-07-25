=========== 
# Getting and Cleaning Data's project
The full script  can be found in run_analysis.R

### TAsk 1. Merge train and test sets into a single data set (self-explained code)
After loading raw train and test data sets and merging them together, we got feature data set `X.all` and label vector `y.all`

### Task 2. Extract measurements of mean and standard deviations:
1. Load `code.book` 
2. Extract mean and standard measurements by first getting their indices from codebook by `grep()` then extracting corresponding columns

  2.1) Extract mean variables: 
```
mean.var.codes <- grep(code.book$feature, pattern = "mean") 
mean.ds <- X.all[ ,mean.var.codes]
```
  2.2) Here I went ahead step 4 and rename variables in `mean.ds`, notice that we need to pass `value = T` to `grep()` to get values instead of indices.
```
mean.var.names <- grep(code.book$feature, pattern = "mean", value = T)
names(mean.ds) <- mean.var.names
```
  2.3) Proceed similarly for standard deviation variables to get `std.ds`
  2.4) Bind `mean.ds` and `std.ds` to get `first.ds`

### Task 3. Replace encoded class label in `y.all` by descriptive activity names (self-explained code)
### Task 4. Label the data set by descriptive variable names (already done in step 2) 
### Task 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject
* Get train and test ids from `train/subject_train.txt` and `test/subject_test.txt` and bind them together to get all subject `ids`. 
* Now I create a second data set where I pasted togethere subject ids, activity labels, mean and standard deviation variables (from `first.ds`)

```
second.ds <- data.frame("subject.id" = ids$V1, "activity" = y.all$act, stringsAsFactors = F)
second.ds <- cbind(second.ds, first.ds)
```
* Get average of each variable for each activity and each subject:
  * Define a function `getMean(col)` to get avg for a given variable for _each combination_ of activity and subject using `tapply()`. Note that output of `getMean()` is a _data frame_.

```
getMean <- function(col) {
  tmp.res <- tapply(second.ds[ ,col], INDEX = second.ds[ ,1:2], mean)
  tmp.df <- as.data.frame(tmp.res)
  res <- data.frame("variable" = names(second.ds)[col], "subject.id" = 1:nrow(tmp.df))
  cbind(res, tmp.df)
}
```

  * Apply the function `getMean()` to all columns containing mean and standard variables of `second.ds` (columns from 3 onwards). Here I used `ldply()` from package __plyr__ (which is convenient for controlling various kinds of outputs and also has a decent option for estimating time to complete, especially important for large data sets).
```
require(plyr)
tidy.ds <- ldply(3:ncol(second.ds), getMean, .progress = "time")
```

  
