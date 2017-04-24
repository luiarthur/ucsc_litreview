---
title: "DRAFT (after dropping $i$)"
author: Arthur Lui
date: "17 April 2017"
geometry: margin=1in
fontsize: 12pt

bibliography: ../../bib/litreview.bib
bibliographystyle: plain 

# This is how you use bibtex refs: @nameOfRef
# see: http://www.mdlerch.com/tutorial-for-pandoc-citations-markdown-to-latex.html
#{{{1
header-includes: 
    - \usepackage{bm}
    - \usepackage{bbm}
    - \usepackage{graphicx}
    - \pagestyle{empty}
    - \newcommand{\norm}[1]{\left\lVert#1\right\rVert}
    - \newcommand{\p}[1]{\left(#1\right)}
    - \newcommand{\bk}[1]{\left[#1\right]}
    - \newcommand{\bc}[1]{ \left\{#1\right\} }
    - \newcommand{\abs}[1]{ \left|#1\right| }
    - \newcommand{\mat}{ \begin{pmatrix} }
    - \newcommand{\tam}{ \end{pmatrix} }
    - \newcommand{\suml}{ \sum_{i=1}^n }
    - \newcommand{\prodl}{ \prod_{i=1}^n }
    - \newcommand{\ds}{ \displaystyle }
    - \newcommand{\df}[2]{ \frac{d#1}{d#2} }
    - \newcommand{\ddf}[2]{ \frac{d^2#1}{d{#2}^2} }
    - \newcommand{\pd}[2]{ \frac{\partial#1}{\partial#2} }
    - \newcommand{\pdd}[2]{\frac{\partial^2#1}{\partial{#2}^2} }
    - \newcommand{\N}{ \mathcal{N} }
    - \newcommand{\E}{ \text{E} }
    - \def\given{~\bigg|~}
    # Figures in correct place
    - \usepackage{float}
    - \def\beginmyfig{\begin{figure}[H]\center}
    - \def\endmyfig{\end{figure}}
    - \newcommand{\iid}{\overset{iid}{\sim}}
    - \newcommand{\ind}{\overset{ind}{\sim}}
    - \newcommand{\I}{\mathrm{\mathbf{I}}}
    #
    - \allowdisplaybreaks
    - \def\M{\mathcal{M}}
#}}}1
    # FOR THIS PROJECT:
    - \newcommand{\y}{\bm{y}}
    - \newcommand{\yin}{\y_{i,n}}
    - \newcommand{\muin}{\bm{\mu}_{i,n}}
    - \newcommand{\bmu}{\bm{\mu}}
    - \newcommand{\muks}{\bmu_k^\star}
    - \newcommand{\mlins}{\bmu_{\lambda_{i,n}}^\star}
    - \newcommand{\Z}{\mathbf{Z}}
    - \newcommand{\z}{\bm{z}}
    - \renewcommand{\v}{\bm{v}}
    - \newcommand{\bzero}{\bm{0}}
    - \newcommand{\w}{\bm{w}}
    - \newcommand{\h}{\bm{h}}
    - \newcommand{\IBP}{\text{IBP}}
    - \newcommand{\TN}{\text{TN}}
    - \newcommand{\Dir}{\text{Dirichlet}}
    - \newcommand{\IG}{\text{IG}}
    - \newcommand{\Be}{\text{Beta}}
    - \newcommand{\Ind}[1]{\mathbbm{1}\bc{#1}}
    - \newcommand{\sign}[1]{\text{sign}\p{#1}}
---

# Joint Posterior

Let $\bm\theta = \p{\bm{\sigma^2, v, h, \lambda, w, \tau^2, \psi, \mu^*}}$

$$
\begin{split}
p(\bm\theta \mid K, \y) \propto& \bc{\prod_{i=1}^n p(\sigma_i^2)p(\bm{w_i}) 
\prod_{n=1}^{N_i} p(\lambda_{i,n}\mid \bm w_i)  p(\y_{i,n} \mid \mu_{j,\lambda_{i,n}}^* , \sigma^2_i \I_J ) } \\
&\prod_{j=1}^J p(\tau_j^2) p(\psi_j) \prod_{j=1,k=1}^{J,K}  p_{z_{jk}}(\mu^*_{jk} \mid \psi_j, \tau_j^2) 
\prod_{k=1}^Kp(v_k)p(\h_k)
\end{split}
$$



# Derivation of Full Conditionals

\begin{align*}
p(v_l \mid -) \propto(
\end{align*}


# Sampling via MCMC

\begin{align*}
\allowdisplaybreaks
\sigma_i^2 \mid \y,\bmu,- &\sim  \IG\p{a_\sigma + \frac{N_iJ}{2}, b_\sigma + \frac{\sum_{j=1}^J\sum_{n=1}^{N_i} \p{y_{i,n,j}-\mu^\star_{j,\lambda_{i,n}}}^2}{2}} \\
%\\
%\mu_{j,k}^\star \mid z_{j,k}=1, y_{i,n,j}, \tau^2_j,-&\sim \N^+\p{\frac{\tau_j^2\sum_{\bc{(i,n):\lambda_{i,n}=k}} y_{i,n,j}}{c_{jk}\tau_j^2+\sigma_i^2},\frac{\tau_j^2\sigma_i^2}{c_{jk}\tau_j^2+\sigma_i^2}} \\
%\mu_{j,k}^\star \mid z_{j,k}=0, y_{i,n,j}, \tau^2_j,-&\sim \N^-\p{\frac{\tau_j^2\sum_{\bc{(i,n):\lambda_{i,n}=k}} y_{i,n,j}}{c_{jk}\tau_j^2+\sigma_i^2},\frac{\tau_j^2\sigma_i^2}{c_{jk}\tau_j^2+\sigma_i^2}} \\
%p(\tau^2_{ij} \mid \bmu^\star-) &\propto \tau_{ij}^{2(a_\tau-1)} \exp\bc{-b_{\tau}/\tau_{ij}^2} \prod_{k=1}^K q_{jk}(\mu_{jk}^\star)\\
%\\
%h_{j,k}\mid z_{jk}=1,v_l- &\sim \TN\p{0,\Gamma_{jj},-\infty, \Phi^{-1}\p{\prod_{l=1}^k v_l\mid 0, \Gamma_{jj}}} \\
%p(v_l\mid z_{jk}=0,v_{-l},-) &\propto v_l^{a_v-1} \times \Ind{v_l < \frac{\Phi(h_{jk}|0,\Gamma_{jj})}{\prod_{d\ne l}^k v_d}} \text{\quad Truncated Beta?}\\
\h_k\mid - &\propto p(\h_k) \prod_{j=1}^J p_{z_{jk}}(\mu^*_{jk} \mid \psi_j, \tau_j^2) \\
%
v_l\mid z_{jk}- &\propto p(v_l) \prod_{j=1}^Jp_{z_{jk}}(\mu^*_{jk} \mid \psi_j, \tau_j^2) \\
%
z_{jk}(h_{jk},\v) &:= \Ind{\Phi(h_{jk} | 0, \Gamma_{jj}) < \prod_{l=1}^k v_l} \\
\\
%
p(\lambda_{i,n}=k \mid w_{i,k}, -) &\propto w_{i,k} \exp\bc{-\frac{1}{2\sigma_i^2}\sum_{j=1}^J\p{y_{i,n,j}-\mu^*_{j,k}}^2} \\
\w_i \mid \bm\lambda_i,- &\sim \Dir\p{a_{i1}+\sum_{n=1}^{N_i}\Ind{\lambda_{i,n}=1},...,a_{iK}+\sum_{n=1}^{N_i}\Ind{\lambda_{i,n}=K}} \\
%
\\
p(\tau_j^2|-) &\propto p(\tau_j^2) \times \prod_{k=1}^K p_{z_{jk}}(\mu_{jk}^* \mid \psi_j, \tau_j^2)\\
%
p(\psi_j\mid -) &\propto p(\psi_j) \times \prod_{k=1}^K p_{z_{jk}}(\mu_{jk}^* \mid \psi_j, \tau_j^2)\\
%
p(\mu^*_{jk} \mid z_{jk}=1, -) &\propto p_1(\mu^*_{jk} \mid \psi_j, \tau_j^2) \times \prod_{(i,n):\lambda_{in}=k} p(y_{inj} \mid \mu_{jk}^*, \sigma_i^2) \times \Ind{\mu_{jk}^*>0}\\
p(\mu^*_{jk} \mid z_{jk}=0, -) &\propto p_0(\mu^*_{jk} \mid \psi_j, \tau_j^2) \times \prod_{(i,n):\lambda_{in}=k} p(y_{inj} \mid \mu_{jk}^*, \sigma_i^2) \times \Ind{\mu_{jk}^*<0}\\
\end{align*}

where 

- $p_0(\mu^*_{jk} \mid \psi_j, \tau_j^2) = \ds\frac{\frac{1}{\sqrt{2\pi\tau_j^2}}\exp\bc{-\frac{(\mu_{jk}^* - \psi_j)^2}{2\tau_j^2}}}{1-\Phi\p{\frac{\mu_{jk}-\psi_j}{\tau_j}}}$

- $p_1(\mu^*_{jk} \mid \psi_j, \tau_j^2) = \ds\frac{\frac{1}{\sqrt{2\pi\tau_j^2}}\exp\bc{-\frac{(\mu_{jk}^* - \psi_j)^2}{2\tau_j^2}}}{\Phi\p{\frac{\mu_{jk}-\psi_j}{\tau_j}}}$

- $p(\h_k) \propto \exp\bc{-\frac{\h_k'(\Gamma^{-1})\h_k}{2}}$

- $p(v_l) \propto v_l^{\alpha-1}$

- $p(\tau_j^2) \propto (\tau_j^2)^{-a_\tau-1} \exp\bc{-b_\tau / \tau_j^2}$

- $p(\psi_j^2) \propto \exp\bc{-\frac{(\psi_j - m_\psi)^2}{2 s_\psi^2}}$

### Possible issues:

- Repeated columns allowed in $Z$ apriori

# Alternative Methods:

- Variational Inference for $Z$ using stick-breaking construction [@doshi2009variational]
    - takes longer and has poorer performance for lower-dimension $Z$
    - faster and has better performance for higher-dimension $Z$


[comment]: <> (%
  All these are commented
  No strange spell checks in the commetns.
  $$\alpha$$
%)

