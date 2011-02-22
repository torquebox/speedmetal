#!/usr/bin/env Rscript --vanilla

# Parse the --file= argument out of command line args and
# determine where base directory is so that we can source
# our common sub-routines
arg0 <- sub("--file=(.*)", "\\1", grep("--file=", commandArgs(), value = TRUE))
dir0 <- dirname(arg0)
source(file.path(dir0, "common.r"))

# Setup parameters for the script
params = matrix(c(
  'width',   'w', 2, "integer",
  'height',  'h', 2, "integer",
  'outfile', 'o', 2, "character",
  'dir1',    'i', 1, "character",
  'tag1',    'j', 1, "character",
  'dir2',    'k', 1, "character",
  'tag2',    'l', 1, "character",
  'dir3',    'm', 1, "character",
  'tag3',    'n', 1, "character",
  'dir4',    'p', 1, "character",
  'tag4',    'q', 1, "character",
  'dir5',    'r', 1, "character",
  'tag5',    's', 1, "character"
  ), ncol=4, byrow=TRUE)

# Parse the parameters
opt = getopt(params)

# Initialize defaults for opt
if (is.null(opt$width))   { opt$width   = 1024 }
if (is.null(opt$height))  { opt$height  = 256 }
if (is.null(opt$outfile)) { opt$outfile = "compare.png" }

# Load the benchmark data for each directory
b1 = load_benchmark(opt$dir1)
b2 = load_benchmark(opt$dir2)
if (!is.null(opt$dir3)) { b3 = load_benchmark(opt$dir3) }
if (!is.null(opt$dir4)) { b4 = load_benchmark(opt$dir4) }
if (!is.null(opt$dir5)) { b5 = load_benchmark(opt$dir5) }

# If there is no actual data available, bail
if (nrow(b1$latencies) == 0)
{
  stop("No latency information available to analyze in ", opt$indir)
}

if (nrow(b2$latencies) == 0)
{
  stop("No latency information available to analyze in ", opt$indir)
}

if (!is.null(opt$dir3) && nrow(b3$latencies) == 0)
{
  stop("No latency information available to analyze in ", opt$indir)
}

if (!is.null(opt$dir4) && nrow(b4$latencies) == 0)
{
  stop("No latency information available to analyze in ", opt$indir)
}

if (!is.null(opt$dir5) && nrow(b5$latencies) == 0)
{
  stop("No latency information available to analyze in ", opt$indir)
}

png(file = opt$outfile, width = opt$width, height = opt$height)

# Tag the summary frames for each benchmark so that we can distinguish
# between them in the legend.
b1$summary$server <- opt$tag1
b2$summary$server <- opt$tag2
if (!is.null(opt$tag3)) { b3$summary$server <- opt$tag3 }
if (!is.null(opt$tag4)) { b4$summary$server <- opt$tag4 }
if (!is.null(opt$tag5)) { b5$summary$server <- opt$tag5 }

# Compare the req/sec between the two datasets
plot1 <- qplot(elapsed, total / window,
               data = b1$summary,
               color = server,
               geom = "smooth",
               xlab = "Elapsed Secs",
               ylab = "Req/sec",
               main = "Throughput") + geom_smooth(data = b2$summary)
if (!is.null(opt$dir3)) { plot1 <- plot1 + geom_smooth(data = b3$summary) }
if (!is.null(opt$dir4)) { plot1 <- plot1 + geom_smooth(data = b4$summary) }
if (!is.null(opt$dir5)) { plot1 <- plot1 + geom_smooth(data = b5$summary) }

grid.newpage()

pushViewport(viewport(layout = grid.layout(1, 1)))

vplayout <- function(x,y) viewport(layout.pos.row = x, layout.pos.col = y)

print(plot1, vp = vplayout(1,1))
#print(plot2, vp = vplayout(2,1))
#print(plot3, vp = vplayout(3,1))

dev.off()

