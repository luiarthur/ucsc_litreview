# TODO

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
