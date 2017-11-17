#!/usr/bin/env python

import os, sys

### Read simulation number
if len(sys.argv) != 2:
    print "Usage: "
    print "         python genReport.py <simulation_number>"
    sys.exit(1)
else:
    SIMULATION_NAME= sys.argv[1]
    print "Generating report for " + SIMULATION_NAME


### make workspace
sim = SIMULATION_NAME
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

def getPdfPages(filepath):
    cmd = "pdfinfo " + filepath + " | grep 'Pages' | awk '{print $2}'"
    return int(os.popen(cmd).read().strip())

def replaceWithPdfPath(s, placeholder, pdfPath):
    pages = getPdfPages(pdfPath.replace('../../', ''))

    if pages > 1:
        tmp = "\includegraphics[page=<page>]{" + pdfPath + "}"
        cmd = ""
        for i in range(pages):
            cmd += tmp.replace("<page>", str(i+1)) + "\n"
    else:
        cmd = "\includegraphics{" + pdfPath + "}"

    cmd = s.replace(placeholder, cmd) 

    return cmd

def getPngWithHead(d, png):
    preout = filter(lambda x: png in x, os.listdir(d))
    return filter(lambda x: '.png' in x, preout)

def subPngWithHead(s, placeholder, d, png):
    pngs = map(lambda x: d + '/' + x, getPngWithHead(d.replace('../../',''), png))
    cmds = ["\includegraphics{" + p +  "}" for p in pngs]
    return s.replace(placeholder, "\n".join(cmds))

#-----------------------------

### Data Intro
intro = ""

template = readFile("template.md")

### Insert pdfs
template = replaceWithPdfPath(template, "<data-pdf>", OUTDIR + sim + "/data.pdf")
template = subPngWithHead(template, "<data-png>", OUTDIR + sim, "dataY")
# <data-png>
template = replaceWithPdfPath(template, "<mus-pdf>", OUTDIR + sim + "/postmus.pdf")
template = replaceWithPdfPath(template, "<Z-pdf>", OUTDIR + sim + "/Z.pdf")
template = replaceWithPdfPath(template, "<ll-pdf>", OUTDIR + sim + "/ll.pdf")

### Insert text files
template = template.replace("<path-to-datainfo>",    OUTDIR + sim + "/info.txt")
template = template.replace("<path-to-W>",    OUTDIR + sim + "/W.txt")
template = template.replace("<path-to-pi>",   OUTDIR + sim + "/pi.txt")
template = template.replace("<path-to-sig2>",   OUTDIR + sim + "/sig2.txt")
template = template.replace("<path-to-tau2>",   OUTDIR + sim + "/tau2.txt")
template = template.replace("<path-to-timing>",   OUTDIR + sim + "/timing.txt")
template = template.replace("<path-to-src>",   OUTDIR + sim + "/src.R")
template = intro + "\n" + template

### Edit Compile Script
compileScript = readFile(sim_dir + "/compile")
compileScript = compileScript.replace("pandoc", "pandoc --toc ")
writeFile(sim_dir + "/compile", compileScript)


### Read original sim.md file
orig_content = readFile(sim_dir + "/" + sim + ".md")
orig_content = orig_content.replace("Title", "Simulation " + SIMULATION_NAME)
orig_content = orig_content.replace("#{{{1\n", """#{{{1
    - \usepackage{verbatim}
""")

### Write new content
new_content = orig_content + template
writeFile(sim_dir + "/" + sim + ".md", new_content)

