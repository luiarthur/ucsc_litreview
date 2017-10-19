\begin{align*}
p(\mus_{jk} \mid \y,\rest) \propto&~~ p(\mus_{jk}\mid \psi_j, \tau_j^2, z_{jk}) 
\times 
\prod_{i=1,n=1}^{I,N_i}
\bc{p(y_{inj}\mid \mus_{j,\lin}, \sigma_i^2, e_{inj})}^{\Ind{\lin=k}}\\
\\
\propto&~~
\pmugtc{k}
\times \\
&~~
\pmultc{k}
\times \\
&~~\prod_{i=1}^I\prod_{n=1}^{N_i}
\likezeroc[,~\lin=k]{k}
\end{align*}

\mhSpiel{\mus_{jk}}

