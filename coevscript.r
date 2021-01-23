library(dplyr)
library(ggplot2)
library("readr", lib.loc="~/R/x86_64-pc-linux-gnu-library/4.0")
library("plyr")

scratch <- read_csv("research/coev-taas-data/coevScratchOut/hscratch.csv", col_names = TRUE)
scratch$init = "scratch"
reuse <- read_csv("research/coev-taas-data/coevRepReuseOut/hreuse.csv", col_names = TRUE)
reuse$init = "reuse"
single <- read_csv("research/coev-taas-data/coevSingleReuse/hsingle.csv", col_names = TRUE)
single$init = "single"

data = rbind(scratch,reuse)
data = rbind(data,single)

data$init = revalue(data$init,c("reuse"="repertoire"))

dataproc = data %>%
  mutate(scenario_id = group_indices(., payObs,POSObs,webObs,vendObs,empObs,webVal,payVal,posVal))

#buggy = filter(dataproc, genGuruExploitAvg > 0)

dataprocsub = subset(dataproc,dataproc$generation < 20)

# colorblind color scheme
cbPalette <- c("#762a83","#af8dc3","#e7d4e8","#d9f0d3","#7fbf7b","#1b7837")
cbPalette <- c("#762a83","#7fbf7b")
cbPalette <- c("#762a83","#7fbf7b","#1b7837")

# guru by gen
# 9 x 8 in
p <- ggplot(data=dataprocsub, aes(y=genGuruExploitAvg,x=factor(generation),color=factor(init)))
p <- p + xlab("Generation of Evolution") + ylab("Average Guru Exploitability") + theme_bw()
p <- p + scale_colour_manual(values=cbPalette,name="Initial Population")
p <- p + theme(text=element_text(size=18), title=element_text(size=18,face="bold"),legend.title=element_text(size=14,face="bold"),legend.text=element_text(size=14),legend.key.size=unit(0.2,"in"),legend.position=c(.875,.085))
p + geom_boxplot(lwd=1) + facet_grid(factor(dataprocsub$numMutations))

# guru by time
# 9 x 4.5
dataprocsubagg <- aggregate(dataprocsub,by=list(dataprocsub$init,dataprocsub$numMutations,dataprocsub$generation), FUN=mean,na.rm=TRUE)

p <- ggplot(data=dataprocsubagg, aes(y=genGuruExploitAvg,x=cumulativeTime/1000,color=factor(Group.1)))
p <- p + xlab("Cumulative Evaluation Time (seconds)") + ylab("Average Guru Exploitability") + theme_bw()
p <- p + scale_colour_manual(values=cbPalette,name="Initial\nPopulation")
p <- p + theme(panel.margin = unit(1, "lines"), text=element_text(size=18), title=element_text(size=18,face="bold"),legend.title=element_text(size=14,face="bold"),legend.text=element_text(size=14),legend.key.size=unit(0.2,"in"))#,legend.position=c(.7,.125))
p + geom_line(lwd=1) + facet_grid(factor(dataprocsubagg$Group.2))


# reference code below, not production
p <- p +  theme_bw() + xlab("Cumulative Evaluation Time (seconds)") + ylab("Utility") + scale_color_discrete(name="Initial Population") #+ coord_cartesian(xlim=c(0, 20))
p <- p + theme(text=element_text(size=18), title=element_text(size=18,face="bold"),legend.title=element_text(size=18,face="bold"),legend.text=element_text(size=16),legend.key.size=unit(0.3,"in"),legend.position=c(.7,.6))
p + geom_line(lwd=2)   + scale_y_continuous(labels = function(x) format(x, scientific = TRUE)) + facet_grid(Group.4~Group.3)+ coord_cartesian(xlim=c(1,60)) +scale_colour_manual(values=cbPalette,name="Initial Population")
#+ coord_cartesian(xlim=c(0.5,125)) 
#+ coord_cartesian(xlim=c(1,24.95))

