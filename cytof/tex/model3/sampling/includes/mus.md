For $\mus_{0\ell}$g, let
$S_{0i\ell} = \bc{(i,n,j) : \p{Z_{j,\lin} = 0 ~\cap~ \gamma_{inj} = \ell}}$g and $|S_{0i\ell}|$ the cardinality of $S_{0i\ell}$.

\newcommand\musZeroPostvarDenom{
  \frac{1}{\tau^2_0} + \sum_{i=1}^I\frac{|S_{0i\ell}|}{{\sigma^2}^\star_{0i\ell}}
}
\newcommand\musZeroPostMeanNum{
  \frac{\psi_0}{\tau^2_0} + 
  \sum_{i=1}^I \sum_{S_{0i\ell}}  
  \frac{y_{inj}}{{\sigma^2}^*_{0i\ell}}
}

\begin{align*}
p(\mus_{0\ell} \mid \y, \rest) &\propto 
p(\mus_{0\ell} \mid \psi_0, \tau^2_0) \times p(\y \mid \mus_{0\ell},\rest) \\
%
&\propto
\Ind{\mus_{0\ell}<0} \exp\bc{\frac{-(\mus_{0\ell} - \psi_0)^2}{2\tau^2_{0}}}
\prod_{i=1}^I\prod_{(i,n,j)\in S_{0i\ell}} \exp\bc{\frac{-(y_{inj} - \mus_{0\ell})^2}{2{\sigma^2}^\star_{i0\ell}}} \\
%
&\propto
\exp\bc{
  -\frac{(\mus_{0\ell})^2}{2}\p{\musZeroPostvarDenom} + 
  \mus_{0\ell}\p{\musZeroPostMeanNum}
} \\ 
& ~~~ \times \Ind{\mus_{0i\ell}<0} \\
\end{align*}

$$
\renewcommand\musZeroPostvarDenom{
  1 + \tau^2_0\sum_{i=1}^I(|S_{0i\ell}|/{\sigma^2}^\star_{0i\ell})
}
\renewcommand\musZeroPostMeanNum{
  \psi_0 + \tau^2_0 \sum_{i=1}^I\sum_{S_{0i\ell}} (y_{inj} / {\sigma^2}^\star_{0i\ell})
}
\therefore \mus_{0l} \mid \y, \rest \ind \N_-\p{
  \frac{\musZeroPostMeanNum}{\musZeroPostvarDenom},
  \frac{\tau^2_0}{\musZeroPostvarDenom}
}
$$

Similarly for $\mus_{1\ell}$g, let
$S_{1\ell} = \bc{(i,n,j) : \p{Z_{j,\lin} = 1 ~\cap~ \gamma_{inj} = \ell}}$g and $|S_{1i\ell}|$ the cardinality of $S_{1i\ell}$.

$$
\newcommand\musOnePostvarDenom{
  1 + \tau^2_1 \sum_{i=1}^I (|S_{1i\ell}|/{\sigma^2}^\star_{1i\ell})
}
\newcommand\musOnePostMeanNum{
  \psi_1 + \tau^2_1 \sum_{i=1}^I \sum_{S_{1i\ell}} (y_{inj} / {\sigma^2}^\star_{1i\ell})
}
\therefore \mus_{1l} \mid \y, \rest \ind \N_+\p{
  \frac{\musOnePostMeanNum}{\musOnePostvarDenom},
  \frac{\tau^2_1}{\musOnePostvarDenom}
}
$$

