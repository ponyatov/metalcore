
import logging
let logger = newConsoleLogger(fmtStr = "[$date $time] - $levelname: ")

import core

when isMainModule:
  addHandler(logger)
  logger.log(lvlInfo, core.init("metaL "))
