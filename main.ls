require! <[fs fs-extra bluebird cheerio request iconv-lite request-debug]>
#request.debug = true
#request-debug request, (type, data, r) -> console.log ">>>", type, data
# YRANGE = 年份: 1998 ~ 2014 ( 1 ~ 17 )  請自行按最新狀況更新
# CRANGE = 縣市: 總計 ~ 連江 ( 1 ~ 24 )
YRANGE = 17
CRANGE = 24

root = \http://statdb.dgbas.gov.tw/pxweb

fetch-params = -> new bluebird (res, rej) ->
  request {
    url: "#root/dialog/CityItemlist_n.asp"
    encoding: null
    method: \GET
  }, (e,r,b) ->
    if e => return rej "#e ( fetch-params )"
    b = iconv-lite.decode(new Buffer(b), \big5).split \<td
    ret = b.map(-> /<input[^>]+value="([^"]+)"[^>]*>/g.exec(it))
      .filter(->it).map(->it.1).filter(->/\d+/.exec(it))
    ret.sort (a,b) ->
      if b > a => return 1
      if a > b => return -1
      return 0
    res ret

fetch-vars = (params) -> new bluebird (res, rej) ->
  (e,r,b) <- request {
    url: "#root/dialog/CityDbQuery2Px_n.asp"
    method: \POST
    qsStringifyOptions: {arrayFormat: \repeat}
    encoding: null
    form: do
      chkSelTableItem: params or []
  }, _
  if e => return rej "#e ( fetch-vars )"
  ret = iconv-lite.decode(new Buffer(b), \big5)
  url = /url=([^']+)/.exec(ret)
  if !url => return rej "url not parsed ( fetch-vars ) "
  matrix = /ma=([^&]+)&/.exec(url.1)
  if !matrix => return rej "matrxi not parsed ( fetch-vars )"
  res matrix.1

fetch-data = (matrix, length) -> new bluebird (res, rej) ->
  (e,r,b) <- request {
    url: "#root/Dialog/Saveshow.asp"
    method: \POST
    qsStringifyOptions: {arrayFormat: \repeat}
    encoding: null
    form: do
      Valdavarden1: length
      Valdavarden2: YRANGE
      Valdavarden3: CRANGE
      values1: [i for i from 1 to length]
      values2: [i for i from 1 to YRANGE]
      values3: [i for i from 1 to CRANGE]
      matrix: matrix
      root: "../database/CountyStatistics/"
      classdir: "../database/CountyStatistics/"
      noofvar: 3
      elim: "NNN"
      numberstub: 2
      lang: 9
      hasAggregno: 0
      stubceller: YRANGE * length # 前兩個相乘
      headceller: CRANGE # 後面一個
      pxkonv: "px"
  }, _
  if e => return rej "#e ( fetch-data ) "
  ret = iconv-lite.decode(new Buffer(b), \big5)
  res ret

iterate-list = (list, prev = null, count = 1) ->
  if !list or !list.length =>
    console.log "finished."
    return
  prefix = list.0.substring(0,2)
  if prefix != prev => count = 1
  re = new RegExp("^#prefix")
  target = list.filter(-> re.exec(it))
  list = list.filter(->!re.exec(it))
  # break into block with size <= 50 in case the dgbas takes too long to respond.
  if target.length > 50 =>
    release = target.splice 0,50
    list = release ++ list
  console.log "remaining #{list.length} index, deal with #prefix type ( #{target.length} in total )"
  fetch-vars target
    .then (matrix) ->
      fetch-data matrix, target.length
    .then (res) ->
      fs-extra.mkdirs(\raw/county)
      fs.write-file-sync "raw/county/#prefix#{'-'+count}.px", res
      iterate-list list, prefix, count + 1
    .catch ->
      console.log "failed due to ", it

fetch-params!
  .then (list) -> 
    iterate-list list
  .catch ->
    console.log "failed due to ", it
