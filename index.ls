<- $ document .ready

px = null

class twstat
  (data) ->
    @px = new Px data
    @data = @px.data
    console.log @px
    @index = ["數據指標"] ++ @px.metadata.VALUES["指標"].map (.trim!)
    @year  = ["數據年份"] ++ @px.metadata.VALUES["期間"]
    @county = @px.metadata.VALUES["縣市"]
    @table-size = (@year.length - 1) * @county.length

reformat = (v) ->
  u = parseFloat v
  if isNaN u then return "N/A"
  if u<100 then return parseInt(u*100)/100
  u = parseInt u
  if u>1000000 then return "#{parseInt(u/10000)/100}M"
  if u>1000 then return "#{parseInt(u/10)/100}K"
  u

update = ->
  index = parseInt($ \#index-chooser .val!)
  year  = parseInt($ \#year-chooser .val!)
  if index<=0 or year<=0 then return
  start = (index - 1)*px.table-size + px.county.length * (year - 1)
  end   = start + px.county.length
  list = px.data[start til end]
  data = [{"name": n, "value": reformat list[i]} for n,i in px.county when n isnt /總計|地區/]
  counties = d3.select \#content .selectAll \div.county .data data
  divs = counties.enter! .append \div .attr \class \county
  names = divs.append \div.county .append \div .attr \class \name .text -> "#{it.name}"
  values = divs.append \div .attr \class \value .text -> "#{it.value}"
  counties.select \div.name .text (it) -> it.name
  counties.select \div.value .text (it) -> it.value

d3.json \raw/county/index.json, (data) ->
  px-index = data.0
  keys = [k for k of px-index]
  k = keys[parseInt(Math.random! * keys.length)]
  v = px-index[k]
  d3.select \#index-name .text "#k: #v"
  $.ajax "raw/county/#{k}" .done (data) ->
    px := new twstat data
    d3.select \#index-chooser .on \change update
      .selectAll \option .data px.index
      .enter!append \option
      .attr \value (d,i) -> i 
      .text (it, i) -> "#it(#i)"
    d3.select \#year-chooser .on \change update
      .selectAll \option .data px.year
      .enter!append \option
      .attr \value (d,i) -> i 
      .text -> it
