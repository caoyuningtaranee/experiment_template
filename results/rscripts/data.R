#read data file
setwd('/Users/Taranee/documents/LINGUIST245/ling245all/politzer2013/data')
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
# In total, 13 out of 23 were denied
nrow(total)*(11-3+1) + length(which(!is.na(total$seg12)))
# total observations = 4327
write.csv(total, file = 'after_step_4.csv')

# 5. Trim by mean and SD
origin = read.csv('after_step_4.csv')
rawdata = origin
column = c('seg3', 'seg4', 'seg5', 'seg6', 'seg7', 'seg8', 'seg9', 'seg10', 'seg11', 'seg12')
# Remove any RT < 150
rawdata[,column][rawdata[,column] < 150] <- NA
# Remove any RT > 3*mean(RT of the region)
rawdata$seg3[rawdata$seg3 > 3 * mean(rawdata$seg3, na.rm = TRUE)] <- NA
rawdata$seg4[rawdata$seg4 > 3 * mean(rawdata$seg4, na.rm = TRUE)] <- NA
rawdata$seg5[rawdata$seg5 > 3 * mean(rawdata$seg5, na.rm = TRUE)] <- NA
rawdata$seg6[rawdata$seg6 > 3 * mean(rawdata$seg6, na.rm = TRUE)] <- NA
rawdata$seg7[rawdata$seg7 > 3 * mean(rawdata$seg7, na.rm = TRUE)] <- NA
rawdata$seg8[rawdata$seg8 > 3 * mean(rawdata$seg8, na.rm = TRUE)] <- NA
rawdata$seg9[rawdata$seg9 > 3 * mean(rawdata$seg9, na.rm = TRUE)] <- NA
rawdata$seg10[rawdata$seg10 > 3 * mean(rawdata$seg10, na.rm = TRUE)] <- NA
rawdata$seg11[rawdata$seg11 > 3 * mean(rawdata$seg11, na.rm = TRUE)] <- NA
rawdata$seg12[rawdata$seg12 > 3 * mean(rawdata$seg12, na.rm = TRUE)] <- NA
# Remove any RT > mean(person) + 3*SD(person) or RT < mean(person) - 3*SD(person)
average = rowMeans(rawdata[,(ncol(rawdata)-9):ncol(rawdata)], na.rm = TRUE)
for (i in 1:nrow(rawdata)) {
  rawdata[i,column][rawdata[i,column] < average[i] - 3 * sd(rawdata[i,column], na.rm = TRUE) |
                    rawdata[i,column] > average[i] + 3 * sd(rawdata[i,column], na.rm = TRUE)] <- NA
}
# 6. Log transformation
rawdata[,(ncol(rawdata)-9):ncol(rawdata)] = log(rawdata[,(ncol(rawdata)-9):ncol(rawdata)])
# Total observations for statistical analysis = 4312
sum(colSums(!is.na(rawdata))[(ncol(rawdata)-9):ncol(rawdata)])
# Write file
write.csv(rawdata, file = 'after_step_6.csv')
