#ifndef Fixed_H
#define Fixed_H

#include <Rcpp.h>

struct Fixed {
  bool beta_0 = false;
  bool beta_1 = false;
  bool missing_y = false;
  bool mus_0 = false;
  bool mus_1 = false;
  bool sig2_0 = false;
  bool sig2_1 = false;
  bool s = false;
  bool gam = false;
  bool eta_0 = false;
  bool eta_1 = false;
  bool v = false;
  bool alpha = false;
  bool H = false;
  bool lam = false;
  bool W = false;
};

//Fixed gen_fixed_obj(const Rcpp::List &init_ls) {
//  Fixed fixed;
//  
//  fixed.beta_0 = init_ls.containsElementNamed("beta_0");
//  fixed.beta_1 = init_ls.containsElementNamed("beta_1");
//  fixed.missing_y = init_ls.containsElementNamed("missing_y");
//  fixed.mus_0 = init_ls.containsElementNamed("mus_0");
//  fixed.mus_1 = init_ls.containsElementNamed("mus_1");
//  fixed.sig2_0 = init_ls.containsElementNamed("sig2_0");
//  fixed.sig2_1 = init_ls.containsElementNamed("sig2_1");
//  fixed.s = init_ls.containsElementNamed("s");
//  fixed.gam = init_ls.containsElementNamed("gam");
//  fixed.eta_0 = init_ls.containsElementNamed("eta_0");
//  fixed.eta_1 = init_ls.containsElementNamed("eta_1");
//  fixed.v = init_ls.containsElementNamed("v");
//  fixed.alpha = init_ls.containsElementNamed("alpha");
//  fixed.H = init_ls.containsElementNamed("H");
//  fixed.lam = init_ls.containsElementNamed("lam");
//  fixed.W = init_ls.containsElementNamed("W");
//  
//  return fixed;
//}

#endif
