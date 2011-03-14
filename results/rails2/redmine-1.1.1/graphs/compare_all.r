#!/usr/bin/env Rscript --vanilla

# Parse the --file= argument out of command line args and
# determine where base directory is so that we can source
# our common sub-routines
arg0 <- sub("--file=(.*)", "\\1", grep("--file=", commandArgs(), value = TRUE))
dir0 <- dirname(arg0)
source(file.path(dir0, "common.r"))

opt = parse_params("compare_all")

input_dirs <- c("torquebox/20110311-14:23/data",
                "trinidad/20110311-19:30/data",
                "glassfish/20110312-14:13/data",
                "passenger_ree/20110311-15:17/data",
                "unicorn_ree/20110311-16:43/data",
                "passenger/20110312-14:13/data",
                "unicorn/20110312-14:13/data",
                "thin/20110312-14:13/data")

server_tags <- c("TorqueBox",
                 "Trinidad",
                 "GlassFish",
                 "Passenger w/ REE",
                 "Unicorn w/ REE",
                 "Passenger",
                 "Unicorn",
                 "Thin")

draw_graph(list(dirs=input_dirs, tags=server_tags), opt)
