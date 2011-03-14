#!/usr/bin/env Rscript --vanilla

# Parse the --file= argument out of command line args and
# determine where base directory is so that we can source
# our common sub-routines
arg0 <- sub("--file=(.*)", "\\1", grep("--file=", commandArgs(), value = TRUE))
dir0 <- dirname(arg0)
source(file.path(dir0, "common.r"))

opt = parse_params("compare_mri")

input_dirs <- c("passenger/20110312-14:13/data",
                "unicorn/20110312-14:13/data",
                "thin/20110312-14:13/data")

server_tags <- c("Passenger",
                 "Unicorn",
                 "Thin")

draw_graph(list(dirs=input_dirs, tags=server_tags), opt)
