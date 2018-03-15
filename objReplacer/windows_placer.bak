-- filein (modeArchiScriptRoot + "bardageCreator\zinc_creator_bounding_box_fn.ms")

-- filein "J:\GitHub_repo\DEV_maxscript\00_wip\GF\FN_gestion_fenetres.ms"
-- filein "J:\github\DEV_maxscript\00_wip\GF\FN_gestion_fenetres.ms"
filein"J:/GitHub_repo/DEV_maxscript/00_wip/GF/FN_gestion_fenetres.ms"
filein "J:/GitHub_repo/DEV_maxscript/00_wip/zz_mode_archi/XformInPlace.ms"
/*##############################cubizator ########################"*/


/*
function to boxerize selection
*/
-- $.pivot

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
		print theTM
		theTM.rotationpart as eulerangles --return its Euler rotation 
	)
)

-- reset x form on selection!!!!!!!!!!!!!!!!!!!!!!!!!!!!
resetxform $ 
ConvertTo $ Editable_Poly

-- detacher chaque element
polyop.setFaceSelection  $ #all
selArr = detach_elements_selected $

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
		
		-- apply new orientation
		in coordsys local o.rotation =newAngle
		o.objectoffsetrot =newAngle
		o.pivot = o.center
		
		-- select o
		polyop.setfaceselection o #all
		
		-- config outline
		select o
		$.outlineAmount = 2
		$.EditablePoly.Outline ()
		
		-- add shell on object
		myShell = Shell innerAmount:0 outerAmount:28
		addmodifier o myShell
		
		resetInPlaceFN o
		o.material = undefined
	)
)

