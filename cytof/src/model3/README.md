# Model 3

## NOW (Due Tuesday 15 May, 2018)
- [ ] Post-pred for observed values only
    - $\tilde\eta_{0ij}^{obs} = (p^0_1,...,p^0_{L0})$
    - $\tilde\eta_{1ij}^{obs} = (p^1_1,...,p^1_{L0})$
    - Then simulate $lam=k$ from $Z$ and $W$
    - Then simulate $l$ from $k$ and $\tilde\eta^{obs}$
- [ ] edit report
- [ ] repulsive Z
- [ ] Project 2
    - Write model and intro
    - present properties of rep-FAM(through sim study, just changing Z-prior) and compare to IBP
    - prior for nu?
- [ ] Project 3
    - Write model. Explain high-level idea
- [ ] slice sample missing y
- [ ] compare against FlowSOM
    - Mention other methods in literature review
- [ ] why is beta1 so strange?
- [ ] Change missing mechanism and use slice sampling
    - use quadratic missing mechanism -> more intuitive
    - b0 controls location
    - b1 controls width
    - b2 controls height
- [x] post pred for observed y
- [x] For missing y, make prob Z_{j,lin} = 0 | data, for all (i,j) pairs
    - basically, in simulation study
        - For N in thousands, the probability of non-expression for missing y
          is all 0 or near-0.
        - For N in hundreds, that probability is usually non-zero. For a few
          cases, the probability can be up to 50%.
- [x] Summarize CB analysis
- [x] Summarize simulation study
- [x] sort yz by Wi
- [x] `heatmap.2` -> missing -> change color
- [x] in heatmap and Z, use horizontal line for grouping
- [x] in W%, add one decimal
- [x] simulation data 
- [ ] [Parallel Random Number Generation][13]
    - possible with gsl
    - possible in java / scala / kotlin with `ThreadLocalRandom`
- [ ] use ggplot for images?

## Timeline

Goal: Advancement by week of **4 June, 2018**.

- [ ] Project I (due **4 May, 2018**)
    - [ ] Implement smart initial values (due by **13 April, 2018**)
        - [x] pre-impute `y`
        - [ ] pre-compute other parameters using ad-hoc methods like kmeans, etc.
    - [ ] Adaptive MCMC  (due by **18 April, 2018**)
    - [ ] written report
        - [ ] intro
        - [ ] model description
        - [ ] simulation study (due **18 April, 2018**)
        - [ ] real data (due **25 April, 2018**)
            - [ ] CB
            - [ ] PB (healthy people in control)
- [ ] Project II (due **18 May, 2018**)
    - [ ] Repeat the above for Repulsive IBP
- [ ] Outline for Advancement Presentation (due **25 May, 2018**)
    - [ ] Project I (complete)
    - [ ] Project II (promising results)
    - [ ] Project III (outline)

## To do
- full conditionals
- feasibility of Tukey's representation for missing mechanism
    - Simulation studies for mixture models
- gradients
- Pre-compute `G` as correlation between markers across all samples?
  - Or estimate in algorithm. But what prior for `G`?
  - [Langevin Dynamics Monte Carlo / HMC][1]
      - [Stochastic gradient Langevin Dynamics][2] (uses mini-batches)
        - For the cluster labels `lambda_{i,n}`, we could simply 
          choose to update only some of the `lambda_{i,n}` at
          each iteration, similarly for `y_{i,n,j}`.
  - joint updates and their gradients
- feasibility of variational inference (this would be my preferred approach)
      - [Variational Inference - A review for Statisticians][3]
      - [Variational Inference in Non-conjugate Models ][9]
      - [Variational Bayesian Inference for Linear and Logistic Regression ][10]
      - [MCMC and Variational Inference - Bridging the Gap ][4]
      - [Mixed Membership Stochastic Blockmodels][5]
      - [Stick-breaking construction of IBP][6]
      - [Variational inference for IBP ][7]
      - [Dependent IBP][8]
      - For variational inference, code in Scala
- if not doing variational inference, use C++
- just store quantiles for memory efficiency?
- Maybe try MCMC in Scala with `ND4J` for matrices? (`ND4J` supports nd-arrays)
- [Adaptive MCMC][11]
- [Repulsive Mixtures][12]


[1]: https://arxiv.org/pdf/1206.1901.pdf
[2]: https://www.ics.uci.edu/~welling/publications/papers/stoclangevin_v6.pdf
[3]: https://arxiv.org/pdf/1601.00670.pdf
[4]: http://proceedings.mlr.press/v37/salimans15.pdf
[5]: http://www.cs.columbia.edu/~blei/papers/AiroldiBleiFienbergXing2008.pdf
[6]: http://mlg.eng.cam.ac.uk/zoubin/papers/TehGorGha07.pdf
[7]: http://ai.stanford.edu/~tadayuki/papers/doshivelez-miller-vangael-teh-aistats09.pdf
[8]: http://proceedings.mlr.press/v9/williamson10a/williamson10a.pdf
[9]: https://arxiv.org/pdf/1209.4360.pdf
[10]: https://arxiv.org/pdf/1310.5438.pdf
[11]: http://probability.ca/jeff/ftpdir/adaptex.pdf
[12]: https://arxiv.org/pdf/1204.5243.pdf
[13]: https://www.r-bloggers.com/parallel-random-number-generation-using-trng/
