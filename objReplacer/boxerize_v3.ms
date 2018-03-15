/*
-- maj:
	-- proposer des options pour l'orientation du pivot
	
-- rebuilt:
	-- ecrire une nouvelle fonction pivot on face qui propose l'orientation en X, Y,Z
	/- faire une fonction qui ne nécessite pas un reset xform avant d'être utilisé
*/


fn detach_face_fenetre s =
(

	edges_list = s.EditablePoly.getSelection #edge

	polyop.capHolesByEdge s edges_list
	s.ConvertSelection #edge #face

	s.EditablePoly.ShrinkSelection selLevel: #face

	fenetres_list = s.EditablePoly.getSelection #face

	polyop.detachFaces s fenetres_list delete:true asNode:true name: (uniquename "fenetre") 
)


fn explodeObject s =
(
	num = polyop.getNumFaces s
	numToDetach = #(num)
	detached = #()

	for n in numToDetach do
	(
		facesToDetach = polyop.getElementsUsingFace s #{num}
		fenetre_detach_name = uniquename "fenetre_detach_"
		polyop.detachFaces s facesToDetach delete:true asNode:true name:fenetre_detach_name
		append detached (getnodebyname fenetre_detach_name)
		
		num = polyop.getNumFaces s
		if num > 0 then append numToDetach num
	)
	delete s
	detached
)
-- explodeObject $

fn pivotOnFAce s = 
(
	posCenter = s.center
	bakTM = s.transform
	
	theX = normalize ((polyop.getFaceNormal s 1)*-1)
	theY = normalize (cross [0,0,1] theX )
	theZ= normalize (cross theX theY)
	
	localTM = matrix3   theX theY theZ posCenter

	s.transform = localTM
	
	addmodifier s (xform ())

-- 	s.modifiers[#xform].gizmo.rotation = in coordsys local localTM.rotation
	s.modifiers[#xform].gizmo.rotation = localTM.rotationpart - bakTM.rotationpart
	s.modifiers[#xform].gizmo.position = (in coordsys local s.center)* -1
)




fn boxerize2 selAr amount: 28 =
(
	wireAr = #(green, red, blue, orange, yellow, brown)
	undo on 
	(
		for s in selAr do
		(
			-- reset x form on selection!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- 			resetxform s
-- 			converttopoly s
			
			select s
			$.outlineAmount = 2
			$.EditablePoly.Outline ()
			
			-- detacher chaque element
-- 			polyop.setFaceSelection  s #all
			selArr = explodeObject s

			for o in selArr do
			(
				if (polyop.getNumFaces o)>0 do
				(
					-- reset in place
					pivotOnFAce o
-- 					converttopoly o
					
					-- add shell on object
					myShell = Shell innerAmount:0 outerAmount:amount
					addmodifier o myShell
					o.pivot = o.center
					
					converttopoly o
				
					o.material = undefined	
					
					id = random 1 wireAr.count
					o.wirecolor = wireAr[id]
				)
			)
		)
	)
)

-- myShell = undefined


try(destroydialog boxerizeRLT)catch()
rollout boxerizeRLT "Boxerize"
(
	group "faces:"
	(
	button createFacesBT "create faces"
	)
	
	group "boxerize:"
	(
		spinner boxSizeSP "Size:" type: #worldunits range:[0,1000,28]
		button boxBT "Create Box"
	)
	
	on boxBT pressed do
	(
		sel = selection as array
		if sel.count == 1 do boxerize2 sel amount: boxSizeSP.value
	)
	
	on createFacesBT pressed do 
	(
		if selection == undefined then "selectionne un objet ou des ouvertures"
		else
		(
			if (modPanel.getCurrentObject() == undefined) then  max modify mode
			
			case of
			(
				(subobjectLevel == 0):
				(
					s_array = selection as array
					for s in s_array do 
					(
						select s
						s.EditablePoly.SetSelection #Edge ((polyOp.getOpenEdges s) as bitarray)
						detach_face_fenetre s
					)
				)
					
				(subobjectLevel == 3):
				(
					s = $
					detach_face_fenetre s
				)
				
				default: print "selectionner des objets ou des ouvertures"
			)
		)
	)
)
createdialog boxerizeRLT


/*

pivotOnFAce $


posCenter = $.center

theX = normalize ((polyop.getFaceNormal $ 1)*-1)
theY = normalize (cross [0,0,1] theX )
theZ= normalize (cross theX theY)

localTM = matrix3   theX theY theZ posCenter

bakTM = $.transform

$.transform = localTM

addmodifier $ (xform ())
$.modifiers[#xform].gizmo.rotation =  localTM.rotationpart - bakTM.rotationpart
$.modifiers[#xform].gizmo.position = (in coordsys local $.center)* -1

bakPos = $.pos
in coordsys local $.center 


$.transform = inverse $.transform

in coordsys bakTM localTM.position
xformMat  bakTM localTM 

in coordsys local $.center
localTM.translationpart + bakTM.translationpart
localTM.rotationpart
	
[173.524,1956.8,688.602]

[538.901,2615.82,864.095]
[-455.711,921.731,175.493]


localTM.rotationpart - bakTM.rotationpart

b1 = $Box021.transform
b2 = $Box022.transform

xformMat  b1 b2


b1 = $Box021
b2 = $Box022
about b1 rotate b2 30 z_axis


$.objectTransform
$.transform
	
localTM 
-- pt = point transform: localTM
b1 * b2 * inverse(b1)


$.modifiers[#xform].gizmo.rotation = in coordsys local localTM.rotation
$.modifiers[#xform].gizmo.position = (in coordsys local $.center)* -1

resetxform $
converttopoly $
pivotOnFAce $

boxerize2 #($)
*/