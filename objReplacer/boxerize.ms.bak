-- filein (modeArchiScriptRoot + "bardageCreator\zinc_creator_bounding_box_fn.ms")

/*
fn returnScriptRoot =
(
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	root
)
*/
-- returnScriptRoot()

-- filein (returnScriptRoot() + "GF/FN_gestion_fenetres.ms")
-- filein (returnScriptRoot() + "zz_mode_archi/XformInPlace.ms")
-- filein (returnScriptRoot() + "GF/explodeObject.ms")

fn resetInPlaceFN sel=
(
	bakPos = sel.position
	bakRot = sel.rotation
	
	sel.rotation = eulerangles 0 0 0
	sel.position = [0,0,0]
	
	resetxform sel 
	ConvertTo sel Editable_Poly
	
	sel.rotation = bakRot
	sel.position = bakPos
)

fn pivotOnFAce s = 
(

	posCenter = s.center

	theX = normalize ((polyop.getFaceNormal s 1)*-1)
	theY = normalize (cross [0,0,1] theX )
	theZ= normalize (cross theX theY)
	localTM = matrix3   theX theY theZ posCenter

	s.transform = localTM
	
	addmodifier s (xform ())

	s.modifiers[#xform].gizmo.rotation = in coordsys local localTM.rotation
	s.modifiers[#xform].gizmo.position = (in coordsys local s.center)* -1
)
-- pivotOnFAce $


	-- detache elements d'un objet un par un
fn detach_elements_selected s =
(
	-- selection de plusieurs elements 
	local selection_globale = s.getselection #face
	local selection_globale_array = selection_globale as array
	local une_selection = polyop.getElementsUsingFace s #{selection_globale_array[1]} as array

	local max_value = selection_globale_array.count
	local pas = 0
	local tour = 0

	-- trouver le nombre d'elements à détacher
	-- compteur d'éléments

		while (selection_globale as array).count != (une_selection as array).count do
		(
			max_value_bak = max_value
			pas = une_selection.count
			(max_value -= pas)
			tour += 1
			
			selection_globale = selection_globale - (une_selection as bitarray)
			selection_globale_array = selection_globale as array
			une_selection = (polyop.getElementsUsingFace s #{selection_globale_array[1]}) as array
			-- print "max_value avant soustraction : " + (max_value_bak as string) + " ; selection:" + (pas as string) + " ; max_value apres soustraction:" + ((max_value) as string) + " ; verif :" + ((max_value + pas) as string)
		)	

	elts_num = tour + 1
	-- print elts_num

	selection_globale = s.getselection #face
	selection_globale_bak = s.getselection #face

	fenetres_array = #()

	-- detachement des elements
	for i = 1 to elts_num do
	(

		selection_globale_array = selection_globale as array
		
		detach1 = polyop.getElementsUsingFace s #{selection_globale_array[1]}
		s.EditablePoly.setSelection #face detach1
		
		fenetre_detach_name = uniquename "fenetre_detach_"
		polyop.detachFaces s detach1 delete:false asNode:true name: fenetre_detach_name
			
		selection_globale = selection_globale - detach1
		
		fenetre_detach = getnodebyname fenetre_detach_name
		fenetre_detach.wirecolor = color (random 0 255) (random 0 255) (random 0 255)
		append fenetres_array fenetre_detach
		
	)

	s.EditablePoly.setSelection #face selection_globale_bak

	polyop.deleteFaces s selection_globale_bak
	return fenetres_array
)

fn boxerize selAr =
(
	undo on 
	(
		for s in selAr do
		(
		-- reset x form on selection!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		resetxform s
		ConvertTo s Editable_Poly

		-- detacher chaque element
		polyop.setFaceSelection  s #all
		selArr = explodeObject s

		-- ## reorient each element

			for o in selArr do
			(
				if (polyop.getNumFaces o)>0 do
				(
					
					pivotOnFAce o
					
					-- config outline
					select o
-- 					format "o name: %\n" o.name
					$.outlineAmount = 2
-- 					format "$ name: %\n" o.name
					$.EditablePoly.Outline ()
					
					-- add shell on object
					myShell = Shell innerAmount:0 outerAmount:28
					addmodifier o myShell
					o.pivot = o.center
					
					resetInPlaceFN o
-- 					resetXformInPlace3 o
					converttopoly o
					
					o.material = undefined
-- 					
				)
			)
		)
	)
)



fn GetAngleFromNormal theNormal =
(
	local theX = normalize theNormal --this is the original vector
	if (dot theX [0,0,1]) > 0.99999 then --if the vector is nearly parallel to Z, assume 0
		eulerangles 0 0 0
	else
	(
		local theY = normalize (cross [0,0,1] theX ) --this is the Y axis orthogonal to the Normal and Up
		local theZ = normalize (cross theY theX) --this is the X orthogonal to Normal and Y
		local theTM = matrix3   theX theY theZ [0,0,0] --this is the matrix3 describing the orientation of the Normal
-- 		print theTM
		theTM.rotationpart as eulerangles --return its Euler rotation 
	)
)


fn boxerize selAr =
(
	undo on 
	(
		for s in selAr do
		(
		-- reset x form on selection!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		resetxform s
		ConvertTo s Editable_Poly

		-- detacher chaque element
		polyop.setFaceSelection  s #all
		selArr = explodeObject s

		-- ## reorient each element

			for o in selArr do
			(
				if (polyop.getNumFaces o)>0 do
				(
					-- set selection
					polyop.setfaceselection o 1
					
					-- get normal orientation
					sel = polyop.getFaceSelection o
					sel = sel as array
					theNormal = polyop.getFaceNormal o sel[1]
					
					newAngle = GetAngleFromNormal theNormal
					newAngle.z = newAngle.z*-1
					
-- 					print "check1"
					-- apply new orientation
					in coordsys local o.rotation =newAngle
					o.objectoffsetrot =newAngle
					o.pivot = o.center
					
					-- select o
					polyop.setfaceselection o #all
					
					-- config outline
					select o
-- 					format "o name: %\n" o.name
					$.outlineAmount = 2
-- 					format "$ name: %\n" o.name
					$.EditablePoly.Outline ()
					
					-- add shell on object
					myShell = Shell innerAmount:0 outerAmount:28
					addmodifier o myShell
					o.pivot = o.center
					
-- 					resetInPlaceFN o
					resetXformInPlace3 o
					converttopoly o
					
					o.material = undefined
-- 					
				)
			)
		)
	)
)

-- myShell = undefined
sel = selection as array
if sel.count == 1 do boxerize sel
	

