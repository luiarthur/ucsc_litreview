For $\mus_{0ij}$, let $S_0 = \bc{n\colon Z_{j,\lin} = 0}$.

\newcommand\musZeroPostvarDenom{
  %\frac{1}{\tau^2_0} + \sum_{n\in S_0}\frac{1}{(\gamma^*_{0ij}+1)\sigma^2_{ij}}
  \frac{1}{\tau^2_0} + \frac{\abs{S_0}}{(\gamma^*_{0ij}+1)\sigma^2_{ij}}
}
\newcommand\musZeroPostMeanNum{
  \frac{\psi_0}{\tau^2_0} + 
  %\sum_{n\in S_0} \frac{y_{inj}}{(\gamma^*_{0ij}+1)\sigma^2_{ij}}
  \frac{\sum_{n\in S_0} y_{inj}}{(\gamma^*_{0ij}+1)\sigma^2_{ij}}
}

\begin{align*}
p(\mus_{0ij} \mid \y, \rest) &\propto 
p(\mus_{0ij} \mid \psi_0, \tau^2_0) \times p(\y \mid \mus_{0ij},\rest) \\
%
&\propto
\exp\bc{\frac{-(\mus_{0ij} - \psi_0)^2}{2\tau^2_{j0}}} \Ind{\mus_{0ij}<0}
\prod_{n\in S_0} \exp\bc{\frac{-(y_{inj} - \mus_{0ij})^2}{2(\gamma_{inj}+1)\sigma^2_{ij}}} \\
%
&\propto
\exp\bc{
  -\frac{(\mus_{0ij})^2}{2}\p{\musZeroPostvarDenom} + 
  \mus_{0ij}\p{\musZeroPostMeanNum}
} \\ 
& ~~~ \times \Ind{\mus_{0ij}<0} \\
\end{align*}

$$
\renewcommand\musZeroPostvarDenom{
  (\gamma^*_{0ij}+1) \sigma^2_{ij} + \tau^2_0 \abs{S_0}
}
\renewcommand\musZeroPostMeanNum{
  (\gamma^*_{0ij}+1) \sigma^2_{ij} \psi_0 + 
  \tau^2_0 \sum_{n\in S_0} y_{inj}
}
\therefore \mus_{0ij} \mid \y, \rest \ind \N_-\p{
  \frac{\musZeroPostMeanNum}{\musZeroPostvarDenom},
  \frac{\tau^2_0 (\gamma^*_{0ij} + 1)\sigma^2_{ij}}{\musZeroPostvarDenom}
}
$$

Similarly for $\mus_{1ij}$, let $S_1 = \bc{n\colon Z_{j,\lin} = 1}$
$$
\newcommand\musOnePostvarDenom{
  \sigma^2_{ij} + \tau^2_1 \abs{S_1}
}
\newcommand\musOnePostMeanNum{
  \sigma^2_{ij} \psi_1 + 
  \tau^2_1 \sum_{n\in S_1} y_{inj}
}
\therefore \mus_{1ij} \mid \y, \rest \ind \N_+\p{
  \frac{\musOnePostMeanNum}{\musOnePostvarDenom},
  \frac{\tau^2_1 \sigma^2_{ij}}{\musOnePostvarDenom}
}
$$
