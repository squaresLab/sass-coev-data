library(dplyr)
library(ggplot2)

scratch <- read_csv("research/coev-taas-data/coevScratchOut/hscratch.csv", col_names = TRUE)
scratch$init = "scratch"
reuse <- read_csv("research/coev-taas-data/coevRepReuseOut/hreuse.csv", col_names = TRUE)
reuse$init = "reuse"

data = rbind(scratch,reuse)

dataproc = data %>%
  mutate(scenario_id = group_indices(., payObs,POSObs,webObs,vendObs,empObs,webVal,payVal,posVal))

buggy = filter(dataproc, genGuruExploitAvg > 0)

p <- ggplot(data=dataproc, aes(y=genGuruExploitAvg,x=cumulativeTime/1000,color=factor(init)))
p + geom_line(lwd=1) + facet_grid(dataproc$scenario_id)

p <- p +  theme_bw() + xlab("Cumulative Evaluation Time (seconds)") + ylab("Utility") + scale_color_discrete(name="Initial Population") #+ coord_cartesian(xlim=c(0, 20))
p <- p + theme(text=element_text(size=18), title=element_text(size=18,face="bold"),legend.title=element_text(size=18,face="bold"),legend.text=element_text(size=16),legend.key.size=unit(0.3,"in"),legend.position=c(.7,.6))
p + geom_line(lwd=2)   + scale_y_continuous(labels = function(x) format(x, scientific = TRUE)) + facet_grid(Group.4~Group.3)+ coord_cartesian(xlim=c(1,60)) +scale_colour_manual(values=cbPalette,name="Initial Population")
#+ coord_cartesian(xlim=c(0.5,125)) 

