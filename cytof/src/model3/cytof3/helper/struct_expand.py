#!/usr/bin/env python

# TODO: Rewrite in R eventually.
# Goal: read a file that contains a C++ `struct` (say `MyStruct`) and 
#       append to the struct file a function that reads an R-list and
#       converts it to the C++ struct (`MyStruct`)
#       For example, the function 
#       ```C++
#       MyStruct gen_mystruct_obj(const Rcpp::List &mystruct_ls) {
#         MyStruct = mystruct;
#         mystruct.x = Rcpp::as<double>(mystruct_ls["x"]);
#         ...
#         return mystruct;
#       }
#       ```
#       Also create biolerplate for R-list generator R-function,
#       (`gen_default_mystruct`).
#    
#       Basically, take the file `Prior.h` as an example. I want to write
#       only the struct. And generate the functions `gen_prior_obj` and
#       most of `gen_default_prior.R`.

import sys, os
import re

#HOME_DIR = "../"
#SRC_DIR = HOME_DIR + "src/"
#R_DIR = HOME_DIR + "R/"

if len(sys.argv) < 2:
    print "Usage:\n"
    print "struct expand struct_file.h" #outfilepath.R
    sys.exit(1)

STRUCT_FILE_FULLPATH = sys.argv[1]

SRC_DIR = "./"
if os.path.dirname(STRUCT_FILE_FULLPATH) != "":
    SRC_DIR = os.path.dirname(STRUCT_FILE_FULLPATH) + "/"

# TODO:
#R_OUTPATH = sys.argv[2]

STRUCT_FILENAME = os.path.basename(STRUCT_FILE_FULLPATH)
STRUCT_NAME = os.path.splitext(STRUCT_FILENAME)[0]
ADDON_FILENAME = STRUCT_NAME + "_addon.h"
ADDON_FILE_FULLPATH = SRC_DIR + ADDON_FILENAME
#print ADDON_FILE_FULLPATH

#ORIG_STRUCT_H = sys.argv[1]
#ADDON_H = SRC_DIR + 
#ADDON_R = sys.argv[3]


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
#CPP_CONST = re.compile('\s*(const)\s')

def get_params_in_struct(c_struct):
    c_struct = CPP_COMMENTS.sub('', c_struct)
    c_struct = STRUCT_DEFAULTS.sub('', c_struct)
    #c_struct = CPP_CONST.sub(' ', c_struct)
    param = c_struct.split('\n')
    param = map(lambda x: x.strip(), param)
    param = filter(lambda x: x != '', param)
    param = "".join(param)
    param = param.split(';') 
    param = filter(lambda x: x != '', param)
    param = map(lambda x: x.strip(), param)

    out = []
    for p in param:
        p = ' '.join(p.split())
        t, n = p.split(' ')
        out.append({'type': t, 'name': n})

    return out

GEN_STRUCT_OBJ = """#ifndef <STRUCT_NAME_H>
#define <STRUCT_NAME_H>
#include "<STRUCT_FILENAME>"

<STRUCT_NAME> gen_<struct_name>_obj(const Rcpp::List &<struct_name>_ls) {
  <STRUCT_NAME> <struct_name>;

  <DEFS>
  return <struct_name>;
}

#endif
"""

GEN_STRUCT_DEF = '<struct_name>.<param_name> = Rcpp::as<<param_type>>(<struct_name>_ls["<param_name>"])'
 

def gen_list_to_struct_c(param, struct_name):
    HEADER = struct_name
    assert struct_name[0].upper() == struct_name[0], 'First letter of struct-name needs to be capitalized.'
    OUT = GEN_STRUCT_OBJ
    OUT = OUT.replace('<STRUCT_NAME>', struct_name)
    OUT = OUT.replace('<struct_name>', struct_name.lower())
    OUT = OUT.replace('<STRUCT_NAME_H>', ADDON_FILENAME.upper().replace('.','_'))
    OUT = OUT.replace('<STRUCT_FILENAME>', STRUCT_FILENAME)

    DEFS = ""
    counter = 0
    
    for p in param:
        if counter > 0:
            DEFS += "  "
        counter += 1
        DEF = GEN_STRUCT_DEF
        DEF = DEF.replace('<struct_name>', struct_name.lower())
        DEF = DEF.replace('<param_name>', p['name'])
        DEF = DEF.replace('<param_type>', p['type'])
        DEFS += DEF
        DEFS += ";\n"

    OUT = OUT.replace('<DEFS>', DEFS)

    return OUT

DEFAULT_RLIST = """list(
<PARAMS>)
"""

def gen_default_rlist(param, struct_name):
    OUT = DEFAULT_RLIST

    PARAMS = ""
    for p in param:
        PARAMS += "  "
        PARAMS += p['name'] + " = NULL" 
        if p != param[-1]:
            PARAMS += ','
        PARAMS += " #" + p['type']
        PARAMS += "\n"
    
    OUT = OUT.replace("<PARAMS>", PARAMS)
    return OUT

def struct_expand(c_struct_path):
    c_struct_contents = readFile(c_struct_path)
    c_struct = get_struct(STRUCT_NAME, c_struct_contents)
    param = get_params_in_struct(c_struct)

    rlist_to_struct_h = gen_list_to_struct_c(param, STRUCT_NAME)
    default_rlist = gen_default_rlist(param, STRUCT_NAME)


    return {'rlist_to_struct_h': rlist_to_struct_h,
            'default_rlist': default_rlist}
    


### MAIN ###
out = struct_expand(STRUCT_FILE_FULLPATH)
writeFile(ADDON_FILE_FULLPATH, out['rlist_to_struct_h'])

### TEST ###
#print out['rlist_to_struct_h']
print out['default_rlist']


