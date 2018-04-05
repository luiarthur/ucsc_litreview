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
