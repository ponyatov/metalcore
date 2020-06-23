# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import core

var hello = Object(val: "Hello")
let world = Object(val: "World")

test "hello":
  # check core.init("hello ") == "hello core"
  check hello.test == "\n<object:Hello>"

test "world":
  let res = "\n<object:Hello>\n\t0: <object:World>"
  check (hello // world).test == res
  # mutable push
  check hello.test == res

test "lshift":
  let res = "\n<object:Hello>\n\tobject = <object:left>\n\t0: <object:World>"
  check (hello << Object(val: "left")).test == res
  check hello.test == res

test "rshift":
  let res = "\n<object:Hello>\n\tobject = <object:left>\n\tright = <object:right>\n\t0: <object:World>"
  check (hello >> Object(val: "right")).test == res
  check hello.test == res

test "fetch":
  check hello["right"].test == "\n<object:right>"
