Let $\tau_j^2$ have prior distribution $\tau_j^2 \sim \IG(a_\tau, b_\tau)$.
So, its full conditional is 

$$
\begin{split}
p(\tau_j^2 \mid \y, \rest) \propto&~~ p(\tau_j^2) \times 
\prod_{k=1}^K p(\mu_{jk}\mid \psi_j, \tau_j^2) \\
%
\propto&~~ (\tau_j^2)^{-a_\tau-1} \exp\bc{-b_\tau/\tau_j^2} \times \\
&~~
\prod_{k=1}^K
\pmugt[z_{jk}=1]{k}
\times \\
&\hspace{4em}
\pmult[z_{jk}=0]{k}
\end{split}
$$

\mhLogSpiel{{\tau_j^2}}{{\zeta_j}}


