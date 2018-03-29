\begin{align*}
p(y_{inj} \mid m_{inj}, \rest) &\propto
p(y_{inj} \mid \rest) ~
p(m_{inj} \mid y_{inj}, \rest) \\
%
&\propto
\exp\bc{\frac{-(y_{inj} - \mu_{inj})^2}{2\sigma^2_{inj}}}
f_{inj} \\
\end{align*}

\mhSpiel{y_{inj}}

Note that $f_{inj}$ is a function of $y_{inj}$ (equation \ref{eq:finj}) and
should be computed accordingly.
