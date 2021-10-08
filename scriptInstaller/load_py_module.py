
#!/usr/bin/env python
# -*- coding: utf-8 -*-

#~ importer le module sys
import sys

import pymxs

rt = pymxs.runtime

#~ ajouter le dossier du module python qu'on veut utiliser dans le sys.path 
onePath =  rt.getRoot() + "python_test\sandbox"
sys.path.append (onePath)

#~ print "python modules load:"
for o in sys.path: print(o)
#~ sys.path.remove(onePath)
#~ sys.path.remove("N:\Ressources_Nico\github\\00_wip\Maxscript\python_test\sandbox")
#~ importer le module depuis le dossier charge dans les sys path
#~ from sandbox import sandbox
#~ import sandbox

#~ reload(sandbox)
#~ sandbox.hello()
#~ sandbox.createBox()