# Load a library, or attempt to install it if it's not available
load_library <- function(Name) {
    if (!library(Name, character.only = TRUE, logical.return = TRUE)) {
        install.packages(Name, repos = "http://lib.stat.cmu.edu/R/CRAN")
    }
}

load_benchmark <- function(Dir) {
    ## Set highest elapsed time we'll keep, allowing us to trim the graphs
    ## after a certain period so we don't graph the long-tail as request
    ## finish up after we've stopped generating load
    max_elapsed = 4740

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
                cpu = cpu, load = load, mem = mem))
}

parse_params <- function(name) {
    # Setup parameters for the script
    params = matrix(c(
      'help',        'h', 0, "logical",
      'width',       'w', 2, "integer",
      'height',      'y', 2, "integer",
      'outfile',     'o', 2, "character",
      'thumbfile',   't', 2, "character",
      'thumbwidth',  'x', 2, "integer",
      'thumbheight', 'z', 2, "integer"
      ), ncol=4, byrow=TRUE)

    # Parse the parameters
    opt = getopt(params)

    if (!is.null(opt$help)) {
        cat(paste(getopt(params, command = basename(arg0), usage = TRUE)))
        q(status=1)
    }

    # Initialize defaults for opt
    if (is.null(opt$width))       { opt$width   = 768 }
    if (is.null(opt$height))      { opt$height  = 1024 }
    if (is.null(opt$outfile))     { opt$outfile = sprintf("graphs/%s.png", name) }
    if (is.null(opt$thumbfile))   { opt$thumbfile = sprintf("graphs/%s_thumb.png", name) }
    if (is.null(opt$thumbwidth))  { opt$thumbwidth = 512 }
    if (is.null(opt$thumbheight)) { opt$thumbheight = 683 }

    return(opt)
}

load_data <- function(dir, tag) {
    data = load_benchmark(dir)

    ## Tag the data with its server
    for (name in names(data)) {
        data[[name]]$server <- tag
    }

    return(data)
}

draw_graph <- function(inputs, opt) {
    data <- load_data(inputs$dirs[1], inputs$tags[1])

    # don't know how to use these variables inside I() below
    span <- 0.3 # smaller means less smoothing, higher more
    size <- 1.5 # line thickness

    plot1 <- qplot(elapsed / 60, X10sec_mean,
                   data = data$requests,
                   color = server,
                   geom = "smooth",
                   span = I(0.3),
                   size = I(1.5),
                   xlab = "Elapsed Mins",
                   ylab = "Response Time (ms)",
                   main = "Latency (lower is better)") + scale_y_log10(breaks = 4**(3:12), labels = 4**(3:12))

    plot2 <- qplot(elapsed / 60, per_second,
                   data = data$X200_responses,
                   color = server,
                   geom = "smooth",
                   span = I(0.3),
                   size = I(1.5),
                   xlab = "Elapsed Mins",
                   ylab = "Requests / sec",
                   main = "Throughput (higher is better)")

    plot3 <- qplot(elapsed / 60, X10sec_mean,
                   data = data$cpu,
                   color = server,
                   geom = "smooth",
                   span = I(0.3),
                   size = I(1.5),
                   xlab = "Elapsed Mins",
                   ylab = "CPU %",
                   main = "CPU Usage (lower is better)")

    plot4 <- qplot(elapsed / 60, X10sec_mean,
                   data = data$mem,
                   color = server,
                   geom = "smooth",
                   span = I(0.3),
                   size = I(1.5),
                   xlab = "Elapsed Mins",
                   ylab = "Free Memory (MB)",
                   main = "Free Memory (higher is better)") + scale_y_continuous(limits=c(0,7680))

    for(i in 2:length(inputs$dirs)) {
        data = load_data(inputs$dirs[i], inputs$tags[i])
        plot1 <- plot1 + geom_smooth(data = data$requests, span = span, size = size, alpha = 0)
        plot2 <- plot2 + geom_smooth(data = data$X200_responses, span = span, size = size, alpha = 0)
        plot3 <- plot3 + geom_smooth(data = data$cpu, span = span, size = size, alpha = 0)
        plot4 <- plot4 + geom_smooth(data = data$mem, span = span, size = size, alpha = 0)
    }

    # Style the grids
    style = opts(panel.grid.major=theme_line("white", size=0.6),
                 panel.grid.minor=theme_line("white", size=0.5))
    plot1 <- plot1 + style
    plot2 <- plot2 + style
    plot3 <- plot3 + style
    plot4 <- plot4 + style


    vplayout <- function(x,y) viewport(layout.pos.row = x, layout.pos.col = y)

    # Print full-size graph
    png(file = opt$outfile, width = opt$width, height = opt$height)
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(4, 1)))
    print(plot1, vp = vplayout(1,1))
    print(plot2, vp = vplayout(2,1))
    print(plot3, vp = vplayout(3,1))
    print(plot4, vp = vplayout(4,1))

    # Print thumbnail graph
    png(file = opt$thumbfile, width = opt$thumbwidth, height = opt$thumbheight)
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(4, 1)))
    print(plot1, vp = vplayout(1,1))
    print(plot2, vp = vplayout(2,1))
    print(plot3, vp = vplayout(3,1))
    print(plot4, vp = vplayout(4,1))

    dev.off()
}

load_library("getopt")
load_library("grid")
load_library("ggplot2")
