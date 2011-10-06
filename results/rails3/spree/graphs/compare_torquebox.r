#!/usr/bin/env Rscript --vanilla

# Parse the --file= argument out of command line args and
# determine where base directory is so that we can source
# our common sub-routines
arg0 <- sub("--file=(.*)", "\\1", grep("--file=", commandArgs(), value = TRUE))
dir0 <- dirname(arg0)
source(file.path(dir0, "common.r"))

opt = parse_params("compare_torquebox")

input_dirs <- c("torquebox-2.x/20110930-15:21/data",
                "torquebox-1.1.1/20111005-13:41/data")

server_tags <- c("TorqueBox 2.x",
                 "TorqueBox 1.1.1")

draw_graph(list(dirs=input_dirs, tags=server_tags), opt)
