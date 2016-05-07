require! <[fs fs-extra px]>
fs-extra.mkdirs-sync \csv/county/
files = fs.readdir-sync \raw/county/ .map -> do
  src: "raw/county/#it"
  des: "csv/county/#it".replace(/\.px$/, ".csv")
  name: it

cat = {}
idx = {}
for file in files =>
  prefix = file.name.substring(0,2)
  obj = new px(fs.read-file-sync(file.src, \utf8))
  stubs = obj.metadata.VALUES
  data = obj.data
  count = 0
  if !cat[prefix] => cat[prefix] = ["年度","縣市"]
  cat[prefix] ++= stubs["指標"].map(->it.trim!)
  for i from 0 til stubs["期間"].length
    time = stubs["期間"][i]
    for j from 0 til stubs["縣市"].length
      county = stubs["縣市"][j].trim!
      for k from 0 til stubs["指標"].length 
        index = stubs["指標"][k].trim!
        count = j + stubs["縣市"].length * ( i + k * stubs["期間"].length)
        value = data[count]
        if isNaN(parseInt(value)) => value = "-"
        idx{}[index]{}[time][county] = value

fs-extra.mkdirs-sync \csv/county/index
list = []
for index,times of idx =>
  lines = []
  pairs = [[time,counties] for time,counties of times]
  countynames = [county for county of pairs.0.1]
  lines.push(["年度"] ++ countynames)
  for pair in pairs =>
    lines.push([pair.0] ++ countynames.map(-> pair.1[it]))
  fs.write-file-sync "csv/county/index/#{index}.csv", lines.map(->it.join(\,)).join(\\n)
  list.push(index)
fs.write-file-sync \csv/county/index/index.json, JSON.stringify(list.map(->"#it.csv"))

fs-extra.mkdirs-sync \csv/county/category
for prefix, headers of cat =>
  lines = [headers.map(->"\"#{it}\"")]
  for i from 0 til stubs["期間"].length
    time = stubs["期間"][i]
    for j from 0 til stubs["縣市"].length
      county = stubs["縣市"][j]
      line = [time,county]
      for k from 2 til headers.length =>
        index = headers[k]
        line.push(idx[index][time][county])
      lines.push(line)
  fs.write-file-sync "csv/county/category/#{prefix}.csv", lines.map(->it.join(\,)).join(\\n)
