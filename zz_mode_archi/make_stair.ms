s = $
maxFaces = polyop.getNumFaces s
marche = 16

for i = 1 to maxFaces do
(
	facesSel = for j = i to maxfaces collect j
	facesBit = facesSel as bitarray
	polyop.setFaceSelection s facesBit
	move s.selectedFaces [0,0,marche]
)

$.insetAmount = 5
$.EditablePoly.buttonOp #Inset
-- actionMan.executeAction 0 "40472"  -- MAX Script: MAXScript Listener
$.faceExtrudeHeight = 0
$.EditablePoly.buttonOp #Extrude
-- $.EditablePoly.buttonOp #Extrude
$.EditablePoly.MakePlanarIn #Z

move $.selectedFaces [0,0,-3.59375]

$.insetAmount = 5
$.EditablePoly.buttonOp #Inset
$.faceExtrudeHeight = -10
$.EditablePoly.buttonOp #Extrude