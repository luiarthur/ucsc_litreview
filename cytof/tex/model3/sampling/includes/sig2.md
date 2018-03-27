\begin{align*}
p(\sigma^2_{ij} \mid \y, \rest) &\propto p(\sigma^2_{ij}) p(\y \mid \sigma^2_{ij}, \rest) \\
%
&\propto (\sigma^2_{ij})^{-a_\sigma-1} \exp\bc{-\frac{b_\sigma}{\sigma^2_{ij}}} 
\prod_{n=1}^{N_i} \bc{
  \frac{1}{\sqrt{2\pi(1+\gamma_{inj})\sigma^2_{ij}}}
  \exp\bc{\frac{-(y_{inj}-\mu_{inj})^2}{2(1+\gamma_{inj})\sigma^2_{ij}}}
} \\
%
&\propto (\sigma^2_{ij})^{-(a_\sigma + \frac{N_i}{2})-1}
\exp\bc{\p{\frac{1}{\sigma^2_{ij}}}\p{b_\sigma + \sum_{n=1}^{N_i} 
\frac{(y_{inj}-\mu_{inj})^2}{2(\gamma_{inj} + 1)}
}}
\end{align*}

$$
\therefore \sigma^2_{ij} \mid \y, \rest \ind
\IG\p{a_\sigma + \frac{N_i}{2}, ~~ b_\sigma + \sum_{n=1}^{N_i} 
\frac{(y_{inj}-\mu_{inj})^2}{2(\gamma_{inj} + 1)}
}
$$
