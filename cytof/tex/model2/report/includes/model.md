The model and prior specifications are presented in this section.  Note that
the dIBP will be used in the prior specifications.  Some notation which will be
used throughout this paper is first presented.

## Notation

Let $I$ represent the number of samples.  Let $N_i$ represent the number of
cells in sample $i$, where $i = 1,2,...,I$.  Let $J$ represent the number of
markers.  Hence, the raw data $\tilde{y}_{inj}$ represent the raw data for
sample $i$, cell $n$, and marker $j$. From a computation perspective, a
suitable data structure for the data could be a list (of length $I$) of
matrices of (variable) dimensions ($N_i \times J$).  Let $c_{ij}$ denote the
"cutoff" values (provided by the cytometry measuring devices) for sample $i$,
marker $j$. And define the missingness indicator

$$
m_{inj} = \begin{cases}
  0, & \text{if } \log\p{\frac{\tilde{y}_{inj}}{c_{ij}}} < -\infty \\
  1, & \text{otherwise.}
\end{cases}
$$

That is, $m_{inj}=1$ indicates that the expression level **is missing** for sample $i$, cell $n$, marker $j$. Furthermore, define a transformation of the data

$$
y_{inj} = \begin{cases}
  \log\p{\frac{\tilde{y}_{inj}}{c_{ij}}}, & \text{if }  m_{inj} = 0\\
  \text{To be imputed}, & \text{if } m_{inj} = 1. \\
  \end{cases}
$$

This transformation will be used in the final model.  Note that under this
transformation (1) the data have infinite support. (2) $y_{inj} = 0$ has a
special meaning, which is that the data take on the same value as the cutoff.
Consequently, $y_{inj} > 0$ means that the data take on values greater than the
cutoff, etc. (3) $y_{inj}$ for which $\tilde{y}_{inj} = 0$ are regarded as
missing, and is to be imputed.

## Model

Based on the notation presented above, we are now ready to present the sampling 
distribution.

\begin{align}
  m_{inj} \mid p_{inj}, y_{inj} &\sim \Bern(p_{inj}) \nonumber \\
  \logit(p_{inj}) &:= \beta_{0ij} - \beta_{1j}~y_{inj} \nonumber \\
  \nonumber \\
  y_{inj} \mid \mu_{inj}, \gamma_{inj}, \sigma^2_{ij}, \bm Z, \lin
  &\sim \N(\mu_{inj}, (\gamma_{inj}+1) \sigma^2_{ij}) \nonumber \\
  \mu_{inj} &:= \mu^*_{Z_{j\lin}ij} \nonumber\\
  \gamma_{inj} &:= \gamma_{Z_{j\lin}ij}^*
\end{align}

Let $\btheta$ represent all parameters (discussed in the next section).
Let $\y$ represent $y_{inj} ~ \forall(i,n,j)$.
Let $\m$ represent $m_{inj} ~ \forall(i,n,j)$.

The resulting **likelihood** is as follows:

\begin{align*}
\mathcal{L} = p(\y, \m \mid \btheta) &= p(\m \mid \y) p(\y \mid \btheta) \\
&= \prod_{i,n,j} p(m_{inj} \mid y_{inj}, \btheta) p(y_{inj} \mid \btheta) \\
&= \prod_{i,n,j} \bc{
  p_{inj}^{m_{inj}} (1-p_{inj})^{1-m_{inj}} \times 
   \frac{1}{\sqrt{2\pi(\gamma_{inj}+1)\sigma^2_{ij}}} \exp\bc{-\frac{(y_{inj}-\mu_{inj})^2}{2(\gamma_{inj}+1)\sigma^2_{ij}}}
}
\end{align*}

The model is fully specified after priors are placed on all unknown parameters.

## Priors

The specific prior distributions (including hyper-parameters) are included here.

\begin{align*}
\beta_{1j} &\sim \G(90, 30) ~~~~ \text{(mean=3, var=0.1)} \\
\beta_{0ij} \mid \bar\beta_{0j} &\sim \N(\bar\beta_{0j}, \text{var}=0.1) \\
\bar\beta_{0j} &\sim \N(-11, \text{var}=0.1) \\
\\
\gamma_{1ij}^* &:= 0 \\
\gamma_{0ij}^* &\sim \IG(6, 10) ~~~~ \text{(mean=2, var=1)} \\
\sigma^2_{ij} &\sim \IG(2, 1) ~~~~ \text{(mean=1, var=$\infty$)} \\
\mus_{0ij} \mid \psi_0, \tau^2_0 &\sim \N_-(\psi_0, \tau^2_0) \\
\mus_{1ij} \mid \psi_1, \tau^2_1 &\sim \N_+(\psi_1, \tau^2_1) \\
\psi_{0} &\sim \N_-(-3, 4) \\
\psi_{1} &\sim \N_+(3, 4) \\
\tau^2_{0} &\sim \IG(2, 1) \\
\tau^2_{1} &\sim \IG(2, 1) \\
\\
v_k &\sim \Be(\alpha=1, 1) \\
\pi_k &:= \prod_{l=1}^k v_l \\
\h_k &\sim \N(\bm{0}, \bm G=\I_J) \\
Z_{jk} \mid h_{jk}, v_{1,...,k} &:=
\Ind{\pi_k > \Phi\p{\frac{h_{jk} - 0}{\sqrt{G_{jj}}}}} \\
\\
p(\lin=k \mid \bm W_i) &= W_{ik} \\
\bm W_{i} &\sim \Dir(1/K, ..., 1/K) \\
\end{align*}


