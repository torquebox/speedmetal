#!/usr/bin/env Rscript --vanilla

# Parse the --file= argument out of command line args and
# determine where base directory is so that we can source
# our common sub-routines
arg0 <- sub("--file=(.*)", "\\1", grep("--file=", commandArgs(), value = TRUE))
dir0 <- dirname(arg0)
source(file.path(dir0, "common.r"))

opt = parse_params("compare_top")

input_dirs <- c("torquebox-2.x/20110930-15:21/data",
                "trinidad/20111005-16:59/data",
                "passenger_ree/20110930-15:41/data",
                "passenger_19/20110930-17:32/data",
                "unicorn_ree/20111003-12:40/data",
                "unicorn_19/20111003-12:40/data")

server_tags <- c("TorqueBox 2.x",
                 "Trinidad",
                 "Passenger w/ REE",
                 "Passenger w/ 1.9.2",
                 "Unicorn w/ REE",
                 "Unicorn w/ 1.9.2")

draw_graph(list(dirs=input_dirs, tags=server_tags), opt)
