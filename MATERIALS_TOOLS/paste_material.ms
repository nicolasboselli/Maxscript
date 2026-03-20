/* thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
thecopypastefile = "\pastefile.max" --this is the filename to save as...
thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string

mergemaxfile (thecopypastedir + thecopypastefile) --#select --this merges ("pastes") and selects objects from file

lastMergedObject = getLastMergedNodes()


if lastMergedObject.count == 1 then 
(
-- 	mergedMat = lastMergedObject[1].material
	for s in selection do 
	(
		bakName = s.material.name
-- 		replaceinstances s.material lastMergedObject[1].material
		s.material = lastMergedObject[1].material
		s.material.name = bakname
	)
)

delete lastMergedObject */

try(destroydialog copyPasteMaterialRLT)catch()
rollout copyPasteMaterialRLT "Copy Paste Materials"
(
	button copyMatBT "copy selection material"
	button pasteMatBT "paste material to selection"
	button replaceInstanceMatBT "replace material instance"
	
	on copyMatBT pressed do
	(
		thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
		thecopypastefile = "\pastefile.max" --this is the filename to save as...
		thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string
		
		if $ != undefined do 
		saveNodes $ thecopypastestring --this saves ("copies") the objects as a file
	)
	
	on pasteMatBT pressed do
	(
		thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
		thecopypastefile = "\pastefile.max" --this is the filename to save as...
		thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string

		mergemaxfile (thecopypastedir + thecopypastefile) --#select --this merges ("pastes") and selects objects from file

		lastMergedObject = getLastMergedNodes()


		if lastMergedObject.count == 1 then 
		(
		-- 	mergedMat = lastMergedObject[1].material
			for s in selection do 
			(
				bakName = s.material.name
		-- 		replaceinstances s.material lastMergedObject[1].material
				s.material = lastMergedObject[1].material
				s.material.name = bakname
			)
		)
		delete lastMergedObject 
	)
	
	on replaceInstanceMatBT pressed do
	(
		thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
		thecopypastefile = "\pastefile.max" --this is the filename to save as...
		thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string

		mergemaxfile (thecopypastedir + thecopypastefile) --#select --this merges ("pastes") and selects objects from file

		lastMergedObject = getLastMergedNodes()


		if lastMergedObject.count == 1 then 
		(
		-- 	mergedMat = lastMergedObject[1].material
			for s in selection do 
			(
				bakName = s.material.name
				replaceinstances s.material lastMergedObject[1].material
-- 				s.material = lastMergedObject[1].material
				s.material.name = bakname
			)
		)
		delete lastMergedObject 
	)
)
createdialog copyPasteMaterialRLT