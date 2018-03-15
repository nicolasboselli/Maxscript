from pprint import pprint
import pymxs as pm
import MaxPlus

import pymxs

rt = pymxs.runtime



b = rt.box()
pprint(b.width)
print b.width

print  "size: %(n)04d" % {"n" : 5}
print '%(language)s has %(number)03d quote types.' %  {"language": "Python", "number": 2}
	
