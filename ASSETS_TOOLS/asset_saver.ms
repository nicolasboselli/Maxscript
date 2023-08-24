/*
asset saver

	-- ajouter un historique, ajouter à l'historique les dossier où l'on fait un enregistrement
	-- option collapse name

	x-- champs de recherche pour trier les noms
	x-- sauver temporaire
	-- fonction pour ouvrir le dossier de texture de l'asset

	x- champs de recherche pour trier les noms
	x- sauver temporaire
	
	-- warning dialog pour écraser un fichier à l'enregistrement
	-- utiliser la lisstbox comme un explorateur
	-- prévoir un fonction d'ouverture d'asset(?)

*/
try(destroydialog assetSaverRLT )catch()
rollout assetSaverRLT "Asset Saver"
(
	local coreDir =  @"M:\Biblio\VISIOLAB\2-Assets3D\Pers-Films"
	local coreTextDir =  @"M:\Biblio\VISIOLAB\1-Textures\Assets3d\Pers-Films"
	
	global selFolder 
	local filesAr = #()
	local namesToDisplay
	
	dropdownList historyDPL "Historic"
	edittext folderET "Selected Folder:" 
	button selectFolderBT "..." across: 2
	button openExpBT "Open in Explorer"
	
	checkbox collapseNameCB "collapse name"

	edittext searchET "search:"

	
	listbox basenamesLB "basenames:"
	
	edittext newNameET "newName:"
	edittext fileNameET "Filename:"
	button saveBT "save" across: 2
	button saveSelBT "save selected"
	edittext textureFolderET "Texture Folder:"

	
	fn refreshUI = 
	(
		if selFolder != undefined then folderET.text = selFolder
		
		namesToDisplay = for f in filesAr collect getFilenameFile f
			
		if collapseNameCB.checked then format "collapseNameCB: %\n" true
		else format "collapseNameCB: %\n" false
		sort namesToDisplay
		basenamesLB.items = namesToDisplay
	)

	on assetSaverRLT open do
	(
		if selFolder == undefined then selFolder = coreDir
		if not isDirectoryWriteable selFolder then selFolder = coreDir
			
		filesAr = getfiles (selFolder + "\\*.max")
		sort filesAr
				
		refreshUI()
	)
	

	on folderET entered val do
	(
		format "val: %\n" val
 		if isDirectoryWriteable val then 
		(
			selFolder = val
 			filesAr = getfiles (selFolder + "\\*.max")
 		)
		refreshUI() 
	)

	on collapseNameCB changed val do 
	(
		format "state: %\n" val
		if val then
		(
			
		)
	)
	
	on selectFolderBT pressed do
	(
-- 		filename = getOpenFileName \
-- 		caption:"Save Asset" \
-- 		filename: @"M:\Biblio\VISIOLAB\2-Assets3D\Pers-Films" \
-- 		types:"Object Preset(*.rtp)|*.rtp" \
-- 		historyCategory:"RTTObjectPresets"
		
		if selFolder == undefined then selFolder = coreDir
		if not isDirectoryWriteable selFolder then selFolder = coreDir
		
		local oneFol = getSavePath caption:"Save Asset Folder" initialDir: selFolder
		
		if oneFol == undefined then (format "oneFol == undefined")
		else
		(
			selFolder = oneFol
			if isDirectoryWriteable selFolder then
			(
				filesAr = getfiles (selFolder + "\\*.max")
			)
			
			refreshUI()
		)

	)
	
	on openExpBT pressed do
	(
		doscommand ("explorer " +  selFolder)
	)
	
	on collapseNameCB changed val do 
	(
		format "state: %\n" val
		if val then
		(
			
		)
	)
	
	
	on searchET changed val do
	(
		namesToDisplay = for f in filesAr collect getFilenameFile f
-- 		format "val: %\n" val
		namesToDisplay = for oneName in namesToDisplay where matchpattern oneName pattern: ("*"+ val +"*") collect oneName
		sort namesToDisplay
		basenamesLB.items = namesToDisplay
	)
	
	on basenamesLB selected nameID do
	(
		newNameET.text = namesToDisplay[nameID]
		fileNameET.text = selFolder + "\\" + namesToDisplay[nameID] + ".max"
-- 		textureFolderET.text = (substitutestring selFolder coreDir coreTextDir) + "\\" + newName
	)
	
	on newNameET changed newName do
	(
		fileNameET.text = selFolder + "\\" + newName + ".max"
-- 		textureFolderET.text = (substitutestring selFolder coreDir coreTextDir) + "\\" + newName
	)
	
	on saveBT pressed do
	(
		if not doesFileExist fileNameET.text then saveMaxFile fileNameET.text else (format "le fichier % existe déjà.\n" fileNameET.text )
		filesAr = getfiles (selFolder + "\\*.max")
		refreshUI()
	)
	
	on saveSelBT pressed do
	(
		sel = selection as array
		if not sel.count == 0 then
		(
			if not doesFileExist fileNameET.text then saveNodes selection fileNameET.text else (format "le fichier % existe déjà.\n" fileNameET.text )
			filesAr = getfiles (selFolder + "\\*.max")
			refreshUI()
		)
		else(format "Faites une selection avant de sauvegarder.\n")
	)
	
)
createdialog assetSaverRLT width: 800

		
		




-- getfiles @"M:\Biblio\VISIOLAB\2-Assets3D\Pers-Films\Objets\Amenagement\Interieur\Sejour\*"

/*


-- Dictionnary
my_dict = Dictionary #(#one, 1) #(#two, 2)
my_dict[]

filesNamesAr = getfiles @"M:\Biblio\VISIOLAB\2-Assets3D\Pers-Films\Objets\Amenagement\Interieur\Sejour\*.max"

for f in filesNamesAr do
(
	
)
filename = "HAB_INT_SEJOUR_LUMINAIRE_LAMPE_83.max" -- Example filename
-- filename = "HAB_INT_SEJOUR_LUMINAIRE_LAMPE_84_SIMONE_AND_MARCEL_PENDOLO.max" -- Example filename
pattern = "^(.+?)_([0-9]+)(.*?)\.(.+)$"

-- Create a Regex object with the pattern
regex = dotNetObject "System.Text.RegularExpressions.Regex" pattern

-- Use the Regex object to match the filename
match = regex.Match(filename)

if match.Success do (
    oneFilename = match.Groups.Item[1].Value
    oneNumber = (match.Groups.Item[2].Value) as integer
    oneDescription = match.Groups.Item[3].Value
    oneExtension = match.Groups.Item[4].Value
    
 -- créer une entrée dans le dictionnaire si l'entrée existe déja, mettre à jour le dictionnaire
)

format "Name: %\n" file_name
format "Number: %\n" file_number
format "Description: %\n" file_description
format "Extension: %\n" file_extension
*/