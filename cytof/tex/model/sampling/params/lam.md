The prior for $\lin$ is $p(\lin = k \mid \w_i) = w_{ik}$.

$$
\begin{split}
p(\lin=k\mid \y,\rest) \propto&~~ %p(\lin=k \mid \w_i)
%\times
\\
&\hspace{-8em}
w_{ik}
\prod_{j=1}^J
\bc{
  \pi_{ij}\delta_0(y_{inj}) + 
  (1-\pi_{ij})
  \TNpdm{y_{inj}}{\mus_{j,k}}{\sigma_i}{}
}^{\Ind{z_{j,k}=0}} \times \\
&\hspace{-5em}
\bc{
  \TNpdfcm{y_{inj}}{\mus_{j,k}}{\sigma_i}{} }^{\Ind{z_{j,k}=1}}
\end{split}
$$


