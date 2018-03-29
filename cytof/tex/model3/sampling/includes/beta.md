Define $f_{inj}$ to be

\begin{align*}
f_{inj} &:= P(m_{inj} = 1 \mid p_{inj}, y_{inj}) \\
&= p_{inj}^{m_{inj}} (1-p_{inj})^{1 - m_{inj}} \\
&=
\begin{cases}
\bk{1 + \exp\bc{-\beta_{0i} + \beta_{1i} (y_{inj}-c)^2)}}^{-m_{inj}}
\bk{1 + \exp\bc{\beta_{0i} - \beta_{1i} (y_{inj}-c)^2 }}^{m_{inj}-1} & \text{if } y_{inj} < c\\
\\
\bk{1 + \exp\bc{-\beta_{0i} + \beta_{1i} (y_{inj}-c))}}^{-m_{inj}}
\bk{1 + \exp\bc{\beta_{0i} - \beta_{1i} (y_{inj}-c) }}^{m_{inj}-1} & \text{otherwise}\\
\end{cases}
\end{align*}

### Full Conditional for $\beta_{0i}$
Recall that $\beta_{0i} \sim \N(m_{\beta_0},s^2_{\beta_0})$.

\begin{align*}
p(\beta_{0i} \mid \y, \rest) &\propto
p(\beta_{0i}) \times \prod_{n=1}^{N_i} \prod_{j=1}^J f_{inj} \\
%
&\propto \exp\bc{\frac{-(\beta_{0i}-m_{\beta_0})^2}{2s^2_{\beta_0}}} \prod_{n=1}^{N_i} \prod_{j=1}^J f_{inj} \\
\end{align*}

\mhSpiel{\beta_{0i}}


### Full Conditional for $\beta_{1i}$
Recall that $\beta_{1i}\sim \G(a_{\beta_1}, b_{\beta_1})$.

\begin{align*}
p(\beta_{1i} \mid \y, \rest) &\propto
p(\beta_{1i}) \times 
\prod_{n=1}^{N_i} \prod_{j=1}^J f_{inj} \\
%
&\propto \beta_{1i}^{a_{\beta_1}-1}\exp\bc{-b_{\beta_1}\beta_{1i}} 
\prod_{n=1}^{N_i} \prod_{j=1}^J f_{inj} \\
\end{align*}

\mhLogSpiel{\beta_{1i}}{\xi}


