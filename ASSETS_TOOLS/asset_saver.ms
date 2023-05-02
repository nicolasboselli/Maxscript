/*
asset saver

	-- ajouter un historique
	-- option collapse name
	-- champs de recherche pour trier les noms
	-- sauver temporaire
*/
try(destroydialog assetSaverRLT )catch()
rollout assetSaverRLT "Asset Saver"
(
	local coreDir =  @"M:\Biblio\VISIOLAB\2-Assets3D\Pers-Films"
	global selFolder 
	local filesAr = #()
	local namesToDisplay
	
	dropdownList historyDPL "Historic"
	edittext folderET "Selected Folder:" 
	button selectFolderBT "..." across: 2
	button openExpBT "Open in Explorer"
	
	checkbox collapseNameCB "collapse name"
	
	listbox basenamesLB "basenames:"
	
	edittext newNameET "newName:"
	edittext fileNameET "Filename:"
	button saveBT "save"
	
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
)
createdialog assetSaverRLT width: 600


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