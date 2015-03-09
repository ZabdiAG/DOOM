#!/usr/bin/python
# -*- coding: UTF-8 -*-

from BeautifulSoup import BeautifulSoup as bs
import sys

rawfile = sys.argv[1] ## Where is the HTML file to parse
# TODO formname = sys.argv[2] ## Search only for one form the signup one

myfile = open(rawfile)
myhtml = bs(myfile)
# Form tag to get the Action attribute
#myform = myhtml.find('form', formname)

#print form
# Get Input fields and values
elements = [(element['name'], element['value'])
    for element in myhtml.findAll('input',
        attrs={'value':True,
            'name':True})]

for k, v in enumerate(elements):
    print v[0] + ',' + v[1].encode('ascii', 'ignore')
