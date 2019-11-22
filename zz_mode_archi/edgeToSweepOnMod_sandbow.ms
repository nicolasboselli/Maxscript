filein @"N:\Ressources_Nico\github\00_wip\Maxscript\MODELING_TOOLS\001\cleanspline.ms"


newname = uniquename "shape"
$.createShape newname   false $
select objects[objects.count]

cleanspline $

addmodifier $ (edit_poly())
	
faceAr = (for i = 1 to $.numfaces collect i) as bitarray
$.modifiers[1].SetSelection  #Face faceAr
$.modifiers[1].outlineAmount = -15
$.modifiers[1].SetOperation #outline

-- shell 10cm
myShell = Shell innerAmount: 10 outerAmount:10
addmodifier $ myShell
	
$.pivot = $.center
	
$.material = scenematerials["beton_blanc"] 