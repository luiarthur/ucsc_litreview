# TODO

## 18 Jan, 2017

- [x] Fix: `ll_marginal`
- [x] Fix: `loglike_marginal`
    - [x] impute stuff
- [x] Fix: `ll_p` (integrate over missing y with Monte Carlo averaging)
- [x] Fix: `update_K_theta`
    - [x] Edit the code accordingly to previous items
    - [x] Remove: `update_theta_no_K`
    - [x] Add: `update_theta_depending_on_K`
- [ ] Double check changes in `K.h`, `loglike.h`, and `theta.h`
- [x] Change: data simulation missing mechanism
- [x] Do some simulations with N=(1000,10000), prop_train=(.1,.3,.5,.9)
- [x] In `params.pdf`, fix `prob_of_missing` 
- [ ] Write up changes
    - [ ] Note that I'm also updating lambda in theta3, because W changes
    - [x] New prob of missing mechanism
    - [ ] how to sample from full conditional of theta3
    - [ ] Changes from Juhee in blue
- [x] Read `Natural_Killer_Cells_for_PeterThall_revised_references.pdf`
    - the write-up is useful
    - references 14 and 15 are useful
    - but no references to methods???
- [x] HMC
- [x] Langevin MC (consider this for cytof?)
- [ ] Think about results in: `impute.R`
- [ ] Heavy-tailed distribution (like t, Laplace) instead of Normal?


## 13 Jan, 2017

- [x] change logistic link to new link function
    - [ ] use it for CB
    - [x] simulation studies
- [x] keep a record of the proposed and current K, theta, and acceptance ratio
- [x] change priors to
      - [x] $\gamma_^*{0ij} ~ IG(\text{mean}\approx 0, \text{var}=4)$
      - [x] $\sigma_^2{ij}  ~ IG(\text{mean}=1, \text{var}<\infty)$
- [x] change proportion of "training data" in reversible jump

## By 22 Dec, 2017

- [x] Intro to problem
    - [x] Inference goals
- [x] model description
- [x] Literature review
    - [x] Cytometry
    - [x] Feature Allocation models (IBP)
- [x] Simulations studies with informative prior on beta
- [x] Don't include posterior mean for Z, only posterior estimate
- [x] Remove legends for all Z matrices
- [x] $Z_{TRUE}$ => $Z^{TR}$
- [x] Look at a few posterior distributions for $y_{inj}$
- [x] Change all bullet points to sentences
- [x] Salso doesn't work well. My method based on Salso seems to work better.
    - picking close initial value may be necessary. so, may need to combine what i did with what he did.

## Christmas
- [ ] Random K
- [ ] 6000 burn-in, 2000 samples, after thinning by 5 (i.e. B=2000, burn=1500, thin=5)
- [ ] Full conditionals in appendix
- [ ] Change beta prior based on data
- [ ] In simulation 3, set mu* closer to 0.
- [ ] Analyze real CB data
- [ ] Stick breaking construction of AIBD
- [ ] Read new papers

## Urgent

- consistency with list naming of init, prior, fixed, mcmc_out
- jointly update v and H
- implement Dahl's posterior Z summarizer
- speed up updates of some parameters like mus, gams, by not iterating through data more than once.

## Eventually

- Debug!
- Document
- Simulations
- package all plotting functions
- unit test each update


### Plan

1. Simulations
    - fixed K
    - random K
2. Analyze CB or PB only (two separate analyses)
    - fixed K
    - random K
3. Write a small report
    - background: stat and bio
    - Model
    - Simulation Study
    - CB / PB Analysis
4. Literature Review and Introduction of Prospectus

### Juhee Questions:

Q1:  Is it from a real data analysis?  Then it seems not so interesting... Can you see what is going there?  If a marker has too many missing values in many samples, we may remove the marker from analysis.  In other words, we need to do some data preprocessing before analysis.

Q2: Page 2: I see white color that is not in the color key.  What does "white" mean?

Q3: Page 3:  I thought that prob(missing) becomes almost zero for y > some value like -3 or below -3 (or even -5).  We are almost sure that y_{i,n, j} is missing since it is so small and z_{j,k}=0 with \lambda_in=k.   I see that even Y ~=-3 has relatively large prob of missing.  Do you have any insights for this?  

### Scala Implementation Notes

In Scala, creating the data for order 10000 doesn't work only using Array of
Arrays.  But using Arrays of matrices works. Strange...
