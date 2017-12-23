### The Indian Buffet Process

REDO

The purpose of the review so far is to show the methods that have been used to
incorporate distance information into the CRP. The goal of this project is to
use similar ideas of incorporating distance information into the Indian buffet
process (IBP), which is a prior distribution for matrices in another typical
Bayesian nonparametrics model - the latent feature model.

One key problem in recovering the latent structure responsible for generating
observed data is determining the number of latent features. The Indian Buffet
process (IBP) provides a flexible distribution for sparse binary matrices with
infinite dimensions (i.e. finite number of rows, and infinite number of
columns).  When used as a prior distribution in a latent feature model, the IBP
can learn the number of latent features generating the observations because it
can draw binary matrices which have a potentially infinite number of columns.
We will use the IBP as a prior distribution in a Gaussian latent feature model
to recover the latent structures generating the observations @griffiths2011indian.

The IBP is a distribution for sparse binary matrices with a finite number of
rows and potentially an infinite number of columns. The process of generating a
realization from the IBP can be described by an analogy involving Indian buffet
restaurants.

Let $Z$ be an $N \times \infty$ binary matrix. Each row in $Z$ represents a
customer who enters an Indian buffet and each column represents a dish in the
buffet. Customers enter the restaurant one after another. The first customer
samples an $r=$Poisson$(\alpha)$ number of dishes, where $\alpha > 0$ is a mass
parameter which influences the final number of sampled dishes. This is
indicated in by setting the first $r$ columns of the first row in $Z$ to be $1$.
The other values in the row are set to $0$. Each subsequent customer samples
each previously sampled dish with probability proportional to its popularity.
That is, the next customer samples dish $k$ with probability $m_k/i$,
where $m_k$ is the number of customers that sampled dish $k$, and $i$ is the
current customer number (or row number in $Z$). Each customer also samples an
additional Poisson$(\alpha/i)$ number of new dishes. Once all the $N$ customers
have gone through this process, the resulting $Z$ matrix will be a draw from
the Indian buffet process with mass parameter $\alpha$. In other words, $Z \sim
\text{IBP}(\alpha)$. Note that $\alpha \propto K_+$, where $K_+$ is the final
number of sampled dishes (occupied columns). Figure 2.1 shows a draw from an
IBP(10) with 50 rows. The white squares are 1, indicating that a dish was
taken; black squares are 0, indicating that a dish was not taken.

\beginmyfig
  \includegraphics{img/ibp/ibp.pdf}
  \caption{Random draw from the Indian buffet process with $\alpha=10$ and 50 rows}
  \label{fig:ibpDraw}
\endmyfig

The probability of any particular matrix produced from this process is
\begin{equation}
  P(\bm{Z}) = \frac{\alpha^{K_+}}{\prodl{i}{1}{N} {K_1}^{(i)}!} 
              \exp\{-\alpha H_N\}\prodl{k}{1}{K_+}
              \frac{(N-m_k)!(m_k-1)!}{N!},
\end{equation}
where $H_N$ is the harmonic number, $\suml{i}{1}{N}\ds\frac{1}{i}$, $K_+$ is
the number of non-zero columns in $\bm Z$, $m_k$ is the $k^{th}$ column sum of
$\bm Z$, and $K_1^{(i)}$ is the "number of new dishes" sampled by customer $i$.

### Gibbs Sampler for Indian Buffet Process
One way to get a draw from the IBP($\alpha$) is to simulate the process
according to the description above. Another way is to implement a Gibbs sampler
(@griffiths2011indian). We can implement a Gibbs sampler to draw from the IBP
as follows:

\begin{enumerate}
  \item Start with an arbitrary binary matrix of $N$ rows
  \item For each row, $i$,
  \begin{enumerate}
    \item For each column, $k$,
    \item if $m_{-i,k}$ = $0$, delete column $k$. Otherwise,
    \item set $z_{ik}$ to $0$
    \item set $z_{ik}$ to $1$ with probability $P(z_{ik}=1|\bm{z_{-i,k}}) = \frac{m_{-i,k}}{i}$
    \item at the end of row $i$, add Poisson($\ds\frac{\alpha}{N}$) columns of $1$'s
  \end{enumerate}
  \item iterate step 2 a large number of times
\end{enumerate}
We can likewise incorporate this Gibbs sampler to sample from the posterior
distribution (@griffiths2011indian) P($\bm{Z|X}$) where $\bm Z \sim
\text{IBP}(\alpha)$ by sampling from the complete conditional
\begin{equation}
  P(z_{ik}=1|\bm{Z_{-(ik)},X})  \propto p(\bm{X|Z}) P(z_{ik}=1|\bm{Z_{-(ik)}}).
\end{equation}

The parameter $\alpha$ is often unknown, so it should be modeled. Note that the
conjugate prior for $\alpha$ is a Gamma distribution. Using a Gamma
distribution is appropriate since $\alpha$ is positive.

$$
  \begin{array}{rcl}
    \bm Z|\alpha & \sim & \text{IBP}(\alpha)\\
          \alpha & \sim & \text{Gamma}(a,b), \text{where $b$ is the scale parameter}\\
    & & \\
    p(\alpha|\bm Z) & \propto & p(\bm Z|\alpha) p(\alpha)\\
    p(\alpha|\bm Z) & \propto & \alpha^{K_+} e^{-\alpha H_N}  
                                \alpha^{a-1} e^{-\alpha/b}\\
    p(\alpha|\bm Z) & \propto & \alpha^{a+K_+-1} e^{-\alpha(1/b+H_N)}\\
  \end{array}
$$
\begin{equation}
  \alpha|\bm Z  \sim  \text{Gamma}(a+K_+, (1/b+H_N)^{-1})
\end{equation}


