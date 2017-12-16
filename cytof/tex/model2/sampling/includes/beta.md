Define $f_{inj}$ to be

\begin{align*}
f_{inj} &:= P(m_{inj} = 1 \mid p_{inj}, y_{inj}) \\
&=
\bk{\frac{1}{1 + \exp(-\beta_{0ij} + \beta_{1j} y_{inj})}}^{m_{inj}}
\bk{\frac{1}{1 + \exp( \beta_{0ij} - \beta_{1j} y_{inj})}}^{1-m_{inj}} \\
\\
f_{inj} &:=
\bk{1 + \exp(-\beta_{0ij} + \beta_{1j} y_{inj})}^{-m_{inj}}
\bk{1 + \exp( \beta_{0ij} - \beta_{1j} y_{inj})}^{m_{inj}-1} \\
\end{align*}

### Full Conditional for $\beta_{1j}$
Recall that $\beta_{1j}\sim \G(a_\beta,b_\beta)$.

\begin{align*}
p(\beta_{1j} \mid \y, \rest) &\propto
p(\beta_{1j}) \times 
\prod_{i=1}^I\prod_{n=1}^{N_i} f_{inj} \\
&\propto \beta_{1j}^{a_\beta-1}\exp\bc{-b_\beta\beta_{1j}} 
\prod_{i=1}^I\prod_{n=1}^{N_i} f_{inj} \\
\end{align*}

\mhLogSpiel{\beta_{1j}}{\xi}

### Full Conditional for $\beta_{0ij}$
Recall that $\beta_{0ij} \mid \bar\beta_{0j} \sim \N(\bar\beta_{0j},s^2_{\beta_0})$.

\begin{align*}
p(\beta_{0ij} \mid \y, \rest) &\propto
p(\beta_{0ij} \mid \bar\beta_{0j}) \times 
\prod_{n=1}^{N_i} f_{inj} \\
%
&\propto \exp\bc{\frac{-(\beta_{0ij}-\bar\beta_{0j})^2}{2s^2_{\beta_0}}} \prod_{n=1}^{N_i} f_{inj} \\
\end{align*}

\mhSpiel{\beta_{0ij}}

### Full Conditional for $\bar\beta_{0j}$
Recall that $\bar\beta_{0j} \sim \N(m_\beta,s^2_\beta)$.

\begin{align*}
p(\bar\beta_{0j} \mid \y, \rest) &\propto
p(\bar\beta_{0j}) \prod_{i=1}^I p(\beta_{0ij} \mid \bar\beta_{0j}) \\
&\propto
\exp\bc{\frac{-(\bar\beta_{0j} - m_\beta)^2}{2 s^2_\beta}}
\prod_{i=1}^I \exp\bc{\frac{-(\beta_{0ij}-\bar\beta_{0j})^2}{2s^2_{\beta_0}}}
\end{align*}

Due to conjugacy,
$$
\bar\beta_{0j} \mid \y, \rest \sim \N\p{
  \frac{s^2_{\beta_0}m_\beta+s^2_{\beta}\sum_{i=1}^I\beta_{0ij}}{s^2_{\beta_0} + s^2_\beta I},
  \frac{s^2_{\beta_0} s^2_\beta}{s^2_{\beta_0} + s^2_\beta I}
}.
$$
