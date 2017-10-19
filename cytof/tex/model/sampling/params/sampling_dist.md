$$
\begin{array}{lcl}
p(y_{inj} \mid \mus_{j,\lin}, \sigma^2_i, e_{inj}) &=&
\begin{cases}
\delta_0(y_{inj}) & \text{if } e_{inj}=1 \\
\TNpdm{y_{inj}}{\mus_{j,\lin}}{\sigma_i}{}, & \text{if } e_{inj}=0 \\
\end{cases}
\\
\\
e_{inj} \mid z_{j,\lin}=0,\pi_{ij} &\sim& \Bern(\pi_{ij}) \\
e_{inj} \mid z_{j,\lin}=1          &:=& 0 \\
\end{array}
$$


