/*
Maj:
-- demarrage du script depuis N:\Ressources_Nico\github\00_wip\Maxscript\scriptInstaller\startup\armadesFileIn.ms
-- mettre les callbacks au demarrage de max
-- prevoir une façon d'avtiver ou de desactiver le script au demarrage

*/

-- dans une fenetre on stocke tous les derniers dossiers des scenes ouvertes
try(destroydialog folderOpenRLT)catch()
rollout folderOpenRLT "folders opened"
(
	local folderAr = #()
	local params = #("folderAr", "startCB")	
	
	listbox folderLB "Folders list:" height: 20
	
	checkbox startCB "start with 3ds max"
	
	button upBT "refresh UI" across: 2
	button openBT "open folder"
	
	fn refreshUI =
	(
		tmpAr = #()
		for f in folderAr do
		(
			appendifunique folderLB.items  f
		)
		folderLB.items = tmpAr
	)
	
	fn folderTrackerTest =
	(
		loadRolloutParams folderOpenRLT Params
		append folderAr (substituteString maxFilePath "\\" "/")
		format "opened folder: %\n" maxFilePath 
		
		-- ecrire les chemin dans un fichier ini
		writeRolloutParams folderOpenRLT Params

		-- faire avancer les dossier dans une liste
		-- eliminer les dossier au dela d'un certain nombre
		-- faire remonter les dossier déja présent dans la liste
		-- collecter les dossiers ouvert dans l'explorer windows?
		refreshUI()

	)
	
	on folderOpenRLT open do
	(
		loadRolloutParams folderOpenRLT Params
		
		callbacks.removeScripts id: #folderTracker
		callbacks.removeScripts id: #folderTrackerPS
				
-- 		if folderAr == undefined then folderAr = #()
		-- enregistrer le dossier à chaque ouverture de fichier max
		callbacks.addScript #filePostOpen "folderOpenRLT.folderTrackerTest()" id: #folderTracker
		callbacks.addScript #filePostSave "folderOpenRLT.folderTrackerTest()" id: #folderTrackerPS
		
		refreshUI()
	)
	
	on folderOpenRLT close do
	(
		writeRolloutParams folderOpenRLT Params
	)
		
	on upBT pressed do
	(
		folderLB.items = folderAr
	)
	
	on openBT pressed do
	(
		-- ouvrir le dossier dans l'explorer windows
		doscommand ("explorer " + (substituteString folderLB.selected "/" "\\"))
	)
)
createdialog folderOpenRLT width: 800



