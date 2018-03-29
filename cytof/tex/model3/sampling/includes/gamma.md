The prior for $\gamma_{inj}$ is $p(\gamma_{inj} = l \mid Z_{j\lin}=z, \eta^z_{ijl}) = \eta^z_{ijl}$, where $l \in \bc{1,...,L^z}$.

\begin{align*}
p(\gamma_{inj}=l \mid \y, Z_{j\lin}=z, \rest) &\propto p(\gamma_{inj}=l) \times p(y_{inj} \mid \gamma_{inj}=l, \rest) \\
&\propto p(\gamma_{inj}=l) \times p(y_{inj} \mid \mus_{zl}, \sss_{zil}, \rest) \\
%
&\propto \eta^z_{ijl} \times \N(y_{inj} \mid \mus_{zl}, \sss_{zil}) \\
&\propto \eta^z_{ijl} \times (\sss_{zil})^{-1/2}
\exp\bc{-\frac{(y_{inj} - \mus_{zl})^2}{2\sss_{zil}}} \\
\end{align*}

The normalizing constant is obtained by summing the last expression over 
$l = 1,...,L^z$. Moreover, since $l$ is discrete, a Gibbs update can be done
on $\gamma_{inj}$.
