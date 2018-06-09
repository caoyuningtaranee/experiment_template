# read data file
setwd('/Users/Taranee/documents/LINGUIST245/ling245all/politzer2013/data')
library(lme4)
library(tidyverse)
library(lmerTest)
library("ggpubr")
theme_set(theme_bw())
rawdata = read.csv('after_step_6.csv')
rawdata = rawdata[,3:ncol(rawdata)]
colnames(rawdata)[colnames(rawdata)=="segment4"] <- "Quantifier"
colnames(rawdata)[colnames(rawdata)=="condition"] <- "Boundedness"
rawdata$complete_sentence = sub("quotechar", "", rawdata$complete_sentence)

# reformat data
newdata = rawdata %>%
  gather(RegionNum, RT, -workerid, -complete_sentence, -Quantifier, -Boundedness) %>%
  arrange(workerid)
newdata$Subject <- factor(newdata$workerid,
                    levels = c(0,1,2,4,5,7,8,10,11,12),
                    labels = c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J"))

# Models
m <- lmer(RT ~ Quantifier*Boundedness + (1|Subject), newdata)
m <- lmer(RT ~ Quantifier/Boundedness + (1|Subject), newdata)
summary(m)

# Select a sentence and making Figure 1

# get all sentences that start with the same noun
# sentence = split(rawdata$complete_sentence, gsub("^(\\w+).*", "\\1", rawdata$complete_sentence))
example = grepl("^(\"Trevor).*", rawdata$complete_sentence)
# Select one single sentence and divide by Quantifier
instance = rawdata[which(example == TRUE), ]
instance = instance[, 1:(ncol(instance)-1)]
# onlysome
onlysome = split(instance, instance$Quantifier)[instance$Quantifier[1]]
onlysome = as.data.frame(onlysome)
colnames(onlysome) = colnames(instance)
onlysome = onlysome %>%
  gather(RegionNum, RT, -workerid, -complete_sentence, -Quantifier, -Boundedness) %>%
  arrange(RegionNum)
onlysome$segment <- factor(onlysome$RegionNum,
                           levels = c("seg3",  "seg4",  "seg5",  "seg6",  "seg7",  "seg8",  "seg9", "seg10", "seg11"),
                           labels = c("Dr. Johnson said that", "only some of them", "would.", "He added", "that", 
                                      "the rest", "would be", "around", "all summer"))
onlysome$bound <- factor(onlysome$Boundedness,
                               levels = c(onlysome$Boundedness[2], onlysome$Boundedness[3]),
                               labels = c('Upper bound only some', 'Lower bound only some'))
## Why I can't change label here and it's returning "NA"?
ggline(onlysome, x = "segment", y = "RT", color = "Boundedness", 
       add = c("mean_se"), palette = c("orchid1", "steelblue1"),
       ylab = "Reading time (log)", xlab = "Region")
dev.copy(png,"../results/graphs/Figure1only.png")
dev.off()
## How to change legend label??

# some
some = split(instance, instance$Quantifier)[instance$Quantifier[2]]
some = as.data.frame(some)
colnames(some) = colnames(instance)
some = some %>%
  gather(RegionNum, RT, -workerid, -complete_sentence, -Quantifier, -Boundedness) %>%
  arrange(RegionNum)
some$segment <- factor(some$RegionNum,
                           levels = c("seg3",  "seg4",  "seg5",  "seg6",  "seg7",  "seg8",  "seg9", "seg10", "seg11"),
                           labels = c("Dr. Johnson said that", "some of them", "would.", "He added", "that", 
                                      "the rest", "would be", "around", "all summer"))
ggline(some, x = "segment", y = "RT", color = "Boundedness", 
       add = c("mean_se"), palette = c("orchid1", "steelblue1"),
       ylab = "Reading time (log)", xlab = "Region")
dev.copy(png,"../results/graphs/Figure1some.png")
dev.off()

# Making Figure 2
some = split(rawdata, rawdata$Quantifier)[rawdata$Quantifier[3]]
some = as.data.frame(some)
colnames(some) = colnames(rawdata)
some$lagtime = log(exp(some$seg5)+exp(some$seg6)+exp(some$seg7)+exp(some$seg8))
ggplot(some, aes(x=lagtime, y=seg4, color=Boundedness)) +
  geom_point() +
  geom_smooth(method="lm")
dev.copy(png,"../results/graphs/Figure2some.png")
dev.off()

onlysome = split(rawdata, rawdata$Quantifier)[rawdata$Quantifier[1]]
onlysome = as.data.frame(onlysome)
colnames(onlysome) = colnames(rawdata)
onlysome$lagtime = log(exp(onlysome$seg5)+exp(onlysome$seg6)+exp(onlysome$seg7)+exp(onlysome$seg8))
ggplot(onlysome, aes(x=lagtime, y=seg4, color=Boundedness)) +
  geom_point() +
  geom_smooth(method="lm")
dev.copy(png,"../results/graphs/Figure2only.png")
dev.off()
