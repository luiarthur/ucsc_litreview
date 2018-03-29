Let $S_{0il} = \bc{(n,j): Z_{j,\lin} = 0 ~\cap~ \gamma_{inj}=l}$.

\begin{align*}
p(\sss_{0il} \mid \y, \rest) &\propto p(\sss_{0il} \mid s_i) \times p(\y \mid \sss_{0il}, \rest) \\
%
&\propto (\sss_{0il})^{-a_\sigma-1} \exp\bc{-\frac{s_i}{\sss_{0il}}} 
\prod_{n=1}^{N_i} \prod_{j=1}^J \bc{
  \frac{1}{\sqrt{2\sss_{0il}}}
  \exp\bc{\frac{-(y_{inj}-\mus_{0l})^2}{2\sss_{0il}}}
} \\
%
&\propto (\sss_{0il})^{-(a_\sigma + \frac{\abs{S_{0il}}}{2})-1}
\exp\bc{\p{\frac{1}{\sss_{0il}}}\p{s_i + \sum_{(n,j)\in S_{0il}}
\frac{(y_{inj}-\mus_{0l})^2}{2}
}}
\end{align*}

$$
\therefore \sss_{0il} \mid \y, \rest \ind
\IG\p{a_\sigma + \frac{\abs{S_{0il}}}{2}, ~~ s_i + \sum_{(n,j)\in S_{0il}}
\frac{(y_{inj}-\mus_{0l})^2}{2}
}
$$

Similarly, let $S_{1il} = \bc{(n,j): Z_{j,\lin} = 1 ~\cap~ \gamma_{inj}=l}$.
Then, the full conditional for $\sss_{1il}$ is

$$
\therefore \sss_{1il} \mid \y, \rest \ind
\IG\p{a_\sigma + \frac{\abs{S_{1il}}}{2}, ~~ s_i + \sum_{(n,j)\in S_{1il}}
\frac{(y_{inj}-\mus_{1l})^2}{2}.
}
$$

