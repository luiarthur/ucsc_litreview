#!/usr/bin/env python

import sys, os
import re

if len(sys.argv) < 2:
    print "Usage:\n"
    print "./gen_module.py struct_file.h"
    sys.exit(1)

### Constants ###
STRUCT_FILE_FULLPATH = sys.argv[1]

SRC_DIR = "./"
if os.path.dirname(STRUCT_FILE_FULLPATH) != "":
    SRC_DIR = os.path.dirname(STRUCT_FILE_FULLPATH) + "/"

STRUCT_FILENAME = os.path.basename(STRUCT_FILE_FULLPATH)
STRUCT_NAME = os.path.splitext(STRUCT_FILENAME)[0]
ADDON_FILENAME = STRUCT_NAME + "_addon.h"
ADDON_FILE_FULLPATH = SRC_DIR + ADDON_FILENAME

### Function Defs ###

def readFile(filepath):
    with open(filepath,"r") as f:
        x = "".join(f.readlines())
        f.close()
    return x

def writeFile(filepath, data):
    with open(filepath,"w") as f:
        f.write(data)
        f.close()

def get_struct(struct_name, c_file_contents):
    pattern = 'struct\s*' + struct_name + '\s*{'
    m = re.search(pattern, c_file_contents, re.DOTALL)
    start_pos = m.end()
    end_pos = m.end() - 1
    closing_braces_needed = 1
    #
    while(closing_braces_needed != 0):
        end_pos += 1
        if c_file_contents[end_pos] == "{":
            closing_braces_needed += 1
        elif c_file_contents[end_pos] == "}":
            closing_braces_needed -= 1
    #
    return c_file_contents[start_pos:end_pos]

CPP_COMMENTS = re.compile('//.*')
STRUCT_DEFAULTS = re.compile('\s*=\s*\w*\s*')

def get_params_in_struct(c_struct):
    c_struct = CPP_COMMENTS.sub('', c_struct)
    c_struct = STRUCT_DEFAULTS.sub('', c_struct)
    params = c_struct.split('\n')
    params = map(lambda x: x.strip(), params)
    params = filter(lambda x: x != '', params)
    params = "".join(params)
    params = params.split(';') 
    params = filter(lambda x: x != '', params)
    params = map(lambda x: x.strip(), params)

    out = []
    for p in params:
        p = ' '.join(p.split())
        t, n = p.split(' ')
        out.append({'type': t, 'name': n})

    return out

def gen_constructor(params, struct_name):
    OUT = struct_name + "(<SIG>) : <ASS> {}"
    SIG = map(lambda p: p['type'] + ' ' + p['name'] + '_', params)
    ASS = map(lambda p: p['name'] + '(' + p['name'] + '_)', params)
    OUT = OUT.replace("<SIG>", ", ".join(SIG))
    OUT = OUT.replace("<ASS>", ", ".join(ASS))
    return OUT

def includize(filename):
    return filename.upper().replace('.', '_')

def create_new_struct(struct_file_fullpath):
    c_struct_contents = readFile(struct_file_fullpath)
    c_struct = get_struct(STRUCT_NAME, c_struct_contents)
    param = get_params_in_struct(c_struct)
    constructor = gen_constructor(param, STRUCT_NAME)
    new_struct = c_struct_contents.replace('};', '\n  ' + constructor + '\n};\n')
    new_struct = new_struct.replace(includize(STRUCT_FILENAME), includize(ADDON_FILENAME))

    return new_struct

### MAIN
c_struct_contents = readFile(STRUCT_FILE_FULLPATH)
c_struct = get_struct(STRUCT_NAME, c_struct_contents)
param = get_params_in_struct(c_struct)

constructor = gen_constructor(param, STRUCT_NAME)
#print constructor

new_struct = create_new_struct(STRUCT_FILE_FULLPATH)
print new_struct

### TODO
# print RCPP_MODULE contents
