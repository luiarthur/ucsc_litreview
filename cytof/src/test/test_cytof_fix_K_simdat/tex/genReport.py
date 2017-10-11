#!/usr/bin/env python

import os, sys

### Read simulation number
if len(sys.argv) != 2:
    print "Usage: "
    print "         python genReport.py <simulation_number>"
    sys.exit(1)
else:
    SIMULATION_NUMBER = sys.argv[1]
    print "Generating report for sim" + SIMULATION_NUMBER


### make workspace
#sim = "sim" + SIMULATION_NUMBER
sim = SIMULATION_NUMBER
sim_dir = "report/" + sim
OUTDIR = "../../../out/"
os.system("mkdir -p " + sim_dir)
os.system("rm -rf " + sim_dir + "/*")
os.system("mdgen " + sim)
os.system("mv compile " + sim_dir)
os.system("mv " + sim + ".md " + sim_dir)

def readFile(filepath):
    with open(filepath,"r") as f:
        s = ""
        for line in f:
            s += line
        f.close()
    return s

def writeFile(filepath, data):
    with open(filepath,"w") as f:
        f.write(data)
        f.close()

### Edit Data Path
intro = ""
#intro = """
#\\newpage
#THis is my intro
#
## Data
#"""

template = readFile("template.md")
#template = template.replace("<path-to-data>", OUTDIR + sim + "/data.pdf")
template = template.replace("<path-to-mus>",  OUTDIR + sim + "/postmus.pdf")
template = template.replace("<path-to-Z>",    OUTDIR + sim + "/Z.pdf")
template = template.replace("<path-to-W>",    OUTDIR + sim + "/W.txt")
template = template.replace("<path-to-pi>",   OUTDIR + sim + "/pi.txt")
template = template.replace("<path-to-src>",   OUTDIR + sim + "/src.R")
template = template.replace("# Data", intro)

### Edit Compile Script
compileScript = readFile(sim_dir + "/compile")
compileScript = compileScript.replace("pandoc", "pandoc --toc ")
writeFile(sim_dir + "/compile", compileScript)


### Read original sim.md file
orig_content = readFile(sim_dir + "/" + sim + ".md")
orig_content = orig_content.replace("Title", "Simulation " + SIMULATION_NUMBER)
orig_content = orig_content.replace("#{{{1\n", """#{{{1
    - \usepackage{verbatim}
""")

### Write new content
new_content = orig_content + template
writeFile(sim_dir + "/" + sim + ".md", new_content)

