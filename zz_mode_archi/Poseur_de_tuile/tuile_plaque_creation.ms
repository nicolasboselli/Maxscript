

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATION des TUILES
	-- creation de la tuile de base / selection d'une tuile de base
-- 	TuileLong = 20
-- 	TuileLarge = 45
	
-- 	TuileBase = cylinder name: "tuile" sides: 8 rotation: (quat 0.5 -0.5 0.5 -0.5) radius: (TuileLong/2) height: TuileLarge slice: on sliceto: 180 heightsegs: 1
	TuileX = GlobTuileMod.modifiers[1].movex
	TuileY = GlobTuileMod.modifiers[2].movey

	GlobTuileMod2 = copy GlobTuileMod
	GlobTuileMod2.pos = [0, 0, 0]
	GlobTuileMod2.modifiers.count

	for i = 1 to GlobTuileMod2.modifiers.count do
	(
		deleteModifier GlobTuileMod2 1
	)
	
	TuileLong = TuileY
	TuileLarge = TuileX

	
	TuileBase = GlobTuileMod2
	
	ResetXForm TuileBase
	converttopoly TuileBase


-- CREATION DE LA PLAQUE



	-- recup de la taille de la bounding box
	CleanFaceSize=  (CleanFace.min - CleanFace.max)
	ToitLong = abs CleanFaceSize.y
	ToitHaut = abs CleanFaceSize.x
	
	-- calcul du nombre de tuile en longueur
	NumLongFloat = ToitLong / (TuileLong - 4)
	RoundValue = NumLongFloat - (floor NumLongFloat)
	
	NumLongInt = 
	(
			if RoundValue > 0.5 then 
		(
		int (ceil NumLongFloat)
		)
		else
		(
		int (floor NumLongFloat)
		)
	)
	
	-- calcul de l'écartement des tuile en y
	EcartY = ToitLong / NumLongInt

	-- application du modifier clone à la tuile en y
	select TuileBase

	addmodifier TuileBase (clone  ())
	TuileBase.modifiers[#Clone].clones = NumLongInt
	TuileBase.modifiers[#Clone].movey = EcartY

	-- calcul du nombre de tuile en largeur
	NumLargFloat = ToitHaut / (TuileLarge - 4)
	RoundValue = NumLargFloat - (floor NumLargFloat)
	
	NumLargInt = 
	(
			if RoundValue > 0.5 then 
		(
		int (ceil NumLargFloat)
		)
		else
		(
		int (floor NumLargFloat)
		)
	)		

		-- calcul de l'écartement des tuile en x
	EcartX = ToitHaut / NumLargInt
			
	-- application du modifier clone à la tuile en x


	addmodifier TuileBase (clone ())
	TuileBase.modifiers[#Clone].clones = NumLargInt
	TuileBase.modifiers[#Clone].movex = EcartX
	
	
	centerpivot TuileBase
	TuileBase.pos = cleanface.pos
	converttopoly tuilebase
	ResetXForm TuileBase
	converttopoly tuilebase

		

	


