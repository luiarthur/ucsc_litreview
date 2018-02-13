dat <- read.csv("dat/perfectPitch.csv", skip=2)
dat <- dat[which(dat$Finished=="True"), tail(colnames(dat), 6)]
dat <- dat[, -ncol(dat)]
colnames(dat) <- c('byu', 'musicMaj', 'perfect', 'instrument', 'years')
pairs(dat)

pairs(dat[, c('perfect', 'instrument')]) 
table(dat[, c('perfect', 'instrument')]) 

summary( mod <- glm(perfect ~ instrument + years, family='binomial', data=dat) )
#summary( mod <- glm(perfect ~ musicMaj + years, family='binomial', data=dat) )
#summary( mod <- glm(perfect ~ instrument, family='binomial', data=dat) )

logistic = function(x) 1 / (1+exp(-x))

prob = function(years, instrument) {
  yrEffect = mod$coef['years']
  instEff = mod$coef[paste0('instrument',instrument)]
  as.numeric(logistic(mod$coef[1] + instEff + yrEffect * years))
}

yrs = seq(1,50, l=100)
plot(yrs, prob(yrs, 'Piano'), type='l', col='blue', lwd=3, ylim=c(0,1))
lines(yrs, prob(yrs, 'String'), col='red', lwd=3, ylim=c(0,1))
lines(yrs, prob(yrs, 'String'), col='red', lwd=3, ylim=c(0,1))
