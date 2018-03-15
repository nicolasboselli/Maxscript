-- $.EditablePoly.detachToElement #Face keepOriginal:on
-- $.EditablePoly.detachToElement #Face keepOriginal:false

objSel = $selection as array

-- obj = polyop.getFaceSelection $
--faceSel = polyop.getFaceSelection objSel[1]

newName = uniqueName( objSel[1].name + "_part")
-- detach faces
polyop.detachFaces objSel[1] #selection delete: false asNode: true name: newName


-- outline faces of new object
newNode = getnodebyname newName
select newNode

polyop.setFaceSelection newNode #all
newNode.outlineAmount = 5
newNode.EditablePoly.Outline ()

-- add shell on object
myShell = Shell innerAmount:2 outerAmount:2
addmodifier newNode myShell	

appui
-- material
if sceneMaterials["appui"] == undefined then
(
	appui = Standard name: "appui"
)
else
(
	appui = sceneMaterials["appui"]
)
newNode.material = appui

fn makeFloorFN sel =
(
	-- add editpoly
	myEditPoly = Edit_Poly()
	addmodifier sel myEditPoly
	convertto sel editable_poly

	-- outline 15 cm
	polyop.setFaceSelection  sel #all
	sel.outlineAmount = -15
	sel.EditablePoly.Outline ()

	-- shell 10cm
	myShell = Shell innerAmount:10 outerAmount:10
	addmodifier sel myShell

	-- convert to poly
	convertto sel editable_poly

	-- material "interieur"G
	sel.material = sceneMaterials["interieur"]
)

makeFloorFN $