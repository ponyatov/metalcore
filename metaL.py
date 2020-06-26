## metaL core /Python/

import os, sys

## graph

class Object:
    def __init__(self, V):
        self.val = V
        self.slot = {}
        self.nest = []
        self.id = '%x' % id(self)

    ## dump

    def __repr__(self): return self.dump()

    def test(self): return self.dump(test=True)

    def dump(self, dumped=None, depth=0, prefix='', test=False):
        # header
        tree = self._pad(depth) + self.head(prefix, test)
        # block cycles
        if not depth:
            dumped = []
        if self in dumped:
            return tree + ' _/'
        else:
            dumped.append(self)
        # slot{}s
        for i in self.slot:
            tree += self.slot[i].dump(dumped, depth + 1, '%s = ' % i, test)
        # nest[]ed
        idx = 0
        for j in self.nest:
            tree += j.dump(dumped, depth + 1, '%i: ' % idx, test)
            idx += 1
        # subtree
        return tree

    def head(self, prefix='', test=False):
        hdr = '%s<%s:%s>' % (prefix, self._type(), self._val())
        if not test:
            hdr += ' @%s' % self.id
        return hdr

    def _pad(self, depth): return '\n' + '\t' * depth

    def _type(self): return self.__class__.__name__.lower()
    def _val(self): return '%s' % self.val

    ## operator

    def __getitem__(self, key):
        return self.slot[key]

    def __setitem__(self, key, that):
        self.slot[key] = that
        return self

    def __lshift__(self, that):
        return Object.__setitem__(self, that._type(), that)

    def __rshift__(self, that):
        return Object.__setitem__(self, that._val(), that)

    def __floordiv__(self, that):
        self.nest.append(that)
        return self

## primitive

class Primitive(Object):
    def eval(self, ctx): return self

class Symbol(Primitive):
    # special case: evaluates by name in context
    def eval(self, ctx):
        return ctx[self.val]

class String(Primitive):
    pass

class Number(Primitive):
    def __init__(self, V):
        Primitive.__init__(self, float(V))

class Integer(Number):
    def __init__(self, V):
        Primitive.__init__(self, int(V))

class Hex(Integer):
    def __init__(self, V):
        Primitive.__init__(self, int(V[2:], 0x10))

    def _val(self):
        return hex(self.val)

class Bin(Integer):
    def __init__(self, V):
        Primitive.__init__(self, int(V[2:], 0x02))

    def _val(self):
        return bin(self.val)
