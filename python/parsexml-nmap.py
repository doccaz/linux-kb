import xml.etree.ElementTree as ET
import collections
tree = ET.parse('equipamentos.xml')

macs=[]
for  elem in tree.iterfind('host/address[@addrtype="mac"]'):
	macs.append(elem.attrib['addr'])

iplist=[]
for  elem in tree.iterfind('host/address[@addrtype="ipv4"]'):
	iplist.append(elem.attrib['addr'])

data=collections.OrderedDict(zip(iplist,macs))

print data

for f in data:
	print f
	print data[f]
