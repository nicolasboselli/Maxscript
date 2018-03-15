-- amélioration: utiliser le nom de l'objet comme nom du fichier fbx

rollout expSelToFBX"Export Selection to FBX"
(
	editText pathNameFBX "pathname:" readonly: true
	editText nameFBX "name:" across: 2
	button goFBX "Go FBX!" 
	
	on goFBX pressed do
	(
		for o in ($selection as array) do
		(
			FBXtempName = getSaveFileName filename:o.name types:"FBX(*.FBX)|*.FBX|"
			
			if FBXtempName != undefined then
			(
				select o
				exportFile FBXtempName selectedOnly: true
				pathNameFBX.text = getFilenamePath FBXtempName 
				nameFBX.text = ""
			)
		)

	)
)


createdialog expSelToFBX width: 600
