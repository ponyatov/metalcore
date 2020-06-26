
import pytest

from metaL import *

class TestObject:
    def test_hello(self):
        hello = Object("hello")
        world = Object("world")
        left = Object("left")
        right = Object("right")
        assert (hello // world << left >> right).test() ==\
            '\n<object:hello>' +\
            '\n\tobject = <object:left>' +\
            '\n\tright = <object:right>' +\
            '\n\t0: <object:world>'

class TestPrimitive:

    def test_integer(self):
        assert Integer('-01').test() ==\
            '\n<integer:-1>'

    def test_number_dot(self):
        assert Number('+02.30').test() ==\
            '\n<number:2.3>'

    def test_hex(self):
        x = Hex('0xDeadBeef')
        assert x.test() == '\n<hex:0xdeadbeef>'
        assert x.val == 3735928559

    def test_bin(self):
        x = Bin('0b1101')
        assert x.test() == '\n<bin:0b1101>'
        assert x.val == 13
