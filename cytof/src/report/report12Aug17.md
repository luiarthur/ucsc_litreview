---
title: "Preliminary Results for Cytof Model with Fixed K"
author: Arthur Lui
date: "\\today"
geometry: margin=1in
fontsize: 12pt

# Uncomment if using natbib:

# bibliography: BIB.bib
# bibliographystyle: plain 

# This is how you use bibtex refs: @nameOfRef
# see: http://www.mdlerch.com/tutorial-for-pandoc-citations-markdown-to-latex.html

header-includes: 
#{{{1
    - \usepackage{bm}
    - \usepackage{bbm}
    - \usepackage{graphicx}
    #- \pagestyle{empty}
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
#{{{2 Other headers:
    - \newcommand{\one}{\bm{1}}
    - \newcommand{\y}{\bm{y}}
    - \newcommand{\yin}{\y_{i,n}}
    - \newcommand{\muin}{\bm{\mu}_{i,n}}
    - \newcommand{\bmu}{\bm{\mu}}
    - \newcommand{\mus}{\mu^\star}
    - \newcommand{\tmus}{{\tilde\mu}^\star}
    - \newcommand{\lin}{{\lambda_{i,n}}}
    - \newcommand{\Z}{\mathbf{Z}}
    - \newcommand{\z}{\bm{z}}
    - \newcommand{\btheta}{{\bm\theta}}
    - \renewcommand{\v}{\bm{v}}
    - \newcommand{\bzero}{\bm{0}}
    - \newcommand{\w}{\bm{w}}
    - \newcommand{\h}{\bm{h}}
    - \newcommand{\LN}{\text{Log-}\N}
    - \newcommand{\IBP}{\text{IBP}}
    - \newcommand{\TN}{\text{TN}}
    - \newcommand{\Unif}{\text{Uniform}}
    - \newcommand{\Dir}{\text{Dirichlet}}
    - \newcommand{\IG}{\text{IG}}
    - \newcommand{\Be}{\text{Beta}}
    - \newcommand{\Bern}{\text{Bernoulli}}
    - \newcommand{\Ind}[1]{\mathbbm{1}\bc{#1}}
    - \newcommand{\sign}[1]{\text{sign}\p{#1}}
    - \newcommand{\logNpdf}[3]{\frac{1}{#1\sqrt{2\pi#3}}\exp\bc{-\frac{\p{\log(#1)-#2}^2}{2{#3}}}}
    - \newcommand{\Npdf}[3]{\frac{1}{\sqrt{2\pi{#3}}}\exp\bc{-\frac{\p{#1-#2}^2}{2#3}}}
    - \newcommand{\Npdfc}[3]{\exp\bc{ -\frac{\p{#1-#2}^2}{2#3} }}
    - \newcommand{\TNpdf}[4]{\frac{\Npdf{#1}{#2}{{#3}^2}}{\Phi\p{\frac{#4-#2}{#3}}}}
    - \newcommand{\TNpdm}[4]{\frac{\Npdf{#1}{#2}{{#3}^2}}{1-\Phi\p{\frac{#4-#2}{#3}}}}
    - \newcommand{\TNpdfc}[3]{\frac{\Npdfc{#1}{#2}{{#3}^2}}{\Phi\p{\frac{#1-#2}{#3}}}}
    - \newcommand{\TNpdfcm}[3]{\frac{\Npdfc{#1}{#2}{{#3}^2}}{1-\Phi\p{\frac{#1-#2}{#3}}}}
    - \newcommand{\rest}{\text{rest}}
    - \newcommand{\logit}{\text{logit}}
    - \newcommand{\piconsta}{\frac{\exp(\rho)}{1+\exp(-\kappa_j)}}
    - \newcommand{\piconstb}{\frac{\exp(\rho)}{1+\exp( \kappa_j)}}
    - \newcommand{\piconst}{\frac{\Gamma(\exp(\rho))}{\Gamma\p{\piconsta}\Gamma\p{\piconstb}}}
    - \newcommand{\likeone}[1][]{
        \bc{\delta_0(y_{inj})}^{\Ind{e_{inj}=1#1}}
      }
    - \newcommand{\likezero}[2][]{
        \bc{
        \TNpdf{y_{inj}}{\mus_{j#2}}{\sigma_i}
        }^{\Ind{e_{inj}=0#1}}
      }
    - \newcommand{\likezeroc}[2][]{
        \bc{
          \frac{
            \exp\bc{\frac{(y_{inj}-\mus_{j#2})^2}{2 \sigma^2_i}}
          }{
            \Phi\p{\frac{y_{inj}-\mus_{j#2}}{\sigma_i}}
          }
        }^{\Ind{e_{inj}=0#1}}
      }
    - \newcommand{\pone}[1]{
        p(y_{inj}\mid \mus_{j,#1}, \sigma_i^2, e_{inj}=1)
      }
    - \newcommand{\sumjn}{\sum_{j=1}^J\sum_{n=1}^{N_i}}
    - \newcommand{\pmugt}[2][]{
        \bc{
          \frac{
            \Npdf{\mus_{j,#2}}{\psi_j}{\tau_j^2}
          }{
            1-\Phi\p{ \frac{\mus_{j,#2}-\psi_j-\log(2)}{\tau_j} }
          }
        }^{\Ind{
            \ifthenelse{\equal{#1}{}}{
              \mus_{j,#2}>\log(2),~z_{j#2}=1
            }{#1}
          }
        }
      }
    - \newcommand{\pmult}[2][]{
        \bc{
          \frac{
            \Npdf{\mus_{j,#2}}{\psi_j}{\tau_j^2}
          }{
            \Phi\p{ \frac{\mus_{j,#2}-\psi_j-\log(2)}{\tau_j} }
          }
        }^{\Ind{
            \ifthenelse{\equal{#1}{}}{
              \mus_{j,#2}<\log(2),~z_{j#2}=0
            }{#1}
          }
        }
      }
    - \newcommand{\pmugtc}[2][]{
        \bc{
          \frac{
            \exp\bc{-\frac{(\mus_{j,#2}-\psi_j)^2}{2\tau_j^2}}
          }{
            1-\Phi\p{ \frac{\mus_{j,#2}-\psi_j-\log(2)}{\tau_j} }
          }
        }^{\Ind{
            \ifthenelse{\equal{#1}{}}{
              \mus_{j,#2}>\log(2),~z_{j#2}=1
            }{#1}
          }
        }
      }
    - \newcommand{\pmultc}[2][]{
        \bc{
          \frac{
            \exp\bc{-\frac{(\mus_{j,#2}-\psi_j)^2}{2\tau_j^2}}
          }{
            \Phi\p{ \frac{\mus_{j,#2}-\psi_j-\log(2)}{\tau_j} }
          }
        }^{\Ind{
            \ifthenelse{\equal{#1}{}}{
              \mus_{j,#2}<\log(2),~z_{j#2}=0
            }{#1}
          }
        }
      }
#}}}2

---

[comment]: <> (%
  These are comments
%)

# Data Simulation

Data were simulated according to the attached document (`dataSim.pdf`), with an
exception being that 

$$
\mus_{jk} \ind \begin{cases}
\TN(\log(2)+1,\tau_j^2, \log(2),\infty), & \text{ if } z_{jk} = 1\\
\TN(\log(2)-1,\tau_j^2,-\infty,\log(2)), & \text{ if } z_{jk} = 0\\
\end{cases}
$$

The data were simulated such that there are 3 groups ($I=3$), 
i.e. $Y = (y_1,y_2,y_3)$. There percentage of zeros (sparsity) is less than 5%
in each group. (This is determinted by $\pi_{ij}$. The sample sizes in each
group are 200, 300, and 100 respectively.  $\tau^2_j = .1$, $\sigma_i^2=1$, and 
$W$ is an $I\times J$ matrix as follows:

\begin{verbatim}
True W: 
     [,1] [,2] [,3] [,4]
[1,]  0.3  0.4  0.2  0.1
[2,]  0.1  0.7  0.1  0.1
[3,]  0.2  0.3  0.3  0.2
\end{verbatim}

The file `data.pdf` summarizes key aspects of the simulated data. It should be
self-explanatory. (Let me know if something isn't clear.)

# MCMC Results

(NOTE: All model parameters were estimated, except for $K$ which is fixed to be
4.)

One MCMC chain was run on the data, with 2000 samples taken after 20000 burn-in. 
The $Z$ matrix was recovered perfectly sometimes. I'll only discuss the case where 
it is retrieved perfectly. (In some cases with data generated with a different 
random seed, but same parameter settings, I get completely different and unexpected
results.)

The $W$ matrix recovered has posterior mean as follows:

\begin{verbatim}
Posterior Mean W: 
          [,1]      [,2]      [,3]       [,4]
[1,] 0.3105571 0.3566867 0.2404971 0.09225912
[2,] 0.1232347 0.7177155 0.0605226 0.09852718
[3,] 0.2075812 0.1809576 0.3054090 0.30605213
\end{verbatim}

The posterior $\mu*$ recovered is summarized in `postmus.pdf`. Again it is more
or less self-documenting. Just a few quick notes: Notice how in the first
graph, the truth matches the posterior mean (hence the dots lie around the
diagonal line). In the following plots, the posterior distribution of some
$\mu*$ are shown.  The grey line is the truth. The trace plots (in the upper
right corner) indicate perhaps the chain has not reached a stationary distribution. 


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


