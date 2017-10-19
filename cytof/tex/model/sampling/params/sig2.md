Let $p(\sigma_i^2) \propto (\sigma_i^2)^{-a_\sigma-1} \exp(-b_\sigma/\sigma_i^2)$. 

\begin{align*}
p(\sigma_i^2 \mid -) \propto&~~ p(\sigma_i^2) 
\prod_{j=1}^J\prod_{n=1}^{N_i}
p(y_{inj} \mid \mu_{j,\lin}^*, \sigma_i^2, e_{inj}) \\
%
\propto&~~ (\sigma_i^2)^{-a_\sigma-1} \exp(-b_\sigma/\sigma_i^2)\times \\
&\prod_{j=1}^J\prod_{n=1}^{N_i}
\likeone
\times\\
&\hspace{1em}
\likezero{\lin} \\
\\
%
\propto&~~
(\sigma_i^2)^{-a_\sigma-1} \exp(-b_\sigma/\sigma_i^2)\times \\
&\prod_{j=1}^J\prod_{n=1}^{N_i}
\likezero{\lin} \\
%
\\
\end{align*}

\mhLogSpiel{{\sigma_i^2}}{{\xi_i}}

