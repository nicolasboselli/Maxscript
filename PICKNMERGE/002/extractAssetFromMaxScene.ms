-- extraction d'asset

layerCount = LayerManager.count 

assetPath = @"M:\Interieur\Cellules\Modelisation\Library\Objects"

-- for i = 0 to layerCount - 1 do 
for i = 0 to 5 do 
(
	
	local theNodes
	l = LayerManager.getLayer i
	if l.name != "0" and l.name != "Amenagement" then
	(
	l.nodes &theNodes
	format "'%\n" l.name
-- 	select theNodes
		


	format "%\n" theNodes
		
	newFilename = assetpath + "\\" + l.name + ".max"
	format "'%\n" newFilename
	saveNodes theNodes newFilename
	
	)
)
-- par calque
	-- selectionner les objets
	-- faire un save selected avec le nom du calque dans le dossier d'asset
-- assetPath = @"M:\Interieur\Cellules\Modelisation\Library\Objects"