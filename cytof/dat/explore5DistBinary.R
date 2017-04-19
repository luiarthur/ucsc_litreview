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

### SCALA FUNCTIONS ###
orderBinaryMatByRow <- S$def('m: Array[Array[Int]]', '/*scala*/
  m.sortBy(_.mkString.reverse)
/*scala*/')

orderByCol <- function(m) {
  t(orderBinaryMatByRow(t(m)))
}

unique_row_count <- S$def('m: Array[Array[Double]]', '/*scala*/
  import collection.mutable.Map
  val n = m.length
  val mapRowCount = Map[Vector[Double], Int]().withDefaultValue(0)
  m.foreach( row => mapRowCount(row.toVector) += 1 )
  mapRowCount.map( r => (r._2.toDouble +: r._1).toArray ).toArray.sortBy(z => -z.head)
/*scala*/')

topPercent <- S$def('m: Array[Array[Double]], p: Double', '/*scala*/
  val n = m.map(_.head).sum
  val cumPercent = m.map(b=>b.head).scanLeft(0.0)(_+_).tail
  val dat = m.map(d => d.tail)
  val out = cumPercent.zip(dat).takeWhile(_._1 < p * n)
  out.map(_._2)
/*scala*/')
### END OF SCALA FUNCTIONS ###

binary_plot <- function(expr, cutoff, ...) {
  trun <- (t(t(expr) - cutoff) > 0) * 1
  my.image(orderByCol(t(trun)),yaxt='n',ylab='',xlab='Cells', ...)
  axis(2,at=1:ncol(trun),label=colnames(trun),fg='grey',las=2,cex.axis=.7)
}

binary_plot(pat5_d54, pat5_d54_cutoff, main='Patient 5 Truncated Expression (d54)')
binary_plot(pat5_d70, pat5_d70_cutoff, main='Patient 5 Truncated Expression (d70)')
binary_plot(pat5_d93, pat5_d93_cutoff, main='Patient 5 Truncated Expression (d93)')

binary_plot_unique <- function(expr, cutoff, p=.2, ...) {
  trun <- (t(t(expr) - cutoff) > 0) * 1
  unq <- unique_row_count(trun)
  y <- orderByCol(t(topPercent(unq, p)))
  my.image(y,yaxt='n',ylab='',xlab='Cells', ...)
  axis(2,at=1:ncol(trun),label=colnames(trun),fg='grey',las=2,cex.axis=.7)
}

binary_plot_unique(pat5_d54, pat5_d54_cutoff)
binary_plot_unique(pat5_d70, pat5_d70_cutoff)
binary_plot_unique(pat5_d93, pat5_d93_cutoff)

binary_col_means <- function(expr, cutoff, p=.2, ...) {
  trun <- (t(t(expr) - cutoff) > 0) * 1
  colMeans(trun) > p
}

my.image(x <- cbind(
  binary_col_means(pat5_d54, pat5_d54_cutoff, p=.8),
  binary_col_means(pat5_d70, pat5_d70_cutoff, p=.8),
  binary_col_means(pat5_d93, pat5_d93_cutoff, p=.8),
  sapply(as.list(1:length(cbs)), function(i) 
           binary_col_means(cbs[[i]], cb_cutoff[[i]], p=.8)),
  sapply(as.list(1:length(pbs)), function(i) 
           binary_col_means(pbs[[i]], pb_cutoff[[i]], p=.8))
), yaxt='n', ylab='', xlab='',xaxt='n')
colnames(x) <- c(paste0('pat5_d', c(54,70,93)), 
                 names(cbs), 
                 names(pbs))
axis(2,at=1:nrow(x),label=rownames(x),fg='grey',las=2,cex.axis=.7)
axis(1,at=1:ncol(x),label=colnames(x),fg='grey',las=2,cex.axis=.6)
