twstat
======

This repository holds Taiwan's national statistics data downloaded from official government website.
Demo
========

[http://g0v.github.com/twstat](http://g0v.github.com/twstat) randomly chooses a statistics file and renders it with [http://d3js.org](http://d3js.org) and [http://npmjs.org/package/px](http://npmjs.org/package/px).


Synopsis
========

One can read PC-AXIS files (*.px) with npm "px" packages, either in server or client side. Check [PX npm page](http://npmjs.org/package/px) for more detail.

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
* TPE: http://163.29.37.101/pxweb2007-tp/dialog/List.txt
* KEE: http://ebas1.ebas.gov.tw/pxweb2007P/PXfile17/List17.txt
* TAO: http://ebas1.ebas.gov.tw/pxweb2007P/PXfile03/List03.txt
* HSZ: http://ebas1.ebas.gov.tw/pxweb2007P/PXfile18/List18.txt
* TXG: Thttp://pxweb.taichung.gov.tw/taichung/dialog/List.txt
* CHA: http://gas.chcg.gov.tw/pxweb2007p/dialog/List.txt
* NAN: http://sta.nantou.gov.tw/pxweb/Dialog/List.txt
* CYI: http://www.chiayi.gov.tw/pxweb2007P/Dialog/List.txt
* CYQ: http://townweb.cyhg.gov.tw/pxweb/Dialog/List.txt
* TNN: http://ebas1.ebas.gov.tw/pxweb2007P/PXfile21/List21.txt (before 2010)
* TNQ: http://pxweb.tainan.gov.tw/Dialog/List.txt
* KHH: http://kcgdg.kcg.gov.tw/pxweb2007p/dialog/List.txt
* ILA: http://ebas1.ebas.gov.tw/pxweb2007P/PXfile02/List02.txt
* TTT: http://ebas1.ebas.gov.tw/pxweb2007P/PXfile14/List14.txt
* JME: http://stat.kinmen.gov.tw/List.txt
* TXG: http://pxweb.taichung.gov.tw/taichung/dialog/List.txt (after 2010)

Missed files
-----------------------
Some files from above source can't be found:

* HSZ
  * AG0404A31A.px
  * JS703A1A.px
  * EP1002A2A.px

* NAN
  * ER0102A1A.px
  * ER0103A1A.px

* TTT
  * CL0310A1A.px
  * CL0311A1A.px

Missed County
-----------------------
Data of following counties still can't be found:

* CYQ: http://townweb.cyhg.gov.tw/pxweb/Dialog/List.txt
* KHH: http://kcgdg.kcg.gov.tw/pxweb2007p/dialog/List.txt
* All counties not listed above.
