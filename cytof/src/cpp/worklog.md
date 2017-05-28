# Worklog

In each of the files for the parameters, `log_fc_param_name` is the
log full conditional (log likelihood + log prior) for the parameter. 

`update_param_name` is a function which updates the parameter.

# Progress
- [x] `Data.h`
- [x] `State.h`
- [x] `Prior.h`
- [x] `mus.h`
- [x] `psi.h`
- [x] `tau2.h`
- [x] `pi.h`
- [x] `sig2.h`
- [x] `v.h`
- [x] `H.h`
- [x] `lam.h`
- [x] `e.h`
- [x] `w.h`
- [x] `c.h`
- [x] `d.h`
- [ ] `K.h`
- [ ] `theta.h`
- [ ] `cytof.cpp`


# 27 May, 2017
Found typo in manual:

- 5.7 (updating $h_k$): in last line of computing acceptance probability,
  changed $\ge k$ to $= k$.

# 25 May, 2017

Created `get_I`, `get_J`, and `get_N_i` for consistent access of 
data sizes.

