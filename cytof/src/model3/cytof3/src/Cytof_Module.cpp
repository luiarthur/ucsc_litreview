#include <Rcpp.h>
using namespace Rcpp;

#include "State.h"

//' @export Foo
struct Foo {
  double x;
  std::vector<NumericMatrix> y;
  Foo(double x_, std::vector<NumericMatrix> y_) : x(x_), y(y_) {}
};

RCPP_MODULE(Cytof_Module) {
  class_<Foo>("Foo")
    .constructor<double, std::vector<NumericMatrix>>()
    .field("x", &Foo::x)
    .field("y", &Foo::y)
  ;
}

/*** R
## The following is R code.
require(cytof3)
library(Rcpp)
show(Bar)
new(Bar)
b <- new(Bar, 10); b$x <- 10
b_persist <- list(stats=b$stats(), x=b$x)
rm(b)

#f = new(Foo)
#f$x = 1
x = 2
y = list(matrix(0, 3,5), matrix(1:4, 2, 2))

f = new(Foo, x=x, y=y)
f$x
f$x = 33
f$x
f$y
*/
