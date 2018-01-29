#!/usr/bin/env python

import os
import re
import numpy as np
import pandas as pd

### GLOBAL VARS ###
REPS = 2
OUTDIR = [ 'out/simRandomK' + str(r) + '/' for r in range(1, REPS+1) ]
WTXT = '/W_pointEst.txt'
OUT = dict() # (prop, K_init, sim_num) -> K_est

def readFile(path):
    with open(path, 'r') as f:
        contents = f.read()
        f.close()
    return contents



### Fill the dictionary OUT ###
for outdir in OUTDIR:
    sim = int(outdir[-2])
    for d in os.listdir(outdir):
        prop = float(re.findall('\\d\.\\d', d)[0])
        k_init = int(re.findall('(?<=k)\\d+', d)[0])
        W_contents = readFile(outdir + d + WTXT)
        dim = W_contents.split('True W')[0]
        cols = re.findall("(?<=,)\\d+", dim)
        max_col = max(map(int, cols))
        OUT[(prop, k_init, sim)] = max_col

props = sorted(set(map(lambda x: x[0], OUT)))

def toSimName(k):
    return 'K_init=' + str(k[1]) + ',sim' + str(k[2])

sims = sorted(set(map(lambda k: toSimName(k), OUT)))

M = np.zeros( (len(props), len(sims)), dtype=np.int8)

for k in OUT:
    M[props.index(k[0]), sims.index(toSimName(k))] = OUT[k]

table = pd.DataFrame(M, index=map(lambda p: str(int(p*100)) + '%', props), columns=sims)

print table
