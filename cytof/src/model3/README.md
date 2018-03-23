# Model 3

## To do
- [ ] full conditionals
- [ ] feasibility of Tukey's representation for missing mechanism
- [ ] gradients
      - [ ] Langevin Monte Carlo
            - [ ] https://www.ics.uci.edu/~welling/publications/papers/stoclangevin_v6.pdf
            - [ ] mini-batches?
                - [ ] for the cluster labels `lambda_{i,n}`, we could simply 
                      choose to update only some of the `lambda_{i,n}` at
                      each iteration, similarly for `y_{i,n,j}`.
            - [ ] HMC?
      - [ ] joint updates and their gradients
- [ ] feasibility of variational inference (this would be my preferred approach)
      - [ ] if possible, code in Scala
- [ ] if not doing variational inference, use C++
