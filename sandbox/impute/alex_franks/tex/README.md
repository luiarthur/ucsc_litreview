---
title: "Review of Literature on Missing Data Imputation"
author: Arthur Lui
date: "\\today"
geometry: margin=1in
fontsize: 12pt

header-includes:
#{{{1
    - \def\fobs{f^{\text{obs}}}
#}}}1
---


# Models

Throughout, $Y_i$ is the value of observation $i$. $R_i$ is an indicator such that
$R_i=1$ if $Y_i$ is observed. $Y = (Y_1, ..., Y_N)^T$, where $N$ is the total
number of observations. $\beta = (\beta_0, \beta_1)$ are parameters in the 
missing mechanism function.

\begin{align*}
f(r_i = 1 \mid y_i, \beta) &= \text{logit}(-\beta_0 - \beta_1 y_i) 
= (1 + \exp\{\beta_0 + \beta_1 y_i\})^{-1} \\
\fobs(y_i) &= \text{Normal}(0,1)
\end{align*}

## Model I



