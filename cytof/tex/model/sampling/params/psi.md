$\psi_j$ has prior distribution $\psi_j \sim \N(m_\psi, s^2_\psi)$.
So, its full conditional is 

$$
\begin{split}
p(\psi_j \mid \y, \rest) \propto&~~ p(\psi_j) \times 
\prod_{k=1}^K 
p(\mu_{j,k}\mid \psi_j, \tau_j^2, z_{j,k}) \\
%
\propto&~~ \exp\bc{-\frac{(\psi_j-m_\psi)^2}{2s^2_\psi}} \times 
\\
&~~
\prod_{k=1}^K
\pmugtc[z_{jk}=1]{k}
\times \\
&\hspace{2em}
\pmultc[z_{jk}=0]{k}
\end{split}
$$

\mhSpiel{\psi_j}


