-- collecter tous les repertoire et sous repertoire d'une liste de repertoires enregistrée

try destroydialog collectFoldersRLT catch()
rollout collectFoldersRLT "collect folders"
(
	local params = #("pos", "folderList")
	
	local folderList = #()
	
	multilistbox folderMLB "folders:"
	button addFoldBT "add" across: 2
	button delFoldBT "del"
	
	button collectFoldersBT "collect folders"
	
	fn refreshUI =
	(
		folderMLB.items = for f in folderList collect  f
	)
	
	on collectFoldersRLT open do
	(
		loadRolloutParams collectFoldersRLT params
		refreshUI()
	)
	
	on collectFoldersRLT close do
	(
		writeRolloutParams collectFoldersRLT params
	)
	
	on addFoldBT pressed do
	(
		local newPath =getSavePath caption: "choose folder" initialDir: "M:/"
		if newPath != undefined and doesfileexist newPath then 
		(
			appendifunique folderList newPath
		)
		refreshUI()
	)
	
	on collectFoldersBT pressed do
	(
	)
)
createdialog collectFoldersRLT