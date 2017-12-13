# TODO

## Urgent

- consistency with list naming of init, prior, fixed, mcmc_out
- jointly update v and H
- implement Dahl's posterior Z summarizer

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
