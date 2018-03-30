<!--
Let $I$ represent the number of samples.
Let $N_i$ represent the number of cells in sample $i$, where $i = 1,2,...,I$.
Let $J$ represent the number of markers.

Let $\tilde{y}_{inj}$ represent the raw data for sample $i$, cell $n$, and marker $j$.
Let $c_{ij}$ denote the "cutoff" values (provided by scientists) for sample $i$, marker $j$.

Define the missingness indicator
$$
m_{inj} = \begin{cases}
  0, & \text{if } \log\p{\frac{\tilde{y}_{inj}}{c_{ij}}} < -\infty \\
  1, & \text{otherwise.}
\end{cases}
$$
That is, $m_{inj}=1$ indicates that the expression level **is missing** for sample $i$, cell $n$, marker $j$.

Furthermore, define a transformation of the data
$$
y_{inj} = \begin{cases}
  \log\p{\frac{\tilde{y}_{inj}}{c_{ij}}}, & \text{if }  m_{inj} = 0\\
  \text{To be imputed}, & \text{if } m_{inj} = 1. \\
  \end{cases}
$$
Note that under this transformation:

1. The data have infinite support.
2. $y_{inj} = 0$ has a special meaning, which is that the data take on the same value as the cutoff. Consequently, $y_{inj} > 0$ means that the data take on values greater than the cutoff, etc.
3. $y_{inj}$ for which $\tilde{y}_{inj} = 0$ are regarded as missing, and is to be imputed.
-->

Samples are taken from $I$ subjects, $i = 1,2,...,I$.  Sample $i$ consists of $N_i$ cells, $n=1, \ldots, N_i$ and for each cell, expression levels of $J$ markers are measured. Let $\tilde{y}_{inj} \in \mathbb{R}^+$ represent the raw measurement of an expression level of marker $j$ of cell $n$ in sample $i$. Let $c_{ij}$ denote the "cutoff" values
(provided by scientists) for sample $i$, marker $j$. We consider the logarithm transformation after scaling $\tilde{y}_{inj}$ by $c_{ij}$,
$$
y_{inj}=\log\p{\frac{\tilde{y}_{inj}}{c_{ij}}} \in \mathbb{R}.
$$
For some $(i, n, j)$, $\tilde{y}_{inj}$ is missing and we introduce a binary indicator,
$$
m_{inj} = \begin{cases}
  0, & \text{if $\tilde{y}_{inj}$ is observed,} \\
  1, & \text{if $\tilde{y}_{inj}$ is missing.}
\end{cases}
$$
That is, $m_{inj}=1$ indicates that the expression level of marker $j$ of
cell $n$ in sample $i$ \textbf{is missing}.


1. The data have infinite support.
2. $y_{inj} = 0$ has a special meaning, which is that the data take on the
   same value as the cutoff. Consequently, $y_{inj} > 0$ means that the data
   take on values greater than the cutoff, etc.
3. $y_{inj}$ for which $\tilde y_{inj} = 0$ are regarded as missing, and
   is to be imputed.


