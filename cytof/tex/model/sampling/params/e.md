First note that for $z_{j,\lin}=1$,
$$
e_{inj} \mid (z_{j,\lin}=1, \pi_{ij}, \rest) := 0.\\
$$

For $z_{j,\lin}=0$,

\begin{align*}
p(e_{inj} = 1\mid z_{j,\lin}=0, \pi_{ij}, \rest)
=&~
\frac{
p(e_{inj}=1 \mid z_{j,\lin}=0, \pi_{ij})
\times
p(y_{inj}\mid \mus_{j,\lin}, \sigma_i^2, e_{inj}=1)
}{
\sum_{x\in\bc{0,1}}
p(e_{inj}=x \mid z_{j,\lin}=0, \pi_{ij})
\times
p(y_{inj}\mid \mus_{j,\lin}, \sigma_i^2, e_{inj}=x)
} \\
%
\\
\propto&~
\pi_{ij}\likeone
\\
\end{align*}

Similarly,
$$
p(e_{inj} = 0\mid z_{j,\lin}=0, \pi_{ij}, \rest)
\propto
(1-\pi_{ij}) \likezero{\lin}
$$


Since $\lin$ has a discrete support, its full conditional can be sampled from
by sampling one number from $1,...,K$ with probabilities proportional to the
full conditional evaluated at $k\in\bc{1,...,K}$.

