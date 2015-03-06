#!/usr/bin/python
# -*- coding: UTF-8 -*-

from BeautifulSoup import BeautifulSoup as bs
import sys

rawfile = sys.argv[1]
# TODO define file path from pipeing or some other way
myfile = open(rawfile)
myhtml = bs(myfile)
#print(myhtml.findAll('input' value=True))
elements = [(element['name'], element['value'])
        for element in myhtml.findAll('input', value=True)]
for k, v in enumerate(elements):
    print '"' + v[0] + '","' + v[1].encode('ascii', 'ignore') + '"'

