# read data file
setwd('/Users/Taranee/documents/LINGUIST245/ling245all/politzer2013/data')
library(lme4)
library(tidyverse)
library(lmerTest)
library("ggpubr")
library(sjPlot)
library(sjmisc)
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
newdata$bound <- as.character(newdata$Boundedness)
newdata$bound <- factor(newdata$bound,
                         levels = c(newdata$bound[3], newdata$bound[1]),
                         labels = c('Upper bound', 'Lower bound'))
newdata$Quantifier <- as.character(newdata$Quantifier)
newdata$Quantifier <- factor(newdata$Quantifier,
                        levels = c(newdata$Quantifier[1], newdata$Quantifier[3]),
                        labels = c('only', 'some'))

# Models
n <- lmer(RT ~ RegionNum*Quantifier*Boundedness + (1|Subject) + (1|complete_sentence), newdata)
summary(n)
sjt.lmer(n, show.se = TRUE, string.p = "t value")

o <- lmer(RT ~ RegionNum/(Quantifier/Boundedness) + (1|Subject) + (1|complete_sentence), newdata)
summary(o)
sjt.lmer(o, show.se = TRUE, string.p = "t value")
# Select a sentence and making Figure 1
# Make the overall picture
df = newdata[newdata$Quantifier==newdata$Quantifier[3],]
df$bound <- factor(df$bound,
                   levels = c('Upper bound', 'Lower bound'),
                   labels = c('Upper bound some', 'Lower bound some'))
ggline(df, x = "RegionNum", y = "RT", color = "bound", 
       add = c("mean_se"), palette = c("steelblue1", "orchid1"),
       ylab = "Reading time (log)", xlab = "Region")
dev.copy(png,"../results/graphs/overall.png")
dev.off()

# get all sentences that start with the same noun
sentence = split(rawdata$complete_sentence, gsub("^(\\w+).*", "\\1", rawdata$complete_sentence))
# Select one single sentence and divide by Quantifier
example = grepl("^(\"Trevor).*", rawdata$complete_sentence)
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
onlysome$bound <- as.character(onlysome$Boundedness)
onlysome$bound <- factor(onlysome$bound,
                               levels = c(onlysome$bound[2], onlysome$bound[1]),
                               labels = c('Upper bound only some', 'Lower bound only some'))
ggline(onlysome, x = "segment", y = "RT", color = "bound", 
       add = c("mean_se"), palette = c("steelblue1", "orchid1"),
       ylab = "Reading time (log)", xlab = "Region")
dev.copy(png,"../results/graphs/Figure1a_only.png")
dev.off()

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
some$bound <- as.character(some$Boundedness)
some$bound <- factor(some$bound,
                         levels = c(some$bound[1], some$bound[2]),
                         labels = c('Upper bound some', 'Lower bound some'))
ggline(some, x = "segment", y = "RT", color = "bound", 
       add = c("mean_se"), palette = c("steelblue1", "orchid1"),
       ylab = "Reading time (log)", xlab = "Region")
dev.copy(png,"../results/graphs/Figure1a_some.png")
dev.off()

# Select another sentence and divide by Quantifier
example = grepl("^(\"David).*", rawdata$complete_sentence)
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
                           labels = c("Brandon said that", "only some of them", "would.", "He added", "that", 
                                      "the rest", "would be", "single player", "only"))
onlysome$bound <- as.character(onlysome$Boundedness)
onlysome$bound <- factor(onlysome$bound,
                         levels = c(onlysome$bound[2], onlysome$bound[1]),
                         labels = c('Upper bound only some', 'Lower bound only some'))
ggline(onlysome, x = "segment", y = "RT", color = "bound", 
       add = c("mean_se"), palette = c("steelblue1", "orchid1"),
       ylab = "Reading time (log)", xlab = "Region")
dev.copy(png,"../results/graphs/Figure1b_only.png")
dev.off()

# some
some = split(instance, instance$Quantifier)[instance$Quantifier[2]]
some = as.data.frame(some)
colnames(some) = colnames(instance)
some = some %>%
  gather(RegionNum, RT, -workerid, -complete_sentence, -Quantifier, -Boundedness) %>%
  arrange(RegionNum)
some$segment <- factor(some$RegionNum,
                       levels = c("seg3",  "seg4",  "seg5",  "seg6",  "seg7",  "seg8",  "seg9", "seg10", "seg11"),
                       labels = c("Brandon said that", "some of them", "would.", "He added", "that", 
                                  "the rest", "would be", "single player", "only"))
some$bound <- as.character(some$Boundedness)
some$bound <- factor(some$bound,
                     levels = c(some$bound[1], some$bound[2]),
                     labels = c('Upper bound some', 'Lower bound some'))
ggline(some, x = "segment", y = "RT", color = "bound", 
       add = c("mean_se"), palette = c("steelblue1", "orchid1"),
       ylab = "Reading time (log)", xlab = "Region")
dev.copy(png,"../results/graphs/Figure1b_some.png")
dev.off()
# Making Figure 2
some = split(rawdata, rawdata$Quantifier)[rawdata$Quantifier[3]]
some = as.data.frame(some)
colnames(some) = colnames(rawdata)
some$bound <- as.character(some$Boundedness)
some$bound <- factor(some$bound,
                     levels = c(some$bound[1], some$bound[2]),
                     labels = c('Upper bound', 'Lower bound'))
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
onlysome$bound <- as.character(onlysome$Boundedness)
onlysome$bound <- factor(onlysome$bound,
                     levels = c(onlysome$bound[3], onlysome$bound[1]),
                     labels = c('Upper bound', 'Lower bound'))
ggplot(onlysome, aes(x=lagtime, y=seg4, color=Boundedness)) +
  geom_point() +
  geom_smooth(method="lm")
dev.copy(png,"../results/graphs/Figure2only.png")
dev.off()

# Chi-square/T-test for lag time from model comparison?
some$rawlag = exp(some$seg5)+exp(some$seg6)+exp(some$seg7)+exp(some$seg8)
average = mean(some$rawlag, na.rm = TRUE)
average

newsome = some[,c("workerid", "bound", "rawlag", "seg8", "seg9")]
mod1 = lmer(-1 + newsome$seg8 ~ rawlag+bound + (1|workerid), newsome)
mod2 = lmer(-1 + newsome$seg8 ~ rawlag:bound + (1|workerid), newsome)
anova(mod1, mod2)

t.test(some$lagtime, onlysome$lagtime)

# T-test
t = t.test(rawdata$seg8[rawdata$Quantifier==rawdata$Quantifier[1]]~rawdata$Boundedness[rawdata$Quantifier==rawdata$Quantifier[1]])
t # reading time on "the rest" (seg8) for "some" condition by Boundedness
o = t.test(rawdata$seg8[rawdata$Quantifier==rawdata$Quantifier[3]]~rawdata$Boundedness[rawdata$Quantifier==rawdata$Quantifier[3]])
o # reading time on "the rest" (seg8) for "only some" condition by Boundedness
