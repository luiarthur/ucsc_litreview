Define $f_{inj}$ to be
\begin{align*}
f_{inj} &:= P(m_{inj} \mid p_{inj}, y_{inj}) \\
&= p_{inj}^{m_{inj}} (1-p_{inj})^{1 - m_{inj}} \\
&= \left(\frac{1}{1+e^{-x_{inj}}} \right)^{m_{inj}}\left(\frac{1}{1+e^{x_{inj}}} \right)^{1-m_{inj}},
\end{align*}
where
\begin{align*}
  x_{inj} &:= \begin{cases}
  \beta_{0i} - \beta_{1i}(y_{inj}-c_0)^2, & \text{if } y_{inj} < c_0\nonumber \\
  \beta_{0i} - \beta_{1i}c_1\p{y_{inj}-c_0}, & \text{otherwise}, \nonumber \\
  \end{cases}\\
\end{align*}

where $c_0$ and $c_1$ are fixed.

### Full Conditional for $\beta_{0i}$
Recall that $\beta_{0i} \iid \N(m_{\beta_0},s^2_{\beta_0})$.

\begin{align*}
p(\beta_{0i} \mid \y, \rest) &\propto
p(\beta_{0i}) \times \prod_{n=1}^{N_i} \prod_{j=1}^J f_{inj} \\
%
&\propto \exp\bc{\frac{-(\beta_{0i}-m_{\beta_0})^2}{2s^2_{\beta_0}}} \prod_{n=1}^{N_i} \prod_{j=1}^J f_{inj} \\
\end{align*}

\mhSpiel{\beta_{0i}}


### Full Conditional for $\beta_{1i}$
Recall that $\beta_{1i}\ind \G(a_{\beta_1}, b_{\beta_1})$.

\begin{align*}
p(\beta_{1i} \mid \y, \rest) &\propto
p(\beta_{1i}) \times 
\prod_{n=1}^{N_i} \prod_{j=1}^J f_{inj} \\
%
&\propto \beta_{1i}^{a_{\beta_1}-1}\exp\bc{-b_{\beta_1}\beta_{1i}} 
\prod_{n=1}^{N_i} \prod_{j=1}^J f_{inj} \\
\end{align*}

\mhLogSpiel{\beta_{1i}}{\xi}

