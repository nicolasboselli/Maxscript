-- 	 sizeStr = 
-- s = $
-- cadreSize = 4
-- dormantSize = 4
-- battantSize = 4

-- 		(units.decodeValue "4cm")
-- declaration de la modelisation de fenetre de base
	fn fenetres_base s cadreSize: 4 dormantSize: 4 battantSize: 4 =
	(
	-- application des opérations
		/*
	if cadreSize == unsupplied then cadreSize = 4
	if cadreSize == unsupplied then cadreSize = 4
	if cadreSize == unsupplied then cadreSize = 4
		*/
	subobjectLevel = 0
	
	s.material = sceneMaterials ["fenetre"]
	
	subobjectLevel = 4
	
	s.EditablePoly.setMaterialIndex 1 1
	-- cadre creation
	cadreSizeStr = (cadreSize as string) + "cm"
	s.insetAmount = (units.decodeValue cadreSizeStr)
	s.insetType = 0
	s.EditablePoly.buttonOp #Inset
		
	-- dormant creation
	s.extrusionType = 0
	-- 	 sizeStr = 
	dormantSizeStr = dormantSize as string + "cm"		
	s.faceExtrudeHeight = (units.decodeValue dormantSizeStr)*-1
	s.EditablePoly.buttonOp #Extrude

	s.insetAmount = (units.decodeValue "0.3cm")
	s.insetType = 1
	s.EditablePoly.buttonOp #Inset

	s.faceExtrudeHeight = (units.decodeValue "2.5cm")
	s.faceExtrudeHeight = (units.decodeValue "3cm")
	s.EditablePoly.buttonOp #Extrude
	
	-- battant creation
	battantSizeStr = (battantSize as string) + "cm"
	s.insetAmount = (units.decodeValue battantSizeStr)
	s.insetType = 1
	s.EditablePoly.buttonOp #Inset

	s.faceExtrudeHeight = (units.decodeValue "-2cm")
	s.EditablePoly.buttonOp #Extrude

	s.outlineAmount = (units.decodeValue "-2cm")
	s.EditablePoly.buttonOp #Outline
	
	s.EditablePoly.setMaterialIndex 2 1

	subobjectLevel = 0
	
	-- appliquer les couleurs
	)
	
undo on
(
	fenetres_base $
)