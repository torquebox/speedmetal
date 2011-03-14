#!/usr/bin/env Rscript --vanilla

# Parse the --file= argument out of command line args and
# determine where base directory is so that we can source
# our common sub-routines
arg0 <- sub("--file=(.*)", "\\1", grep("--file=", commandArgs(), value = TRUE))
dir0 <- dirname(arg0)
source(file.path(dir0, "common.r"))

opt = parse_params("compare_ree")

input_dirs <- c("passenger_ree/20110311-15:17/data",
                "unicorn_ree/20110311-16:43/data",
                "passenger/20110312-14:13/data",
                "unicorn/20110312-14:13/data")

server_tags <- c("Passenger w/ REE",
                 "Unicorn w/ REE",
                 "Passenger",
                 "Unicorn")

draw_graph(list(dirs=input_dirs, tags=server_tags), opt)
