twstat
======

This repository holds Taiwan's national statistics data, downloaded from [http://ebas1.ebas.gov.tw/pxweb/Dialog/statfile9.asp](http://ebas1.ebas.gov.tw/pxweb/Dialog/statfile9.asp). They contain data from 1998 to 2011 in utf-8 encoding and PC-AXIS format.

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
          obj = new px(data);
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
