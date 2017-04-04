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
