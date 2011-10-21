#!/usr/bin/env Rscript --vanilla

# Parse the --file= argument out of command line args and
# determine where base directory is so that we can source
# our common sub-routines
arg0 <- sub("--file=(.*)", "\\1", grep("--file=", commandArgs(), value = TRUE))
dir0 <- dirname(arg0)
source(file.path(dir0, "common.r"))

opt = parse_params("torquebox")

input_dirs <- c("torquebox-2.x/20111013-01:47/data")

server_tags <- c("TorqueBox 2.x")

draw_graph(list(dirs=input_dirs, tags=server_tags), opt)
