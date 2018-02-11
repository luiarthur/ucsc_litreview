[comment]: <> (% TODO
- [ ] Please explain this in a plain text rather than in "enumerate". Include specific true values used to simulate data.
%)

Data were generated to closely match the proposed model. The steps to simulate
data is as follows:

1. Fix $I$, $J$, $K$.
2. Fix $(\psi_0, \psi_1, \tau^2_0, \tau^2_1)$
    - where $\psi_0 \in (-\infty, 0)$ and $\psi_1, \tau^2_0, \tau^2_1 \in (0,\infty)$
    - For example, the parameters could be (-2, 1, 1, .1). Typically, if $-\psi_0 < \psi_1$ and $\tau^2_0 < \tau^2_1$, the simulated data **will not** resemble real data. So, we should choose $-\psi_0 > \psi_1$ and $\tau^2_0 > \tau^2_1$.
3. Draw $\sigma^2_{ij}$ from an inverse gamma distribution. Smaller values of $\sigma_{ij}$ will yield datasets that are easy to learn from.
4. Draw $\gamma^*_{0ij}$ from an inverse gamma distribution. This inflates the variance of the observations for which $Z_{j,\lambda_{in}} = 0$.
5. For simplicity, set $\beta_{0ij}$ to be some negative real value and $\beta_{1j}$ to be some positive real value. Note that by choosing, each of these values, we implicitly determine the probability that an observation will be treated as missing. Intuitively, $\beta_0$ determines the boundary for where observations transition from not-missing to missing. $\beta_1$ determines how narrow the boundary is.
6. Fix $Z$ to be some $J \times K$ binary matrix. 
    - Ensure that $Z$ does not contain columns that consist of only 0's.
7. Fix $W$ to be an $I \times K$ probability matrix such that each row sums to 1.
    - $W_{ik}$ is the probability that observation $y_{inj}$ takes on cell type $k$, which corresponds to column $k$ of $Z$.
8. Set $\lambda_{in} = k$ with probability $W_{ik}$.
9. Draw $\mu^*_{0ij}$ from a Truncated-Normal($\psi_0, \tau^2_0, -\infty, 0$).
10. Draw $\mu^*_{1ij}$ from a Truncated-Normal($\psi_1, \tau^2_1, 0, \infty$).
11. Set $\mu_{inj} = \mu^*_{Z_{j,\lambda_{in}}ij}$.
12. Set $\gamma_{inj} = \gamma^*_{0ij}$ if $Z_{j,\lambda_{in}} = 0$, and 0 otherwise.
13. Draw $\tilde{y}_{inj} \sim \text{Normal}(\mu_{inj}, (1+\gamma_{inj})\sigma^2_{ij})$.
14. Define $p_{inj} = (1+\exp\bc{-\beta_{0ij} + \beta_{1j} \tilde{y}_{inj}})^{-1}$.
15. With probability $p_{inj}$, set $y_{inj}$ to be missing, and $\tilde{y}_{inj}$ otherwise.

