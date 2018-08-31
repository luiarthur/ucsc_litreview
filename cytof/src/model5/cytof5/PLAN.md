# PLAN

- First make my generic MCMC Stuff
    - *possibly parallel* random number generators (using ThreadLocalRandom?)
    - `gibbs` function should be like `rnimble`
        - allows for easily-customizable monitors
    - type-safe
- Then Cytof
- Then can I make my own `nimble` in scala?
- Should use only Arrays, or find a way to interface nd-arrays with R, because
  eventually I'll need to interface with R...
- Maybe with Gibbs, instead of Maps, use explicit Monitors. Have up to 10 Monitors. Monitor should be a class with a deepcopy method.
