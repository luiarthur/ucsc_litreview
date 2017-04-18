library(rcommon)
library(rscala)
source("myimage.R")
source("readExpression.R")

### PATH to DATA $$$
PATH <- "cytof_data_lili/cytof_data_lili/"

### PATIENT 5 DATA ###
pat5_d54 <- read.expression.file(paste0(PATH,"patients/005_D54_CLEAN.csv"))
pat5_d70 <- read.expression.file(paste0(PATH,"patients/005_D70_CLEAN.csv"))
pat5_d93 <- read.expression.file(paste0(PATH,"patients/005_D93_CLEAN.csv"))

### Read Cutoff Files ###
pat5_d54_cutoff<-read.cutoff.file(paste0(PATH,"patients/005_D54_CLEAN_cutoff.csv"))
pat5_d70_cutoff<-read.cutoff.file(paste0(PATH,"patients/005_D70_CLEAN_cutoff.csv"))
pat5_d93_cutoff<-read.cutoff.file(paste0(PATH,"patients/005_D93_CLEAN_cutoff.csv"))

### PB CUTOFF FILES ###
pb_cutoff <- read.cutoff.in.dir(paste0(PATH,"pb/"))
cb_cutoff <- read.cutoff.in.dir(paste0(PATH,"cb/"))

# Assert pb and cutoff file colnames are the same!
stopifnot(
  all(apply(sapply(pb_cutoff,names),1,function(r) length(unique(r))==1)) &&
  all(apply(sapply(cb_cutoff,names),1,function(r) length(unique(r))==1))
)

# Assert cutoff files columns names are the same!
stopifnot(
  all.equal(names(pat5_d54_cutoff), colnames(pat5_d54)) &&
  all.equal(names(pat5_d70_cutoff), colnames(pat5_d54)) &&
  all.equal(names(pat5_d93_cutoff), colnames(pat5_d54))
)


# Assert marker names are the same!
stopifnot(
  all(colnames(pat5_d54) == colnames(pat5_d70)) &&
  all(colnames(pat5_d54) == colnames(pat5_d93))
)

### READ PB ###
pbs <- read.expression.in.dir(paste0(PATH,"pb/"))
# Assert PB marker names are the same!
stopifnot(
  all(sapply(pbs,function(x) all(colnames(x) == colnames(pat5_d70))))
)

### READ CB ###
cbs <- read.expression.in.dir(paste0(PATH,"cb/"))
# Assert CB marker names are the same!
stopifnot(
  all(sapply(cbs,function(x) all(colnames(x) == colnames(pat5_d70))))
)

stopifnot(all.equal( names(cbs), names(cb_cutoff) ))
stopifnot(all.equal( names(pbs), names(pb_cutoff) ))

### MAIN ###
S <- scala()
trun <- (t(t(pat5_d54) - pat5_d54_cutoff) > 0) * 1
x <- unique(trun, MARGIN=1)
my.image(t(trun),yaxt='n',ylab='',xlab='Cells'); axis(2,at=1:ncol(x),label=colnames(x),fg='grey',las=2,cex.axis=.7)


unique_row_count <- S$def('m: Array[Array[Double]]','
  import collection.mutable.Map
  val n = m.length
  val mapRowCount = Map[Vector[Double], Int]().withDefaultValue(0)
  m.foreach( row => mapRowCount(row.toVector) += 1 )
  mapRowCount.map( r => (r._2.toDouble +: r._1).toArray ).toArray.sortBy(z => -z.head)
')

### FIXME
firstPercent <- S$def('m: Array[Array[Double]], p: Double', '
  val n = m.length
  val cumPercent = m.map(b=>b.head).scanLeft(0)(_+_).tail
  val dat = m.map(d => d.tail)
  val out = cumPercent.zip(dat).takeWhile(d => d._1 < p)
  out.map(z => z._2)
')

### TEST uniqe_rows
#unique_row_count(m)

tmp <- unique_row_count(trun)

my.image(t(tmp[1:62,-1]),yaxt='n',ylab='',xlab='Cells',main=''); axis(2,at=1:ncol(x),label=colnames(x),fg='grey',las=2,cex.axis=.7)
