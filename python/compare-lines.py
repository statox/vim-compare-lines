#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from LCS import *

a="sazbzcz"
c="abc"

b="toto"

diffLines("abcz", "abc")
diffLines("abzc", "abc")
diffLines("azbc", "abc")
diffLines("zabc", "abc")

diffLines("zazbc", "abc")
diffLines("zabzc", "abc")
diffLines("zabcz", "abc")

diffLines("lorem ipsum", "lorem ipsum")
diffLines("", "lorem ipsum")
diffLines("lorem ipsum", "")


diffLines("loremaipsum", "lorem ipsum")
diffLines("loremaaipsum", "lorem ipsum")
diffLines("loremaaaipsum", "lorem ipsum")
diffLines("loremaaaaipsum", "lorem ipsum")

diffLines("lorem ipsum", "loremaipsum")
diffLines("lorem ipsum", "loremaaipsum")
diffLines("lorem ipsum", "loremaaaipsum")
diffLines("lorem ipsum", "loremaaaaipsum")
