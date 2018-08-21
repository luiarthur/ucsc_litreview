# Deciding what language to use for MCMC

I think in the long run, the language decision should depend on maintainability and extensibility.

Hand-writing MCMC every time doesn't make sense, especially when considering many models.

Using STAN and NIMBLE might be a good choice. But sometimes, certain features are not supported, or
in the case of NIMBLE, data-size increases compilation time too dramatically. NIMBLE is still
a good choice for exploring models for small data.

I think in the future, students will need to know how to write a generic MCMC sampler to succeed. 
That way, they can customize to their hearts content, but still avoid writing tedious code. 
They will need to be familiar with parsers, etc.

Scala is good for generic programming and writing parsers. Julia, while it is v1.0.0, may be a good 
alternative. But doesn't have as good type-checking as Scala. Package ecosystem is also better
for Scala.

I'll try to write a Scala Bayesian model parser.
