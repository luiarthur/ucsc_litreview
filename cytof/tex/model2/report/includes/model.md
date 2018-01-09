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
"cutoff" values for sample $i$, marker $j$.  For a particular cell ($n$) in
sample $i$, a marker expressions level above the cutoff value $c_{ij}$ for
sample $i$ and marker $j$ indicates that marker $j$ is most likely expressed. A
marker expression level below its corresponding cutoff value, indicates the
marker is not expressed.  These cutoff values are provided by the CyTOF
instrument to correct for background measurement noise picked up by the
instrument, and are positively valued. Since the expression levels for a marker
depends on the number of metals detected in a reading, and the amount of metal
ions present can vary greatly by sample and marker, a different cutoff value is
assumed for each sample and marker combination.

Let $\tilde{y}_{inj}$ be the expression level for sample $i$, cell $n$, marker
$j$ as measured by the CyTOF instrument. Intuitively, expression levels should
only take on positive values and higher values should correspond to higher
probabilities of expression. But due to the precision of the machine, negative
values can be recorded. In such cases, the values are truncated instead as 0
(by scientists) and can be thought of as missing as the expression levels were
so low that they could not be measured. In our modeling, rather than discarding
these values, we can treat them as missing values due to the precision of the
machinery. Specifically, these values can be treated as missing and known to
take on small (negative) values. 

We transform the data so that $y_{inj} = \log\p{\frac{\tilde{y}_{inj}}{c_{ij}}}$.
Notice that if $\tilde{y}_{inj} \le 0$, this quantity is undefined. We consequently
treat these values as missing and we define the missingness indicator
$$
m_{inj} = \begin{cases}
  %0, & \text{if } \log\p{\frac{\tilde{y}_{inj}}{c_{ij}}} < -\infty \\
  0, & \text{if } \tilde{y}_{inj} = 0 \\
  1, & \text{otherwise.}
\end{cases}
$$

That is, $m_{inj}=1$ indicates that the expression level **is missing** for
sample $i$, cell $n$, marker $j$.  Note that under this transformation (1) the
data have infinite support. (2) $y_{inj} = 0$ has a special meaning, which is
that the data take on the same value as the cutoff.  Consequently, $y_{inj} >
0$ means that the data take on values greater than the cutoff, etc. (3)
$y_{inj}$ for which $\tilde{y}_{inj} = 0$ are regarded as missing values, and are 
treated as random variables to be imputed.

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
  \label{eq:model}
\end{align}

In the first line, we model the probability of missing as a function of the
data.  Specifically, we want a higher probability of missingness to be
associated with lower expression levels. We therefore model the probability of
missing $p_{inj}$ with a logistic function of the data $y_inj$. An intercept
term for each sample and marker and a slope term for each marker are included.
In addition, we constrain the slope terms to have only positive support to
reflect that lower expression levels are more likely to be missing.

I will now explain the other parameters in the model introduced in
$(\ref{eq:model})$. Each observed expression level in sample $i$ for marker $j$
is believed to be distributed Normally centered at some value $\mu^*_{1ij}$
(which has positive support) if the marker is expressed, or $\mu^*_{0ij}$
(which has negative support) if the marker is not expressed. Likewise, their
variances are $\sigma_{ij}$ if the marker is expressed, or
$(1+\gamma^*_{0ij})\sigma^2_{ij}$ (for some positive $\gamma^*_{0ij}$) if the
marker is not expressed. $\bm Z$ which is a $J\times K$ binary matrix
is a latent binary matrix where $Z_{jk} = 1$ indicates that marker $j$ is
active in some cell-type $k$. $\lambda_{in}$ is the cell-type for cell $n$ in
sample $i$.  Note that the total possible number of cell-types is $2^J$, but as
mentioned previously, we do not enumerate all cell-types but simply learn the 
most prevalent cell-types. Therefore, $\lambda_{in}$ takes on only a finite
number of (contiguous) positive integer values.


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


