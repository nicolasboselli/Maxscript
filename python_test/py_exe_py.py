
#~ importer le module sys
import sys

#~ ajouter le dossier du module python qu'on veut utiliser dans le sys.path 
onePath = u"N:\Ressources_Nico\github\\00_wip\Maxscript\python_test\sandbox"


sys.path.append (onePath)


for o in sys.path: print o
#~ sys.path.remove(onePath)
#~ importer le module depuis le dossier chargé dans les sys path
#~ from sandbox import sandbox
#~ import sandbox

#~ reload(sandbox)
#~ sandbox.hello()
#~ sandbox.createBox()


#~ anotherPath = u"N:\Ressources_Nico\github\\00_wip\\Maxscript\\transfer_children"

#~ sys.path.append (anotherPath)

#~ import transfer_children
#~ from transfer_children import *
#~ import pyLib
#~ reload(transfer_children)
#~ print pyLib.__file__
#~ pyLib.transferChildren_pyLib.hello()


#~ print pyLib.pyLib.__file__

#~ print sys.path[1]

#~ transferChildren_pyLib.hello()
