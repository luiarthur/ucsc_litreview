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
    missing = map(lambda x: 
      (x[0],set(expectedHeader).difference(x[1])), badHeaders)
    unexpected = map(lambda x: 
      (x[0],set(x[1]).difference(expectedHeader)), badHeaders)
    #
    return {'badNumCols':badNumCols, 'badHeaders':badHeaders, 
            'missing':missing, 'unexpected':unexpected,
            'diff':diff}


def getFileHeader(fname,fh):
    for (name,header) in fh:
        if name == fname:
            return header

def elemComp(A,B):
    return [a==b for (a,b) in zip(A,B)]

### Main ###
# Path to Data
path = "./cytof_data_lili/cytof_data_lili"
file_headers = getHeaders(path)
ih = inspectHeaders(file_headers,compareWith=1)
EXPECTED_HEADER = file_headers[1][1]

for i in range(len(ih['diff'])):
    fs = ih['diff'][i]
    miss = ih['missing'][i]
    unexpected = ih['unexpected'][i]
    print str(i+1) + ". Unexpected Columns in: " + fs[0]
    print "Missing:    " + ",".join("'"+m+"'" for m in miss[1])
    print "Unexpected: " + ",".join("'"+m+"'" for m in unexpected[1])
    print ""

for i in range(len(ih['badNumCols'])):
    fs = ih['badNumCols'][i]
    print str(i+1) + ". Unexpected Number of Columns in: " + fs[0]
    print fs[1]

print
print "Note that if the set difference is empty, then the column orders are different!"

print "Model Header:"
print EXPECTED_HEADER

### TESTS ###
h = getFileHeader('patients/006_D106_clean.csv',file_headers)
elemComp(h,EXPECTED_HEADER)

