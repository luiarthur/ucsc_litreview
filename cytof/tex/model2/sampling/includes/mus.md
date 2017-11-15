For $\mus_{j0}$, let $S = \bc{(i,n)\colon Z_{j,\lin} = 0}$.

\begin{align*}
p(\mus_{j0} \mid \y, \rest) &\propto 
p(\mus_{j0} \mid \psi_0, \tau^2_0) \times p(\y \mid \mus_{j0},\rest) \\
&\propto
\exp\bc{\frac{-(\mus_{j0} - \psi_0)^2}{2\tau^2_{j0}}} \Ind{\mus_{j0}<0}
\prod_{(i,n)\in S} \exp\bc{\frac{-(y_{inj} - \mus_{j0})^2}{2(\gamma_{inj}+1)\sigma^2_{ij}}} \\
\end{align*}


$$
\def\musZeroPostvarDenom{
  \frac{1}{\tau^2_0} + \sum_{(i,n)\in S}\frac{1}{(\gamma_{inj}+1)\sigma^2_{ij}}
}
\def\musZeroPostMeanNum{
  \frac{\psi_0}{\tau^2_0} + 
  \sum_{(i,n)\in S} \frac{y_{inj}}{(\gamma_{inj}+1)\sigma^2_{ij}}
}
\therefore \mus_{j0} \ind \N_-\p{
  \frac{\musZeroPostMeanNum}{\musZeroPostvarDenom},
  \frac{1}{\musZeroPostvarDenom}
}
$$

Similarly for $\mus_{j1}$,
$$
\def\musOnePostvarDenom{
  \frac{1}{\tau^2_1} + \sum_{(i,n)\in S}\frac{1}{(\gamma_{inj}+1)\sigma^2_{ij}}
}
\def\musOnePostMeanNum{
  \frac{\psi_1}{\tau^2_1} + 
  \sum_{(i,n)\in S} \frac{y_{inj}}{(\gamma_{inj}+1)\sigma^2_{ij}}
}
\therefore \mus_{j1} \ind \N_+\p{
  \frac{\musOnePostMeanNum}{\musOnePostvarDenom},
  \frac{1}{\musOnePostvarDenom}
}
$$


