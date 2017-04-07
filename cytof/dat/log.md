# 30 March 2017

Looked at the `ALL.csv` file and `CB34_CLEAN.csv` files (among others).

`ALL.csv` contains 45 binary columns for the markers. The names are similar
to that in `CB34_CLEAN.csv` but not exactly the same. The number of columns
in the latter file is also different (34). According to Li Li, the discrepancy
is possibly due to a difference in machinery (which did the analyses). More 
clarification is needed to do the analysis.

Also, what are the rows supposed to represent?

The log of the columns in `CB34_CLEAN.csv` appear to be Normal.


# 31 March 2017

Looked at the Correlations



# 3 April 2017

Looking at columns.
The output of `python exploreHeaders.py` provide a summary of 
the cleanliness of the data. Note that if the set difference
is empty, the column order is different.

```
1. Unexpected Columns in: pb/PBP_11_CMV(+)_CLEAN.csv
Columns interchanged for "kir3dl1" and "klrg1"

2. Unexpected Columns in: pb/PBP36_CMV-_CLEAN.csv
Missing:    'kir2ds4'
Unexpected: '2ds4'

3. Unexpected Columns in: patients/003_d90_CLEAN.csv
Missing:    'kir2dl1','nkg2c','cd8','cd158b','grb',
            'gra','cd57','kir2ds4','lfa1','tigit'
Unexpected: '','kir3dl1ds1'

4. Unexpected Columns in: patients/006_D106_clean.csv
Missing:    'kir2dl3'
Unexpected: 

5. Unexpected Columns in: patients/010_D35_clean.csv
Missing:    'kir2ds4'
Unexpected: 'kir2d4'

6. Unexpected Columns in: patients/007_D35_clean.csv
Missing:    'syk'
Unexpected: '174yb_syk'

7. Unexpected Columns in: patients/003_d60_CLEAN.csv
Missing:    'kir3dl1'
Unexpected: '3dl1'

8. Unexpected Columns in: patients/005_D93_CLEAN.csv
Missing:    'kir2ds4'
Unexpected: '2ds4'

Model Header:
['cd16', 'dnam1', 'eomes', 'nkp30', 'ckit', 'nkg2d', 'perforin',
 'zap70', 'tbet', 'siglec7', 'nkg2a', 'kir2dl3', '2b4', 'trail',
 'cd25', 'cd94', 'cd62l', 'cd27', 'cd158b', 'grb', 'cd8', 'cd57',
 'nkg2c', 'kir2ds4', 'tigit', 'gra', 'lfa1', 'kir2dl1', 'ccr7',
 'kir3dl1', 'syk', 'klrg1']
```

# 7 April 2017

Why are the cutoffs larger than some observations?

```
              2B4      2DL1       2DL3       2DS4     3DL1      CCR7     CD158B
cutoff   2.360000  14.80000  22.900000   5.540000  44.0000 14.800000  16.800000
0%       0.000000   0.00000   0.000000   0.000000   0.0000  0.000000   0.000000
25%      7.419512   0.00000   0.000000   0.000000   0.0000  0.000000   0.000000
50%     11.746092   0.00000   0.943160   0.000000   0.0000  0.079865   0.690890
75%     16.972967   0.63161   3.048286   1.399193   0.0000  1.777821   2.505421
100%   596.530151 573.95966 296.827576 211.611542 912.3855 56.500511 176.913055

              CD16     CD25       CD27        CD57      CD62L        CD8
cutoff   13.000000 44.00000   7.620000   18.400000   37.00000  52.400000
0%        0.000000  0.00000   0.000000    0.000000    0.00000   0.000000
25%       0.000000  0.00000   7.003229    7.060512   11.53889   6.454427
50%       2.805037  0.00000  14.299857   11.180546   22.59113  25.245937
75%      10.445347  0.00000  27.541500   16.365300   56.11242  65.149460
100%   2692.812012 25.97979 547.379883 1638.981812 8889.49609 554.274109

           CD94       CKIT      DNAM1      EOMES        GRA        GRB
cutoff  21.0000  10.400000    5.80000  15.500000  10.400000  23.900000
0%       0.0000   0.000000    0.00000   0.000000   0.000000   0.000000
25%    181.2063   1.238707   21.38282   2.041309   5.029082   6.283657
50%    243.8976   4.697266   30.77658   5.676032  10.009824  12.397644
75%    305.2283  10.628868   41.44429  17.518573  17.376224  22.711522
100%   987.7375 218.981995 7963.68457 389.934235 201.001022 577.423279

            KLRG1        LFA1     NKG2A      NKG2C      NKG2D      NKP30
cutoff   9.950000   101.00000  10.90000   8.710000   7.620000   6.960000
0%       0.000000     0.00000   0.00000   0.000000   0.000000   0.000000
25%      0.000000    21.65295  35.80794   0.000000   7.576852   6.645612
50%      0.000000    31.34233  54.13448   0.000000  13.709576  12.998199
75%      1.547031    46.86957  74.88223   1.604821  22.020423  22.348120
100%   104.867035 20101.72266 894.95038 281.842072 296.955902 402.281219

         PERFORIN   SIGLEC7        SYK      TBET      TIGIT      TRAIL
cutoff  13.600000  13.00000   4.590000  6.960000  5.2900000  11.900000
0%       0.000000   0.00000   0.000000  0.000000  0.0000000   0.000000
25%      0.000000  19.50663   9.750847  0.000000  0.0000000   1.026867
50%      1.069562  36.52264  16.959883  2.105303  0.0000000   3.914661
75%      3.557098  57.52394  26.470544 10.001772  0.6969045   8.009852
100%   296.617767 425.03268 400.599304 98.374634 65.4951860 240.103500

           ZAP70
cutoff  1.980000
0%      0.000000
25%     1.793823
50%     4.456061
75%     7.967037
100%   55.339413
```
