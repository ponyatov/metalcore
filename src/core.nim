## metaL core types set

import os
import strutils
import tables

# graph

type Object* = ref object
  ## generic object graph node (frame)
  ##
  ## https://github.com/ponyatov/nimbook/wiki/Object
  ##
  ## this *universal knowledge representation*
  ## in a form of the attributed object graph
  ## was inherited from Marvin Minsky's **Frame model**:
  ## https://web.media.mit.edu/~minsky/papers/Frames/frames.html

  val*: string ## scalar value: object name / string / number
  slot*: Table[string, Object] ## slots = attributes = dictionary
  nest*: seq[Object] ## nested elements = vector = stack = queue
  gid*: uint64 ## global identifier for key/value storage

proc newObject(v: string): Object =
  result = Object(val: v, )
  result.gid = cast[uint64](result.unsafeAddr)

# dump

proc pad(self: Object, depth: int): string =
  ## tree padding
  "\n" & "\t".repeat(depth)

proc sval(self: Object): string =
  ## ASCII representation of `self.val` for dumps
  $self.val

proc stype(self: Object): string =
  ## object type name
  ($self.type).toLower

proc head*(self: Object, prefix: string,
                                          test: bool = false): string =
  ## `<T:V>` header-only object dump
  result = prefix & "<" & self.stype & ":" & self.sval & ">"
  if not test: result &= " @" & self.gid.toHex

proc dump*(self: Object, depth: int = 0, prefix: string = "",
                                          test: bool = false): string =
  ## full tree-form ASCII dump of given subgraph
  # header
  var tree = self.pad(depth) & self.head(prefix, test)
  # slot{}s
  for k, v in self.slot:
    tree &= v.dump(depth+1, prefix = $k&" = ", test = test)
  # nest[]ed
  var idx = 0;
  for j in self.nest:
    tree &= j.dump(depth+1, prefix = $idx & ": ", test = test)
    idx+=1
  # subtree
  return tree

proc `$`*(self: Object): string =
  ## ASCII subgraph representation
  self.dump()

# test

proc test*(self: Object): string = self.dump(test = true)

# operator

proc `[]`*(self: var Object, key: string): var Object =
  ## `A[key]` | fetch subframe by key:string
  self.slot[key]

proc `[]=`*(self: var Object, key: string, that: Object): void =
  ## `A[key]=B ^void` | set slot value by given `key`
  self.slot[key] = that

proc `<<`*(self: var Object, that: Object): var Object =
  ## `A << B -> A[B.type] = B ^A` | assign slot by `.type`
  self.slot[that.stype] = that
  self

proc `>>`*(self: var Object, that: Object): var Object =
  ## `A >> B -> A[B.val] = B ^A` | assign slot by `.val` ue
  self.slot[that.val] = that
  self

proc `//`*(self: var Object, that: Object): var Object =
  ## `A.push(B) ^A` | push as a stack
  self.nest.add(that)
  self

# active

var vm* = newObject("metaL") ## global virtual machine

# init

proc init*(name: string = "metaL"): string =
  doAssert paramCount() > 0, "no source files"
  vm.val = name
  return vm.head("core init: ")
