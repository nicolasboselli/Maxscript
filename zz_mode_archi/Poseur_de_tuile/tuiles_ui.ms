
TuileX
TuileY
GlobTuileMod
GlobTuileMod2

rollout TuileSel "Selection de la tuile"
(	
		
	pickbutton TuileChoice "selectionner une tuile"
	button MakeRoof "faire le toit"
	
	on TuileChoice picked TuileMod do
	(
		TuileChoice.text = TuileMod.name

		GlobTuileMod = TuileMod
		
-- 		TuileX = GlobTuileMod.modifiers[1].movex
-- 		TuileY = GlobTuileMod.modifiers[2].movey

	)
	
	on MakeRoof pressed do 
	(
		-- nettoyage de la tuile
-- 		GlobTuileMod2 = copy GlobTuileMod
-- 		GlobTuileMod2.pos = [0, 0, 0]
-- 		GlobTuileMod2.modifiers.count

-- 		for i = 1 to GlobTuileMod2.modifiers.count do
-- 		(
-- 			deleteModifier GlobTuileMod2 1
-- 		)
		
		-- 	creation de la plaque
		MakeRoofScriptA = openFile ((getdir #maxroot) + "Scripts/tuiles/tuile_prepa.ms")
		MakeRoofScriptB = openFile ((getdir #maxroot) + "Scripts/tuiles/tuile_plaque_creation.ms")
		MakeRoofScriptC = openFile ((getdir #maxroot) + "Scripts/tuiles/tuile_plaque_decoupe.ms")
		execute MakeRoofScriptA
		execute MakeRoofScriptB
		execute MakeRoofScriptC 
		
		GlobTuileMod2 = undefined
	)
)

createdialog TuileSel

-- test = "" as stringstream 
-- test = 
-- openFile "C:/Users/nicolas/Desktop/maxscript/process_fenetre/test.ms"
-- openFile #maxRoot + "\\"
-- MakeTuile = openFile "C:/Program Files/Autodesk/3ds Max 2011/Scripts/tuiles/tuiles_starter3.ms"
-- execute MakeTuile


-- GlobTuileMod2 = copy GlobTuileMod
-- GlobTuileMod2.pos = [0, 0, 0]
-- GlobTuileMod2.modifiers.count

-- for i = 1 to GlobTuileMod2.modifiers.count do
-- (
-- 	deleteModifier GlobTuileMod2 1
-- )