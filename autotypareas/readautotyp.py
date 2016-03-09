import csv
from collections import defaultdict 

outfile = 'lidareas.txt'

acdict = defaultdict(int)
areacode = 1

fout = open(outfile, 'w')

with open('autotyp.csv', 'rb') as csvfile:
  atreader = csv.reader(csvfile, delimiter=',')
  # skip header
  next(atreader)
  for row in atreader:
    area = row[-2]
    if area in acdict:
      fout.write("%s,%s,%s\n" % (row[0], acdict[area], area))
    else:
      acdict[area] = areacode
      areacode += 1
      fout.write("%s,%s,%s\n" % (row[0], acdict[area], area))

