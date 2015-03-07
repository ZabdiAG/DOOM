#!/usr/bin/python
# -*- coding: UTF-8 -*-

from BeautifulSoup import BeautifulSoup as bs
import sys

rawfile = sys.argv[1]
myfile = open(rawfile)
myhtml = bs(myfile)
try:
    elements = [(element['id'], element['value'])
        for element in myhtml.findAll('input', value=True)]
    for k, v in enumerate(elements):
        print v[0] + ',' + v[1].encode('ascii', 'ignore')
        # TODO Quotes or not? print '"' + v[0] + '","' + v[1].encode('ascii', 'ignore') + '"'

except KeyError:
    pass


