\begin{align*}
p(\psi_0 \mid \y, \rest) &\propto p(\psi_0) \prod_{i,j} p(\mus_{0ij} \mid \psi_0, \tau^2_0) \\
%
&\propto
\exp\bc{\frac{-(\psi_0 - \bar\psi_0)^2}{2s^2_{\psi_0}}} \times \Ind{\psi_0<0}
\prod_{i,j} \bc{
  \exp\bc{\frac{-(\mus_{0ij} - \psi_0)^2}{2\tau^2_0}} \big{/}
  \Phi\p{\frac{0-\psi_0}{\tau_0}}
} \\
&\propto 
\Ind{\psi_0 < 0} \times
\exp\bc{
  -\psi_0^2\p{\frac{\tau_0^2 + s^2_{\psi_0}IJ}{2s^2_{\psi_0}\tau^2_0}} + 
  \psi_0\p{\frac{\bar\psi_0\tau_0^2 + s^2_{\psi_0}\mus_{0\bang\bang}}{2s^2_{\psi_0}\tau^2_0}}
}
\Phi\p{\frac{-\psi_0}{\tau_0}}^{-IJ}
\end{align*}

\mhLogNegSpiel{\psi_0}{\xi}

Similarly for $\psi_1$,
$$
p(\psi_1 \mid \y, \rest) \propto
\Ind{\psi_1 > 0} \times
\exp\bc{
  -\psi_1^2\p{\frac{\tau_1^2 + s^2_{\psi_1}IJ}{2s^2_{\psi_1}\tau^2_1}} + 
  \psi_1\p{\frac{\bar\psi_1\tau_1^2 + s^2_{\psi_1}\mus_{1\bang\bang}}{2s^2_{\psi_1}\tau^2_1}}
}
\Phi\p{\frac{\psi_1}{\tau_1}}^{-IJ}
$$

\mhLogSpiel{\psi_1}{\xi}
