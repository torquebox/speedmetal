#!/usr/bin/env Rscript --vanilla

# Parse the --file= argument out of command line args and
# determine where base directory is so that we can source
# our common sub-routines
arg0 <- sub("--file=(.*)", "\\1", grep("--file=", commandArgs(), value = TRUE))
dir0 <- dirname(arg0)
source(file.path(dir0, "common.r"))

opt = parse_params("compare_top")

input_dirs <- c("torquebox/20110311-14:23/data",
                "trinidad/20110311-19:30/data",
                "passenger_ree/20110311-15:17/data",
                "unicorn_ree/20110311-16:43/data")

server_tags <- c("TorqueBox",
                 "Trinidad",
                 "Passenger w/ REE",
                 "Unicorn w/ REE")

draw_graph(list(dirs=input_dirs, tags=server_tags), opt)
