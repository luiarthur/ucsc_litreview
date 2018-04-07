# Model 3

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
