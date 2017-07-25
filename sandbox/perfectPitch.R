dat <- read.csv("dat/perfectPitch.csv", skip=2)
dat <- dat[which(dat$Finished=="True"), tail(colnames(dat), 6)]
dat <- dat[, -ncol(dat)]
colnames(dat) <- c('byu', 'musicMaj', 'perfect', 'instrument', 'years')
pairs(dat)

pairs(dat[, c('perfect', 'instrument')]) 
table(dat[, c('perfect', 'instrument')]) 

summary( mod <- glm(perfect ~ instrument + years, family='binomial', data=dat) )
summary( mod <- glm(perfect ~ musicMaj + years, family='binomial', data=dat) )
summary( mod <- glm(perfect ~ instrument, family='binomial', data=dat) )

