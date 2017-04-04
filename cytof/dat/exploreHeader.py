import os
import csv
import re

# lower the string, then remove space and hyphens
def sanitize(x):
    return re.sub("[\s+|-]","",x.lower())

def readHeader(path, mode='rU'):
    with open(path, mode=mode) as f:
        reader = csv.reader(f)
        row1 = next(reader)
        return row1


# Get all first columns
def getHeaders(path):
    cytof = os.listdir(path)
    out = []
    for d in cytof:
        dpath = path + "/" + d
        files = os.listdir(dpath)
        for f in files:
            fpath = dpath + "/" + f
            if fpath.endswith(".csv"):
                header = map(lambda s: sanitize(s), \
                             readHeader(fpath))
                out.append( (d + "/" + f, header) )
    return out


# check that all files have same number of columns 
# and the right header
def inspectHeaders(fh, compareWith=1):
    expectedHeader = fh[compareWith][1]
    expectedNumCols = len(expectedHeader)
    #
    badNumCols = filter(lambda x: len(x[1]) != expectedNumCols, fh)
    badHeaders = filter(lambda x: x[1] != expectedHeader, fh)
    diff = map(lambda x: 
            (x[0],
             set(expectedHeader).symmetric_difference(x[1])),
            badHeaders)
    #
    return {'badNumCols':badNumCols, 'badHeaders':badHeaders,
            'diff':diff}

### Main ###
# Path to Data
path = "./cytof_data_lili/cytof_data_lili"
file_headers = getHeaders(path)
ih = inspectHeaders(file_headers)

c=0 
for fs in ih['diff']:
    c += 1
    print str(c) + ") Unexpected Columns in: " + fs[0]
    print fs[1]
    print ""

c=0
for fs in ih['badNumCols']:
    c += 1
    print str(c) + ") Unexpected Number of Columns in: " + fs[0]
    print fs[1]

print
print "Note that if the set difference is empty, then the column orders are different!"
