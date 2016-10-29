import sys
SNPlist={}
for l in open(sys.argv[1]):
	ls=l.strip().split('\t')
	SNPlist[ls[1].split('_')[0]]=l.strip()
for l in open(sys.argv[2]):
	ls=l.strip().split('\t')
	if ls[2] in SNPlist:
		print ls[0]+'\t'+ls[1]+'\t'+ls[3]+'\t'+ls[4]+'\t'+ls[5]+'\t'+ls[9]+'\t'+SNPlist[ls[2]]
