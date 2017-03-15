---
title: CYTOF Model
#author: Draft
#date: " 4 March 2017"
author: "8 March 2017"
geometry: margin=1in
fontsize: 12pt

# Uncomment if using natbib:

bibliography: ../../bib/litreview.bib
bibliographystyle: plain 

# This is how you use bibtex refs: @nameOfRef
# see: http://www.mdlerch.com/tutorial-for-pandoc-citations-markdown-to-latex.html

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
    - \newcommand{\y}{\bm{y}}
    - \newcommand{\yin}{\y_{i,n}}
    - \newcommand{\muin}{\bm{\mu}_{i,n}}
    - \newcommand{\bmu}{\bm{\mu}}
    - \newcommand{\muks}{\bmu_k^\star}
    - \newcommand{\mlins}{\bmu_{\lambda_{i,n}}^\star}
    - \newcommand{\Z}{\mathbf{Z}}
    - \newcommand{\z}{\bm{z}}
    - \newcommand{\bzero}{\bm{0}}
    - \newcommand{\w}{\bm{w}}
    - \newcommand{\h}{\bm{h}}
    - \newcommand{\IBP}{\text{IBP}}
    - \newcommand{\TN}{\text{TN}}
    - \newcommand{\Dir}{\text{Dirichlet}}
    - \newcommand{\IG}{\text{IG}}
    - \newcommand{\Be}{\text{Beta}}
    - \newcommand{\Ind}[1]{\mathbbm{1}\bc{#1}}
    #
    - \allowdisplaybreaks
    - \def\M{\mathcal{M}}
    # For Drawing Graphs
    - \usepackage {tikz}
---

[//]: # (To do:
  - read DIBP paper
  - read stick breaking construction paper
)


1.  Notation

    (a) **Samples:** Let the total number of samples be $I$, and
        $i=1,...,I$. 

    (b) **Cells:** For each sample $i \in \bc{1,...,I}$, let the total
        number of cells in sample $i$ be $N_i$, and $n=1,...,N_i$.

    (c) **Markers:** Let $J$ be the total number of genetic markers of
        interest. (Expression levels are measured for the same set of
        surface markers in all cells of all samples.) Then, $j \in
        \bc{1,...,J}$ refers to one of the $J$ markers.

    (d) **Expression Levels:** Let $y_{i,n,j}$ be the expression level 
        of marker $j$ at cell $n$ in sample $i$ **after subtracting some
        cutoff expression level for marker $j$** so that 
        $y_{i,n,j} \in \mathbb{R}$. The subtraction is done to 
        remove background noise that may differ across samples.
        Furthermore, let $\yin = \bc{y_{i,n,1},..., y_{i,n,J}}$, 
        which is a vector of length $J$ containing the expression 
        levels of the $J$ markers for sample $i$ at cell $n$.


2.  Sampling Model

    Based on the notation above, we propose the following model:

$$
\yin \mid \muin, \sigma_i^2 \ind \N_J(\muin,\sigma_i^2 \I_J),
$$

> for $i=1,...i$ and $n=1,...,N_i$.

3.  Prior

    (a) **NK cell subpopulations**
        \par
        Suppose we have $K$ NK cell subpopulations.
        Subpopulation $k$ is characterized by a $J-$dim vector of zeros and ones,
        $\z_k=(z_{1, k}, \ldots, z_{J, k})$, $z_{j, k} \in \bc{0, 1}$.  Here $z_{j,
        k}=0$ means that surface marker $j$ is not expressed in subpopulation $k$
        and $z_{j, k}=1$ that marker $j$ is expressed. Collecting all columns into
        a matrix, we have $J \times K$ binary matrix $\Z$ whose columns are $\z_k$.
        We utilize a feature allocation model for $\Z$,
        $$
        \begin{split}
        \h_k \mid \Gamma &\iid \N_J(\bzero,\Gamma) \\
        v_l &\sim \Be(\alpha,1) \\
        b_k &:= \prod_{l=1}^k v_l \\
        z_{j,k} &= \Ind{\Phi(h_{j,k}\mid 0, \Gamma_{k,k}) < b_k} \\
        \end{split}
        $$
        From the last line of the equation, the probability that marker $j$ is
        expressed in subpopulation $k$ is $b_k$.  Note that the representation
        above is the stick-breaking representation of the Indian buffet process
        (IBP) and it is extended to model some associated markers through
        $\Gamma$ (@williamson2010dependent).  $\Gamma \neq \I_J$ may induce some
        associations between markers.  $\Gamma=\I_J$ reduces to the regular IBP
        assuming independence between markers.  The IBP assumes unknown $K$ so
        we learn $K$ from data.

    (b) **Mean Expression Levels for Subpopulations**
        \par
        Let $\muks$ be a
        $J-$dim mean-expression levels vector of surface markers for
        subpopulation $k$.  $\mu^\star_{j, k} >0$ if $z_{j,k} =1$ and
        $\mu^\star_{j, k} < 0$ if $z_{j,k} =0$.  Assume 
        $$
        \mu^\star_{j,k} \mid z_{j,k}, \tau_j^2 \ind 
        \begin{cases}
          \N(0, \tau_j^2)~\Ind{\mu^\star_{j,k}\geq0} &\text{ if } z_{j,k}=1,\\ 
          \N(0, \tau_j^2)~\Ind{\mu^\star_{j,k} < 0}  &\text{ if } z_{j,k}=0.\\ 
        \end{cases}
        $$

    (c) **Composition of NK Cell Subpopulations in Samples**
        \par
        We introduce $\w_i=(w_{i,1}, \ldots, w_{i,K})$, $0 < w_{i,k} <1$,
        $\sum_{k=1}^K w_{i,k}=1$,  given $\Z$.  Let a cell in sample $i$ belong
        to subpopulation $k$ with probability $w_{ik}$ (that is, clustering
        cells into latent subpopulations, but different probabilities across
        samples).  Let $\lambda_{i,n} \in \{1, \ldots, K\}$ a cluster
        membership of cell $n$ of sample $i$.  $\lambda_{i,n}=k$ means that
        cell $n$ of sample $i$ is in subpopulation $k$. Assume
        $$
        p(\lambda_{i,n} = k \mid \w_i) = w_{i,k}.
        $$  
        Note that $\w_i$ can be used to identify differences between samples.
        We further let $\bmu_{i,n} = \muks$ if $\lambda_{i,n}=k$. 
        (i.e., $\bmu_{i,n} = \bmu^*_{\lambda_{i,n}}$.)


    (d) **Priors for** $\sigma^2_i$, $\tau^2_j$, $\w_i$
       \par
       $$
       \begin{split}
       \sigma_i^2 &\iid \IG(a_\sigma,b_\sigma) \\
       \tau_i^2 &\iid \IG(a_\tau,b_\tau) \\
       \w_i &\iid \Dir(1,...,1) \\
       \end{split}
       $$

    (e) **Recap of Model & Priors**
        $$
        \begin{split}
          \yin \mid \mlins, \sigma_i^2 &\ind \N_J(\mlins,\sigma_i^2 \I_J) \\
          \sigma_i^2 &\iid \IG(a_\sigma,b_\sigma) \\
          \\
          \mu^\star_{j,k} \mid z_{j,k}=1, \tau^2_j &\ind \N^+(0,\tau^2_j)\\
          \mu^\star_{j,k} \mid z_{j,k}=0, \tau^2_j &\ind \N^-(0,\tau^2_j)\\
          \tau_j^2 &\ind \IG(a_\tau,b_\tau) \\
          %\Z \sim \IBP(\alpha) \leftrightarrow % when \Gamma = \I
          \\
          \h_k &\sim \N_J(\bzero, \Gamma) \\
          v_l &\iid \Be(\alpha,1) \\
          z_{j,k} &:= \Ind{\Phi(h_{j,k}\mid0,\Gamma_{k,k}) < \prod_{l=1}^k v_l}\\
          %(K^\star &:= \text{number of non-zero columns in } \Z) \\
          \\
          \lambda_{i,n} \mid \w_i &\sim \text{Multinomial}_{K}(1, \w_i) \\
          \w_i &\sim \Dir_{K}(a_{i1},...,a_{iK}) \\
        \end{split}
        $$
        where $k=1,\ldots,K$ for some fixed and sufficiently large $K$.

    (f) **Graphical Representation of Model**
        \vspace{1em}
        \begin{center}
        \begin{tikzpicture}[sibling distance=10em,
                            every node/.style = {shape=circle, draw}]
          \node {$\y$}
            child { node {$\bm{\sigma^2}$} }
            child { node {$\bmu$}
              child { node {$\bmu^\star$}
                child { node {$\bm{\tau^2}$} }
                child { node {$\Z$} 
                  child { node {$\h$} }
                  child { node {$\bm v$} }
                }
              }
              child { node {$\bm\lambda$} 
                child { node {$\bm{w}$} }
              } 
            };
        \end{tikzpicture}
        \end{center}
        \vspace{1em}
        \newpage

    (g) **Joint Posterior of Parameters**
        \par
        $$
        \begin{split}
        p(\bm\sigma^2,\bmu^\star,\bm\tau^2,\bm{h},\bm{v},\bm\lambda,\bm{w}\mid\bm{y}) \propto& \bc{\prod_{i=1}^Ip(\sigma_i^2)p(\bm{w}_i)\prod_{n=1}^{N_i}
        p(\yin\mid \muin,\sigma_i^2)   \prod_{k=1}^K p(\lambda_{i,n}=k\mid\bm{w}_i)}\times  \\
        &\prod_{j=1}^J p(\tau_j^2)
        \prod_{k=1}^K p(\h_k) p(\mu_{jk}^\star \mid z_{jk},\tau_j^2)
        \prod_{l=1}^k p(v_l) \\
        \propto & \left\{\prod_{i=1}^I (\sigma_i^2)^{a_\sigma-1} \exp\bc{-b_\sigma/\sigma_i^2} \times \right.\\
        &\prod_{n=1}^{N_i} (\sigma_i^2)^{-J/2} \exp\bc{-\frac{\sum_{j=1}^J(y_{inj}-\mu^\star_{j,\lambda_{in}})^2}{2\sigma_i^2}} \times  \\
        &\left. \prod_{k=1}^K w_{ik}^{a_{ik}} (w_{i,\lambda_{i,n}})\right\} \times \prod_{j=1}^J (\tau_u^2)^{-a_\tau-1} \exp\bc{-b_\tau/\tau_j^2} \times \\
        &\prod_{k=1}^K \bc{\abs{\Gamma}^{-1/2} \exp\bc{-\frac{\h_k'\Gamma^{-1}\h_k}{2}} \prod_{l=1}^k v_l^{\alpha-1}} \\
        \end{split}
        $$
        \newpage

    (h) **Full Conditionals for Parameters**
        \par
        $$
        \begin{split}
        \sigma_i^2 \mid \y,\bmu,- &\sim  \IG\p{a_\sigma + \frac{N_iJ}{2}, b_\sigma + \frac{\sum_{j=1}^J\sum_{n=1}^{N_i} \p{y_{i,n,j}-\mu^\star_{j,\lambda_{i,n}}}^2}{2}} \\
        \\
        \mu_{j,k}^\star \mid z_{j,k}=1, y_{i,n,j}, \tau^2_j,-&\sim \N^+\p{\frac{\tau_j^2\sum_{\bc{(i,n):\lambda_{i,n}=k}} y_{i,n,j}}{c_{jk}\tau_j^2+\sigma_i^2},\frac{\tau_j^2\sigma_i^2}{c_{jk}\tau_j^2+\sigma_i^2}} \\
        \mu_{j,k}^\star \mid z_{j,k}=0, y_{i,n,j}, \tau^2_j,-&\sim \N^-\p{\frac{\tau_j^2\sum_{\bc{(i,n):\lambda_{i,n}=k}} y_{i,n,j}}{c_{jk}\tau_j^2+\sigma_i^2},\frac{\tau_j^2\sigma_i^2}{c_{jk}\tau_j^2+\sigma_i^2}} \\
        p(\tau^2_j \mid \bmu^\star-) &\propto \tau_j^{2(a_\tau-1)} \exp\bc{-b_{\tau_j}/\tau_j^2} \prod_{k=1}^K q_{jk}(\mu_{jk}^\star)\\
        \\
        h_{j,k}\mid z_{jk}=1,v_l- &\sim \TN\p{0,\Gamma_{kk},-\infty, \Phi^{-1}\p{\prod_{l=1}^k v_l\mid 0, \Gamma_{kk}}} \\
        h_{j,k}\mid z_{jk}=0,v_l- &\sim \TN\p{0,\Gamma_{kk}, \Phi^{-1}\p{\prod_{l=1}^k v_l\mid 0, \Gamma_{kk}},\infty} \\
        p(v_l\mid z_{jk}=1,v_{-l},-) &\propto p(v_l) \times \Ind{v_l > \frac{\Phi(h_{jk}|0,\Gamma_{kk})}{\prod_{d\ne l}^k v_d}} \text{\quad Truncated Beta?}\\
        p(v_l\mid z_{jk}=0,v_{-l},-) &\propto p(v_l) \times \Ind{v_l < \frac{\Phi(h_{jk}|0,\Gamma_{kk})}{\prod_{d\ne l}^k v_d}} \text{\quad Truncated Beta?}\\
        \\
        p(\lambda_{i,n}=k \mid w_{i,k}, -) &\propto w_{i,k} \exp\bc{-\frac{1}{2\sigma_i^2}\sum_{j=1}^J\p{y_{i,n,j}-\mu_{i,n,j}}^2} \\
        \w_i \mid \bm\lambda_i,- &\sim \Dir\p{a_{i1}+\sum_{n=1}^{N_i}\Ind{\lambda_{i,n}=1},...,a_{iK}+\sum_{n=1}^{N_i}\Ind{\lambda_{i,n}=K}} \\
        \end{split}
        $$
        where 
        - $\TN(m,s^2,a,b)$ refers to the truncated Normal distribution with 
        mean parameter $m$, variance $s^2$, lower bound $a$, and upper bound $b$.
        - $c_{jk} = \sum_{\bc{(i,n):\lambda_{i,n}=k}} 1$
        - $q_{jk}(\cdot) = \N\p{\cdot\mid\frac{\tau_j^2\sum_{\bc{(i,n):\lambda_{i,n}=k}} y_{i,n,j}}{c_{jk}\tau_j^2+\sigma_i^2},\frac{\tau_j^2\sigma_i^2}{c_{jk}\tau_j^2+\sigma_i^2}}$ 


4.  **Additional Items**

    (a) Computation: A sample has 20000 cells and we have multiple samples

    (b) Consider having a special cluster for cells not belonging to any
        subpopulation?

    (c) Consider allowing some $w_{i,k}=0$ (i.e. subpopulation $k$ does not appear
        in the sample $i$ at all)




[//]: # ( example image embedding
\beginmyfig
\includegraphics[height=0.5\textwidth]{path/to/img/img.pdf}
\caption{some caption}
\label{fig:mylabel}
% reference by: \ref{fig:mylabel}
\endmyfig
)
[//]: # ( example image embedding
> ![some caption.\label{mylabel}](path/to/img/img.pdf){ height=70% }
)

[//]: # ( example two figs side-by-side
\begin{figure*}
  \begin{minipage}{.45\linewidth}
    \centering \includegraphics[height=1\textwidth]{img1.pdf}
    \caption{some caption}
    \label{fig:myLabel1}
  \end{minipage}\hfill
  \begin{minipage}{.45\linewidth}
    \centering \includegraphics[height=1\textwidth]{img2.pdf}
    \caption{some caption}
    \label{fig:myLabel2}
  \end{minipage}
\end{figure*}
)


[//]: # (Footnotes:)


