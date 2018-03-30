Let $S_{0i\ell} = \bc{(i, n,j): Z_{j,\lin} = 0 ~\cap~ \gamma_{inj}=\ell}$, $i=1, \ldots, I$.

\begin{align*}
p(\sss_{0i\ell} \mid \y, \rest) &\propto p(\sss_{0i\ell} \mid s_i) \times p(\y \mid \sss_{0i\ell}, \rest) \\
&\propto (\sss_{0i\ell})^{-a_\sigma-1} \exp\bc{-\frac{s_i}{\sss_{0i\ell}}} 
\prod_{(i,n,j)\in S_{0i\ell}} \bc{
  \frac{1}{\sqrt{2\sss_{0i\ell}}}
  \exp\bc{\frac{-(y_{inj}-\mus_{0\ell})^2}{2\sss_{0i\ell}}}
} \\
&\propto (\sss_{0i\ell})^{-(a_\sigma + \frac{\abs{S_{0i\ell}}}{2})-1}
\exp\bc{\p{\frac{1}{\sss_{0i\ell}}}\p{s_i + \sum_{(i,n,j)\in S_{0i\ell}}
\frac{(y_{inj}-\mus_{0\ell})^2}{2}
}}.
\end{align*}

$$
\therefore \sss_{0i\ell} \mid \y, \rest \ind
\IG\p{a_\sigma + \frac{\abs{S_{0i\ell}}}{2}, ~~ s_i + \sum_{(i,n,j)\in S_{0i\ell}}
\frac{(y_{inj}-\mus_{0\ell})^2}{2}
}.
$$

Similarly, let
$S_{1i\ell} = \bc{(i, n,j): Z_{j,\lin} = 1 ~\cap~ \gamma_{inj}=\ell}$. Then,
the full conditional for $\sss_{1i\ell}$ is
$$
\therefore \sss_{1i\ell} \mid \y, \rest \ind
\IG\p{a_\sigma + \frac{\abs{S_{1i\ell}}}{2}, ~~ s_i + \sum_{(i,n,j)\in S_{1i\ell}}
\frac{(y_{inj}-\mus_{1\ell})^2}{2}
}.
$$

