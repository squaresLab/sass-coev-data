scratch <- read_csv("research/coev-taas-data/coevScratchOut/hscratch.csv", col_names = TRUE)
scratch$init = "scratch"
reuse <- read_csv("research/coev-taas-data/coevRepReuseOut/hreuse.csv", col_names = TRUE)
reuse$init = "reuse"

data = rbind(scratch,reuse)

