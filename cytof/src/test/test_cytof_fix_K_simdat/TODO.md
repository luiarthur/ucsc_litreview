# Next To Try:

## 16 Oct, 2017

- [X] plot data
    - [X] distribution of `y_{inj}` for `z_{j,\lam_{in}}=0,1` separately for each (i,j) pair.
- [X] smaller `\sigma^2_i`
- [X] change simulation data `mu*_{jk}`
- [ ] use proposal with smaller step-size for mu*
- [X] compute loglike

## 13 Oct, 2017
Note: I just change 

- `mcmc.h: dtnorm, log_dtnorm, wrapped_dtruncnotm`
- `H_mus.h`

In the posterior Z, k=1 and 3 seems alternating.  Did you assume no label switching and take simple averages over iterations?  Did you check if there is any label switching?  It may be not due to convergence.  Can you run the algorithm of finding a posterior point estimate of Z?  

For that particular simulation, I wasn't able to save the simulation data because of errors in plotting (after the MCMC). It is rerunning. 

++ Can you send me the results with sim3 & K=5?  You sent md file, not pdf file.  
I have attached the results with sim3 & K=5.

++ Currently, it seems the model would identify true K well if we let K random.  How you do think?  For current sim3 and sim4, we may try the model with random K.
I agree. I am working on this right now.

++ Smaller M-H step size is needed for smaller N.  I suggested joint updatings for possible improvement of mixing.  Tried?  Worked?
This is  running. (I hope correctly...)

## 3 Oct, 2017

### Now 
- [ ] Compute loglike every 100 steps ?
- [X] use: N = (20000, 30000, 10000)
- [ ] Use Juhee's way to get point estimate (Not urgent)
- [ ] large N -> large `cs_v`, `cs_h` (tune)
- [ ] autotune `cs_v`, `cs_h`?
- [X] Use a (true) Z with markers appearing in multiple cell types
    - i.e. each rowsum(Z) is not necessarily 1.
- [ ] Mis-specify K => what happens? 
    - Try true K=4, but fix K = {1,2,3, 5,6,7}
- [ ] Plotting for mus?

### Eventually 
- [ ] Model K


## 1 Oct, 2017
- [x] high cs_v and/or cs_h, but cs_psi = .01 as before.
