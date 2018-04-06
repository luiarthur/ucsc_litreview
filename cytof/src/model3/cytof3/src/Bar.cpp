#include <Rcpp.h>
using namespace Rcpp;

//' @export Bar
class Bar {
public:
  Bar(double x_) :
  x(x_), nread(0), nwrite(0) {}
  double get_x( ) {
    nread++; return x;
  }
  void set_x( double x_) {
    nwrite++; x = x_;
  }
  IntegerVector stats() const {
    return IntegerVector::create(
      _["read"] = nread,
      _["write"] = nwrite);
  }
private:
  double x; int nread, nwrite;
};

////' @export Vmat
//typedef std::vector<arma::mat> Vmat;

//' @export Foo
struct Foo {
  double x;
  std::vector<NumericMatrix> y;
  
  Foo(double x_, std::vector<NumericMatrix> y_) : x(x_), y(y_) {}
};

RCPP_MODULE(Cytof_Module) {
  class_<Bar>( "Bar" )
  .constructor<double>()
  .property( "x", &Bar::get_x, &Bar::set_x,
  "Docstring for x" )
  .method( "stats", &Bar::stats,
  "Docstring for stats")
  ;
  
  //class_<Vmat>("Vmat")
  //  .constructor<int>()
  //  
  //;
  
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
