vrLibText = getclassinstances  Bitmaptexture target: vrLib

-- vrLibText = vrLib
for m in vrLibText do
(
	if doesfileexist m.filename then
	(
		
		if matchpattern m.filename pattern: "D:\RESSOURCES*" then
		(
			newName = substitutestring m.filename "D:\RESSOURCES" "N:\Ressources_Nico"
			if doesfileexist newName then format "NEWFILE: %\n" newname
		)
		else
		(
			format "FOUND: %\n" m.filename
		)
		
	)
	else
	(
		format "NOT FOUND: %\n" m.filename
	)
	
)