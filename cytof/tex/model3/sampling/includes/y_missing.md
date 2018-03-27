\begin{align*}
p(y_{inj} \mid m_{inj}=1, \rest) &\propto
p(y_{inj} \mid \rest) ~
p(m_{inj} = 1 \mid y_{inj}, \rest) \\
%
&\propto
\exp\bc{\frac{-(y_{inj} - \mu_{inj})^2}{2(1+\gamma_{inj})\sigma^2_{ij}}}
p_{inj}^{m_{inj}} (1-p_{inj})^{1-m_{inj}} \\
%
&\propto
\exp\bc{\frac{-(y_{inj} - \mu_{inj})^2}{2(1+\gamma_{inj})\sigma^2_{ij}}} p_{inj} \\
%
&\propto
\exp\bc{\frac{-(y_{inj} - \mu_{inj})^2}{2(1+\gamma_{inj})\sigma^2_{ij}}}
\frac{1}{1+\exp\bc{-\beta_{ij0}+\beta_{j1}y_{inj}}} \\
\end{align*}

\mhSpiel{y_{inj}}
