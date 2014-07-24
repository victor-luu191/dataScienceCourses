library("plyr")
setwd("data/")
read.table("UCI_HAR_Dataset/train/X_train.txt", as.is=T) -> X.train 
read.table("UCI_HAR_Dataset//train/y_train.txt", as.is=T) -> y.train
read.table("UCI_HAR_Dataset//test/X_test.txt", as.is=T) -> X.test
read.table("UCI_HAR_Dataset//test/y_test.txt", as.is=T) -> y.test
## 1.1) Merge data================================================================
rbind(X.train, X.test) -> X.all
rbind(y.train, y.test) -> y.all
## 1.2) Read codebook ====
read.table("UCI_HAR_Dataset//features.txt", sep=" ", as.is = T) -> code.book
names(code.book) <- c("code", "feature")

## 2) Extract measurements of mean and standard deviation ====
# 2.1) Get codes (e.g. column indices) of mean measurements and use the codes to extract mean measurements ====
mean.var.codes <- grep(code.book$feature, pattern = "mean") 
mean.ds <- X.all[ ,mean.var.codes]
# rename variables by descriptive names (here I went ahead and done step 4)
mean.var.names <- grep(code.book$feature, pattern = "mean", value = T)
names(mean.ds) <- mean.var.names

# 2.2) Do similarly for standard deviation measurements ====
sd.var.codes <- grep(code.book$feature, pattern = "std")
std.ds <- X.all[ ,sd.var.codes]
sd.var.names <- grep(code.book$feature, pattern = "std", value = T)
names(std.ds) <- sd.var.names

# 2.3) bind them together to form the first data set ====
first.ds <- cbind(mean.ds, std.ds)

## 3) Use descriptive act names instead of coded labels ====
activity.names <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
y.all$act <- laply(y.all, function(label) activity.names[label])
first.ds$act <- y.all$act
## 4) Label the first data set with descriptive variable names (already done in step 2)====

## 5) Create tidy data set with avg of each variable  ====
# 5.1 Map class label to activity name

train.ids <- read.table("UCI_HAR_Dataset//train/subject_train.txt")
test.ids <- read.table("UCI_HAR_Dataset//test/subject_test.txt")
ids <- rbind(train.ids, test.ids)
second.ds <- data.frame("subject.id" = ids$V1, "activity" = y.all$act, stringsAsFactors = F)
second.ds <- cbind(second.ds, mean.ds, std.ds)

getMean <- function(col) {
  tmp.res <- tapply(second.ds[ ,col], INDEX = second.ds[ ,1:2], mean)
  tmp.df <- as.data.frame(tmp.res)
  res <- data.frame("variable" = names(second.ds)[col], "subject.id" = 1:nrow(tmp.df))
  cbind(res, tmp.df)
}
tidy.ds <- ldply(3:ncol(second.ds), getMean, .progress = "time")
write.table(tidy.ds, file = "tidy_ds.csv", sep = ",", col.names = T, row.names = F)

