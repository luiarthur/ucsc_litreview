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


# 29 May, 2017
$y$ is indexed by $(i,n,j)$. If only a subset of $i$ is taken for $y^{TR}$, then $N_i$
will change. Changing $N_i$ will then change the dimensions of $e$ and $\lambda$. ($e$
is indexed by $(i,n,j)$ and $\lambda$ is indexed by $(i,n)$).

Doesn't this introduce complications in computing $p(y^{TR}\mid \theta,K)$
, $p(y^{TE}\mid \theta,K)$, and $p(y\mid \theta,K)$ as the dimensions of the
data also changes the dimensions of the parameters?


# 27 May, 2017
Found typo in manual:

- 5.7 (updating $h_k$): in last line of computing acceptance probability,
  changed $\ge k$ to $= k$.

# 25 May, 2017

Created `get_I`, `get_J`, and `get_N_i` for consistent access of 
data sizes.

