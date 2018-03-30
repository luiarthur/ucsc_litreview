The prior for $\gamma_{inj}$ is $p(\gamma_{inj} = \ell \mid Z_{j\lin}=z, \eta^z_{ij\ell}) = \eta^z_{ij\ell}$, where $\ell \in \bc{1,...,L^z}$.

\begin{align*}
p(\gamma_{inj}=\ell \mid \y, Z_{j\lin}=z, \rest) &\propto p(\gamma_{inj}=\ell) \times p(y_{inj} \mid \gamma_{inj}=\ell, \rest) \\
&\propto p(\gamma_{inj}=\ell) \times p(y_{inj} \mid \mus_{z\ell}, \sss_{zi\ell}, \rest) \\
%
&\propto \eta^z_{ij\ell} \times \N(y_{inj} \mid \mus_{z\ell}, \sss_{zi\ell}) \\
&\propto \eta^z_{ij\ell} \times (\sss_{zi\ell})^{-1/2}
\exp\bc{-\frac{(y_{inj} - \mus_{z\ell})^2}{2\sss_{zi\ell}}} \\
\end{align*}

The normalizing constant is obtained by summing the last expression over 
$\ell = 1,...,L^z$. Moreover, since $\ell$ is discrete, a Gibbs update can be done
on $\gamma_{inj}$.
