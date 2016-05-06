twstat
======

This repository holds Taiwan's national statistics data downloaded from official government website.

Demo
========

[http://g0v.github.com/twstat](http://g0v.github.com/twstat) randomly chooses a statistics file and renders it with [http://d3js.org](http://d3js.org) and [http://npmjs.org/package/px](http://npmjs.org/package/px).


Synopsis
========

One can read PC-AXIS files (`*.px`) with npm "px" packages, either in server or client side. Check [PX npm page](http://npmjs.org/package/px) for more detail.

Server Side
--------

do a `npm install px` command (for installing px) and then: 

        var Px = require("px");
        var fs = require("fs");
        
        fs.readFile("your-px-file", "utf8", function(err, data) {
          obj = new Px(data);
        }

Client Side
--------------

px.js and underscore.js are required. they can be found under npm's px packge, or from this repository: [underscore-min.js](http://g0v.github.com/twstat/js/underscore-min.js) / [px.min.js](http://g0v.github.com/twstat/js/px.min.js). Example code is as following:

        <!-- jquery is only used by this script -->
        <script type="text/javascript" src="underscore-min.js"></script>
        <script type="text/javascript" src="underscore-min.js"></script>
        <script type="text/javascript" src="px.min.js"></script>
        <script type="text/javascript">
          $.ajax("your-px-file").done(function(data) {
             obj = new Px(data);
          }
        </script>

Data Source and Note
=======================

County Level
-----------------------
Data in county granularity are downloaded from [http://ebas1.ebas.gov.tw/pxweb/Dialog/statfile9.asp](http://ebas1.ebas.gov.tw/pxweb/Dialog/statfile9.asp). They contain data from 1998 to 2011 in utf-8 encoding and PC-AXIS format.

Town Level
-----------------------
Data in Town granularity are separated in websites of local government, some still use PXWeb to build their site:

* TPQ: http://ebas1.ebas.gov.tw/pxweb2007P/PXfile01/List01.txt
* TPE: http://163.29.37.101/pxweb2007-tp/dialog/List.txt (?? 2010)
* TXG: http://pxweb.taichung.gov.tw/taichung/dialog/List.txt (after 2010)
* TXG: http://pxweb.taichung.gov.tw/city/dialog/List.txt (before 2010)
* TXQ: http://pxweb.taichung.gov.tw/county/dialog/List.txt (before 2010)
* TNN: http://ebas1.ebas.gov.tw/pxweb2007P/PXfile21/List21.txt (before 2010)
* TNQ: http://pxweb.tainan.gov.tw/Dialog/List.txt (before 2010)
* KHH: http://kcgdg.kcg.gov.tw/pxweb2007p/dialog/List.txt (after 2010)
* KHH: http://kcgdg.kcg.gov.tw/pxweb2007p/dialog/Listo.txt (before 2010)
* KEE: http://ebas1.ebas.gov.tw/pxweb2007P/PXfile17/List17.txt
* TAO: http://ebas1.ebas.gov.tw/pxweb2007P/PXfile03/List03.txt
* HSZ: http://ebas1.ebas.gov.tw/pxweb2007P/PXfile18/List18.txt
* TXG: http://pxweb.taichung.gov.tw/taichung/dialog/List.txt
* CHA: http://gas.chcg.gov.tw/pxweb2007p/dialog/List.txt
* NAN: http://sta.nantou.gov.tw/pxweb/Dialog/List.txt
* CYI: http://www.chiayi.gov.tw/pxweb2007P/Dialog/List.txt
* CYQ: http://townweb.cyhg.gov.tw/pxweb/Dialog/List.txt
* ILA: http://ebas1.ebas.gov.tw/pxweb2007P/PXfile02/List02.txt
* TTT: http://ebas1.ebas.gov.tw/pxweb2007P/PXfile14/List14.txt
* JME: http://stat.kinmen.gov.tw/List.txt

Raw data after 2010 will be in a folder named XXX.new.


Missed Counties (Town Level)
-----------------------
Data of following counties still can't be found:

* HSQ
* MIA
* HUA
* YUN
* PEN
* PIF
* LJF
* TNN (after 2010)
* TPQ (before 2010)
* KHQ (before 2010)

Other Information
=======================

Browser Support Issue
-----------------------
To fix tree rendering issue in PXWeb, try following in dev console:

    function blah() { if(ns.readyState==4) {  onDownloadDone(ns.responseText); } }
    ns = new XMLHttpRequest();
    ns.onreadystatechange = blah;
    ns.open("GET", "List.txt", true);
    ns.setRequestHeader('Content-type', "plain/text; charset=utf-8;");
    ns.send();

How to Use fetch.py
-----------------------
fetch.py can crawl pxweb2007 websites for you. find the List.txt of that site, then:

    ./fetch.py [list-txt-url]

for example:

    ./fetch.py http://pxweb.taichung.gov.tw/taichung/dialog/List.txt

it will create a "tmpdir" folder and download all pc-axis files into it.


Crawler
-----------------------
automatically fetch [statdb.dgbas.gov.tw](http://statdb.dgbas.gov.tw/pxweb/dialog/CityItemlist_n.asp) ( 中華民國統計資訊網 - 縣市重要指標查詢系統 ) by main.ls ( with nodejs pre-installed ):

    npm install # run once to setup environment
    lsc main

files will be kept in raw/county folder.


Copyright
=======================
All data under this repository belongs to whom it should belongs. All sources under this repository  is Copyright c 2012 g0v.tw. It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
