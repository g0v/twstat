#!/usr/bin/python
import re,sys,subprocess,os,glob

if len(sys.argv)<2:
  print("usage: fetch.py list-txt-url")
  print("list-txt-url: e.g., http://pxweb.taichung.gov.tw/taichung/Dialog/List.txt")
  sys.exit(0)

listtxt = os.path.basename(sys.argv[1])
siteurl = os.path.dirname(sys.argv[1])
if siteurl[-1]!="/": siteurl+="/"

if not os.path.exists("tmpdir"): os.makedirs("tmpdir")

if os.path.exists("tmpdir/list.txt"): os.remove("tmpdir/list.txt") 
proc = subprocess.Popen("wget -O tmpdir/list.txt %s%s"%(siteurl, listtxt),
  stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
proc.communicate(None)

if not os.path.exists("tmpdir/list.txt"):
  print("can't find %s%s"%(siteurl, listtxt))
  sys.exit(-1)

dbs = [[x.group(1),x.group(2)] for x in filter(lambda x:x, 
  [re.search("varval\.asp\?ma=([^&]+)&.*path=([^&]+)&",x.strip()) for x in open("tmpdir/list.txt","r").readlines()])]

print("total %d db fetched."%len(dbs))

# todo: use path inside list.txt
#varval = "%sDialog/varval.asp"%siteurl
#saveshow = "%sDialog/Saveshow.asp"%siteurl
varval = "%sDialog/varval.asp"%siteurl
saveshow = "%sDialog/Saveshow.asp"%siteurl

count=0
print("fetching varval.asp for each db...")
for name,path in dbs:
  count+=1
  if os.path.exists("tmpdir/%s.list"%name): continue
  proc = subprocess.Popen('wget -O tmpdir/%s.list "%s?ma=%s&path=%s"'%(
    name, varval, name, path
  ), stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
  proc.communicate(None)
  print("%d/%d"%(count,len(dbs)))


count=0
print("parsing args for each db's varval.asp...")
for name,path in dbs:
  item = "tmpdir/%s.list"%name
  if not os.path.exists(item): continue
  count+=1
  maxs,max,args,no = [],0,[],1
  result = [int(x.group(1)) for x in filter(lambda x:x, 
    [re.search('<option VALUE="(\d+)"',x.strip()) for x in open(item, "r").readlines()])]
  if len(result)<=0:
    print("warning: failed to parse %s. skipped."%item)
    continue
  for item in result:
    if max>=item: 
      maxs.append(max)
      max = 0
    else: max = item
  maxs.append(item)
  for v in maxs:
    args.append(["Valdavarden%d"%no, str(v)])
    for i in xrange(1,v+1):
      args.append(["values%d"%no, str(i)])
    no+=1
  args += [
    ["noofvar", str(len(maxs))],
    ["matrix", name],
    ["root", re.sub("/", "%2F", path)],
    ["classdir", re.sub("/", "%2F", path)],
    ["pxkonv", "px"]
  ]
  result = "&".join(["=".join(x) for x in args])
  fp = open("tmpdir/%s.args"%name, "w")
  fp.write(result)
  fp.close()
  print("%d/%d"%(count,len(dbs)))

count = 0
print("fetch px database files using parsed args...")
for name,path in dbs:
  item = "tmpdir/%s.args"%name
  if not os.path.exists(item): continue
  count+=1
  if os.path.exists("%s.px"%name): continue
  proc = subprocess.Popen('wget -O %s --post-file="%s" "%s"'%(
    "tmpdir/%s.px"%name, item, saveshow
  ), stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
  proc.communicate()
  print("%d/%d"%(count,len(dbs)))
