For $\mus_{0l}$, let $S_{0l} = \bc{(i,n,j) : \p{Z_{j,\lin} = 0 ~\cap~ \gamma_{inj} = l}}$.

\newcommand\musZeroPostvarDenom{
  \frac{1}{\tau^2_0} + \sum_{S_0l} \frac{1}{{\sigma^2}^*_{0il}}
}
\newcommand\musZeroPostMeanNum{
  \frac{\psi_0}{\tau^2_0} + 
  \frac{\sum_{S_{0l}} y_{inj}}{{\sigma^2}^*_{0il}}
}

\begin{align*}
p(\mus_{0l} \mid \y, \rest) &\propto 
p(\mus_{0l} \mid \psi_0, \tau^2_0) \times p(\y \mid \mus_{0l},\rest) \\
%
&\propto
\Ind{\mus_{0ij}<0} \exp\bc{\frac{-(\mus_{0ij} - \psi_0)^2}{2\tau^2_{0}}}
\prod_{n\in S_{0l}} \exp\bc{\frac{-(y_{inj} - \mus_{0l})^2}{2{\sigma^2}^*_{i0l}}} \\
%
&\propto
\exp\bc{
  -\frac{(\mus_{0l})^2}{2}\p{\musZeroPostvarDenom} + 
  \mus_{0l}\p{\musZeroPostMeanNum}
} \\ 
& ~~~ \times \Ind{\mus_{0ij}<0} \\
\end{align*}

$$
\renewcommand\musZeroPostvarDenom{
  1 + \tau^2_0 \sum_{S_{0l}} 1/{\sigma^2}^*_{0il}
}
\renewcommand\musZeroPostMeanNum{
  \psi_0 + \tau^2_0 \sum_{S_{0l}} y_{inj} / {\sigma^2}^*_{0il}
}
\therefore \mus_{0l} \mid \y, \rest \ind \N_-\p{
  \frac{\musZeroPostMeanNum}{\musZeroPostvarDenom},
  \frac{\tau^2_0}{\musZeroPostvarDenom}
}
$$

Similarly for $\mus_{1l}$, let $S_{1l} = \bc{(i,n,j) : \p{Z_{j,\lin} = 1 ~\cap~ \gamma_{inj} = l}}$.

$$
\newcommand\musOnePostvarDenom{
  1 + \tau^2_1 \sum_{S_{1l}} 1/{\sigma^2}^*_{1il}
}
\newcommand\musOnePostMeanNum{
  \psi_1 + \tau^2_1 \sum_{S_{1l}} y_{inj} / {\sigma^2}^*_{1il}
}
\therefore \mus_{1l} \mid \y, \rest \ind \N_+\p{
  \frac{\musOnePostMeanNum}{\musOnePostvarDenom},
  \frac{\tau^2_1}{\musOnePostvarDenom}
}
$$
