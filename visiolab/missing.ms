showproperties $

-- lister les chemins d'accés 
for i = 1 to (mapPaths.count()) do format "%\n" (mapPaths.get i)
-- sauver les chemin d'accés
-- effacer les chemins d'accés
-- recharger les chemins d'accés
mapPaths.getFullFilePath "Arch41_006_ground.jpg"

-- trouver le chemin d'acces prevus
doesfileexist $.fileName
-- trouver le chemin d'acces chargés
-- comparés


-- trouver tous les chemins d'accés des objets de la scenes
classof $.baseobject
bmpText = getclassinstances Bitmaptexture 
bmpText.count

meditmaterials[activeMeditSlot ].texmap_diffuse.filename