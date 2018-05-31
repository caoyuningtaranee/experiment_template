#read data file
setwd('/Users/Taranee/documents/LINGUIST245/ling245all/politzer2013/data')
library(tidyverse)
part1 = read.csv('part1.csv')
part2 = read.csv('part2.csv')
part3 = read.csv('part3.csv')
part4 = read.csv('part4.csv')
part5 = read.csv('part5.csv')

# 1. Calculate accuracy rate and exclude participants
rawdata = part1 # 1 was denied

rawdata['corrate'] <- ifelse(rawdata$answer=="\"\"",NA,ifelse(as.character(rawdata$answer)==as.character(rawdata$corans),1,0))
acceptance = c()
for (i in 1:(nrow(rawdata)/198)) {
  average = mean(rawdata$corrate[rawdata$workerid== (i-1)], na.rm=TRUE)
  # print(average)
  if (average < 0.90) {
    acceptance = c(acceptance, 'deny')
  } else {
    acceptance = c(acceptance, 'accept')
  }
}
#check whether there are multiple "denies"
index = which(acceptance =="deny")
for (i in index) {
  rawdata = rawdata[which(rawdata$workerid != (i-1)), ]
}

# 2. Find critical trials, get rid of incorrect trials
rawdata = rawdata[which(rawdata$type == "\"critical\""), ]
rawdata = rawdata[rawdata$corrate == 1 | is.na(rawdata$corrate), ]

# 3. Extract RT
# get number of segments
rawdata$sentence = sub('\\[', '', rawdata$sentence)
rawdata$sentence = sub('\\]', '', rawdata$sentence)
segnum = c()
for (i in 1:nrow(rawdata)) {
  seg = scan(text=rawdata$sentence[i], what="character", sep=",", strip.white=TRUE)
  segnum = c(segnum, sum(nchar(seg)>0))
}
rawdata['segnum'] = segnum

# get responses for each segment
rawdata$response = sub('\\[', '', rawdata$response)
rawdata$response = sub('\\]', '', rawdata$response)
for (i in 1:nrow(rawdata)) {
  time = scan(text=rawdata$response[i], what = "numeric", sep=',', strip.white = TRUE)
  time = as.numeric(time)
  j = 3
  while (j <= rawdata$segnum[i]) {
    title = paste('seg', j, sep = '')
    rawdata[i, title] = time[j+1]
    j = j+1
  }
}

# 4. Compile tables and save it
total = data.frame()
df <- data.frame(workerid=rawdata$workerid,
                 complete_sentence=rawdata$complete_sentence,
                 segment4=rawdata$segment4,
                 condition=rawdata$condition,
                 seg3=rawdata$seg3,
                 seg4=rawdata$seg4,
                 seg5=rawdata$seg5,
                 seg6=rawdata$seg6,
                 seg7=rawdata$seg7,
                 seg8=rawdata$seg8,
                 seg9=rawdata$seg9,
                 seg10=rawdata$seg10,
                 seg11=rawdata$seg11,
                 seg12=rawdata$seg12,
                 stringsAsFactors=FALSE)
total = df
# Now manually loop through all datasets and rbind them to a new table, one at a time
rawdata = part2 # 3 were denied
rawdata = part3 # 3 were denied
rawdata = part4 # 5 were denied
rawdata = part5 # 1 was denied
# remember to change worker id
df$workerid = df$workerid + max(total$workerid) + 1
total = rbind(total, df)
# In total, 12 out of 23 were denied
nrow(total)*(11-3+1) + length(which(!is.na(total$seg12))) # total observations
write.csv(total, file = 'after_step_4.csv')

