import os

import logging
let log = newConsoleLogger(fmtStr = "[$date $time] - $levelname: ")

import core

when isMainModule:
  addHandler(log)
  log(lvlInfo, core.init())
  var count = 0
  for i in commandLineParams():
    log(lvlInfo, "argv[" & $count & "]=" & i)
    count += 1
