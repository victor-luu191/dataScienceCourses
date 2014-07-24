library("RMySQL")
ucscDb <- dbConnect(MySQL(), user="genome", host = "genome-mysql.cse.ucsc.edu")
result <- dbGetQuery(ucscDb, "show databases;")
dbDisconnect(ucscDb)
head(result)

hg19 <- dbConnect(MySQL(), user = "genome", db = "hg19", host = "genome-mysql.cse.ucsc.edu")
allTabs <- dbListTables(hg19)
length(allTabs )
allTabs[1:10]
dbListFields(hg19, "affyExonProbeCore")
dbGetQuery(hg19, "select count(*) from affyExonProbeCore;")
dbReadTable(hg19, "affyU133Plus2") -> affy.tab
head(affy.tab)
affy.query <- dbSendQuery(hg19, 
                        "select * from affyU133Plus2 where misMatches between 1 and 3")
affy.sub <- fetch(affy.query)
dbClearResult(affy.query)
dbDisconnect(hg19)


