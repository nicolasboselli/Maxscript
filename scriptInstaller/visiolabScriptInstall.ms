/*
maj:

*/

fn returnParentFolder folderPath =
(
	local splitFolder = filterString folderPath "\\"
	
	local sum = ""
	for i = 1 to (splitFolder.count - 1) do
	(
-- 			print splitFolder[i]
		sum = sum + splitFolder[i] + "\\"
	)
	sum
)

-- crée l'armadaScript.ini dans le dossier de 3dsmax et écrit le root des scripts
fn initArmadasScripts =
(
	-- determination du root des scripts
	local armadasScriptsRoot = returnParentFolder (getFilenamePath  (getThisScriptFilename()))
	armadasScriptsRoot = substituteString armadasScriptsRoot "\\" "/"
	format "armadasScriptsRoot: %\n" armadasScriptsRoot
		
	-- determination du dossier max data
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
	-- 
	setINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot" armadasScriptsRoot
)
initArmadasScripts()

-- trouver l'adresse du dossier de script dans l'armadascript.ini
fn getRoot =
(
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
)

-- ajout de la lecture du dossier startup au démarrage de max (avant macroscript):
fn initArmadasStartupDir =
(
	local startupDir = (getRoot() + "scriptInstaller/startup_Visiolab")

	-- ajout du dossier startup 
	local ini_file = if (maxversion())[1] < 12000 then "plugin.ini" else "plugin.userSettings.ini"
	setINISetting (getdir #maxdata + ini_file) #directories "Visolab Scripts Startup" startupDir
)
initArmadasStartupDir()
	

-- load du fichier filein
filein ((getRoot ()) + "scriptInstaller/startup_visiolab/visiolabFileIn.ms")









