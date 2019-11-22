-- prerequis: charger le module avec des commande python

-- #~ ajouter le dossier du module python qu'on veut utiliser dans le sys.path 
onePath = @"N:\Ressources_Nico\github\\00_wip\Maxscript\python_test\sandbox"
-- sys.path.append(onePath)

pySys = python.import  "sys"
pySys.path.append(onePath)
-- test = pySys.path
classof test

sb = python.import "sandbox"
-- python.reload t
sb.hello()
sb.returnBBsize3