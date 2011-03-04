#!/usr/bin/env Rscript --vanilla

# Parse the --file= argument out of command line args and
# determine where base directory is so that we can source
# our common sub-routines
arg0 <- sub("--file=(.*)", "\\1", grep("--file=", commandArgs(), value = TRUE))
dir0 <- dirname(arg0)

# Load a library, or attempt to install it if it's not available
load_library <- function(Name) {
    if (!library(Name, character.only = TRUE, logical.return = TRUE)) {
        install.packages(Name, repos = "http://lib.stat.cmu.edu/R/CRAN")
    }
}

load_benchmark <- function(Dir) {
    ## Set highest elapsed time we'll keep, allowing us to trim the graphs
    ## after a certain period
    max_elapsed = 16200

    ## Load up request data
    request_columns = c('elapsed', 'per_second', 'X10sec_mean', 'X10sec_stdvar',
                        'max', 'min', 'mean', 'count')
    requests <- read.delim(sprintf("%s/%s", Dir, "request.txt"),
                           header = FALSE, sep = " ",
                           col.names = request_columns)
    requests <- subset(requests, elapsed <= max_elapsed)

    ## Load up responses
    response_columns = c('elapsed', 'per_second', 'count')
    X200_responses <- read.delim(sprintf("%s/%s", Dir, "200.txt"),
                                 header = FALSE, sep = " ",
                                 col.names = response_columns)
    X200_responses <- subset(X200_responses, elapsed <= max_elapsed)

    X302_responses <- read.delim(sprintf("%s/%s", Dir, "302.txt"),
                                 header = FALSE, sep = " ",
                                 col.names = response_columns)
    X302_response <- subset(X302_responses, elapsed <= max_elapsed)

    ## Load up CPU usage
    cpu <- read.delim(sprintf("%s/%s", Dir, "cpu:os_mon@server.txt"),
                      header = FALSE, sep = " ",
                      col.names = request_columns)
    cpu <- subset(cpu, elapsed <= max_elapsed)

    ## Load up load average
    load <- read.delim(sprintf("%s/%s", Dir, "load:os_mon@server.txt"),
                       header = FALSE, sep = " ",
                       col.names = request_columns)
    load <- subset(load, elapsed <= max_elapsed)

    ## Load up free memory
    mem <- read.delim(sprintf("%s/%s", Dir, "freemem:os_mon@server.txt"),
                      header = FALSE, sep = " ",
                      col.names = request_columns)
    mem <- subset(mem, elapsed <= max_elapsed)

    return(list(requests = requests, X200_responses = X200_responses,
                X302_responses = X302_responses, cpu = cpu, load = load,
                mem = mem))
}

load_library("getopt")
load_library("grid")
load_library("ggplot2")

# Setup parameters for the script
params = matrix(c(
  'help',    'h', 0, "logical",
  'width',   'w', 2, "integer",
  'height',  'y', 2, "integer",
  'outfile', 'o', 2, "character"
  ), ncol=4, byrow=TRUE)

# Parse the parameters
opt = getopt(params)

if (!is.null(opt$help)) {
    cat(paste(getopt(params, command = basename(arg0), usage = TRUE)))
    q(status=1)
}

# Initialize defaults for opt
if (is.null(opt$width))   { opt$width   = 1024 }
if (is.null(opt$height))  { opt$height  = 768 }
if (is.null(opt$outfile)) { opt$outfile = "compare.png" }


# b1 = load_benchmark("results/rails2/redmine-1.1.1/torquebox/20110302-16:32/data")
# b2 = load_benchmark("results/rails2/redmine-1.1.1/trinidad/20110302-16:32/data")
# b3 = load_benchmark("results/rails2/redmine-1.1.1/glassfish/20110302-20:30/data")
# b4 = load_benchmark("results/rails2/redmine-1.1.1/passenger_ree/20110302-21:14/data")
# b5 = load_benchmark("results/rails2/redmine-1.1.1/unicorn_ree/20110302-21:26/data")
# b6 = load_benchmark("results/rails2/redmine-1.1.1/thin/20110302-21:08/data")

b1 = load_benchmark("results/rails2/redmine-1.1.1/torquebox/20110303-21:05/data")
b2 = load_benchmark("results/rails2/redmine-1.1.1/passenger_ree/20110303-21:05/data")

png(file = opt$outfile, width = opt$width, height = opt$height)

# Tag the requests frame for each benchmark so we can distinguish
# between them in the legend
for (name in names(b1)) {
    b1[[name]]$server <- 'TorqueBox'
}
for (name in names(b2)) {
    # b2[[name]]$server <- 'Trinidad'
    b2[[name]]$server <- 'Passenger w/ REE'
}
# for (name in names(b3)) {
#     b3[[name]]$server <- 'Glassfish'
# }
# for (name in names(b4)) {
#     b4[[name]]$server <- 'Passenger w/ REE'
# }
# for (name in names(b5)) {
#     b5[[name]]$server <- 'Unicorn w/ REE'
# }
# for (name in names(b6)) {
#     b6[[name]]$server <- 'Thin'
# }

# Compare the req/sec between the datasets
plot1 <- qplot(elapsed / 60, per_second,
               data = b1$X200_responses,
               color = server,
               geom = "smooth",
               size = I(1.5),
               xlab = "Elapsed Mins",
               ylab = "Requests / sec",
               main = "Throughput")
plot1 <- plot1 + geom_smooth(data = b2$X200_responses, size = 1.5, alpha = 0)
# plot1 <- plot1 + geom_smooth(data = b3$requests, size = 1.5, alpha = 0)
# plot1 <- plot1 + geom_smooth(data = b4$requests, size = 1.5, alpha = 0)
# plot1 <- plot1 + geom_smooth(data = b5$requests, size = 1.5, alpha = 0)
# plot1 <- plot1 + geom_smooth(data = b6$requests, size = 1.5, alpha = 0)
# Style the grid
plot1 <- plot1 + opts(panel.grid.major=theme_line("white", size=0.6),
                      panel.grid.minor=theme_line("white", size=0.5))

# plot2 = qplot(elapsed, per_second,
#               data = b1$X200_responses,
#               color = server,
#               geom = "smooth",
#               size = I(1.5),
#               xlab = "Elapsed Secs",
#               ylab = "Responses / sec",
#               main = "Successful Response Throughput")
# plot2 <- plot2 + geom_smooth(data = b2$X200_responses, size = 1.5, alpha = 0)
# plot2 <- plot2 + geom_smooth(data = b3$X200_responses, size = 1.5, alpha = 0)

plot2 <- qplot(elapsed / 60, X10sec_mean,
               data = b1$cpu,
               color = server,
               geom = "smooth",
               size = I(1.5),
               xlab = "Elapsed Mins",
               ylab = "CPU %",
               main = "CPU Usage")
plot2 <- plot2 + geom_smooth(data = b2$cpu, size = 1.5, alpha = 0)
# plot2 <- plot2 + geom_smooth(data = b3$cpu, size = 1.5, alpha = 0)
# plot2 <- plot2 + geom_smooth(data = b4$cpu, size = 1.5, alpha = 0)
# plot2 <- plot2 + geom_smooth(data = b5$cpu, size = 1.5, alpha = 0)
# plot2 <- plot2 + geom_smooth(data = b6$cpu, size = 1.5, alpha = 0)
# Style the grid
plot2 <- plot2 + opts(panel.grid.major=theme_line("white", size=0.6),
                      panel.grid.minor=theme_line("white", size=0.5))

plot3 <- qplot(elapsed / 60, X10sec_mean,
               data = b1$mem,
               color = server,
               geom = "smooth",
               size = I(1.5),
               xlab = "Elapsed Mins",
               ylab = "Free Memory (MB)",
               main = "Free Memory")
plot3 <- plot3 + geom_smooth(data = b2$mem, size = 1.5, alpha = 0)
# plot3 <- plot3 + geom_smooth(data = b3$mem, size = 1.5, alpha = 0)
# plot3 <- plot3 + geom_smooth(data = b4$mem, size = 1.5, alpha = 0)
# plot3 <- plot3 + geom_smooth(data = b5$mem, size = 1.5, alpha = 0)
# plot3 <- plot3 + geom_smooth(data = b6$mem, size = 1.5, alpha = 0)
# Style the grid
plot3 <- plot3 + opts(panel.grid.major=theme_line("white", size=0.6),
                      panel.grid.minor=theme_line("white", size=0.5))

grid.newpage()

pushViewport(viewport(layout = grid.layout(3, 1)))

vplayout <- function(x,y) viewport(layout.pos.row = x, layout.pos.col = y)

print(plot1, vp = vplayout(1,1))
print(plot2, vp = vplayout(2,1))
print(plot3, vp = vplayout(3,1))

dev.off()
