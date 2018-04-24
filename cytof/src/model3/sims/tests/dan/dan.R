library(Rcpp)
sourceCpp('dan.cpp')

### Modify vector in place ###
y = double(10)
set999(y)
addOne(y)
print(y)

### Modify array in place ###
x = array(0, c(4,3,2))
set999(x)
addOne(x)
print(x)

