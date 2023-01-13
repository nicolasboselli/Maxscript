-- chargement du script rendu non visible
global objReplacerRLT
try(objReplacerRLT.inDialog)catch(filein (getRoot() + @"objReplacer/003/obj_replacer.ms"))
if objReplacerRLT.inDialog then objReplacerRLT.visible = false

-- utilisation du script
sel = selection as array

-- selection de la fenetre à dupliquer
objReplacerRLT.addSelBT.pressed()

-- reselection des gabarits à remplacer
selClean = checkReference2 sel
sel2 = for i = 2 to selClean.count collect selClean[i]
select sel2

--application du script
objReplacerRLT.replaceV2BT.pressed()

