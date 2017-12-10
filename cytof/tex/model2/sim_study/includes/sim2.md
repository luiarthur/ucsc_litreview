A first simulation study was conducted to investigate how our model 
performs for simulated data (where the true value of the parameters are known)
which has sample sizes and distributions similar to a real data-set
(CB CYTOF data).

We simulate data so that

- $N_i$ is on the order of 10000's
- $\mu_{zij}^*$ is reasonably far away from 0
- the latent feature matrix $Z$ is "simple" (columns are linearly independent)
- the true number of latent features is 4

The MCMC is run for a sufficiently long time, and the dimensions of $Z$ are fixed
at 2,3,...,7. (i.e. six different models are run for different dimensions of $Z$.)

## Simulated Data

The following images show some of the properties of the simulated data.
The number of rows in each of the matrices is in the order of tens of thousands.
Specifically, $N=(20000, 30000, 10000)$. 

![Simulated data $Y_1$](img/rawDat002.png){ height=60% }

![Simulated data $Y_2$](img/rawDat003.png){ height=60% }

![Simulated data $Y_3$](img/rawDat004.png){ height=60% }

In real CYTOF data, markers that are not expressed are sometimes recorded as
having negative expression levels due to the mechanics of the measurement
devices. Scientists interpret negative expression levels recorded by machines
as non-expression. Consequently, we need to simulate data that have missing values.
We do so by first generating data from the model, and then with some probability
setting observations to be missing. Observations with lower values have a 
higher chance of becoming missing values. In this simulation, we record
observations as missing using the function in Figure \ref{pmiss}.

![Probability of missing](img/prob_miss.pdf){ id=pmiss height=60% }


## Results
bla
