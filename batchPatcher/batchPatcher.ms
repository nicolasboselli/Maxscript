-- save current version as autoback
-- apply maxscript
-- save cleanversion
-- back to  autoback

-- maxFilePath + "\\" + maxfilename
-- OU
-- save version 
	-- get scenes folder
	sceneFolder = pathConfig.getCurrentProjectFolder() + "\\"  + "scenes"
-- 	num  = pathConfig.getProjectSubDirectoryCount() 
-- 	for i = 1 to num do format "%\n"(pathConfig.getProjectSubDirectory i)
	
-- créer un point bat qui lance une nouvelle instance de max (ouvre le fichier sauvegardé précedemment) et passe un script en parametres
	maxVers = "C:\\Program Files\\Autodesk\\3ds Max 2015\\3dsmax.exe"
	maxfile = "C:\\Users\\Visiolab\\Desktop\\boxes.max"
	script = "D:\\github\\DEV_maxscript\\00_wip\\sceneManagement\\testLoadScript.ms"

-- creation du bat file : methode ok, manque silent à l'ouverture
	batFile = sceneFolder + "\\" + "test3.bat" 
	
	str = createFile batFile
	close  str
	
	str = openFile batFile mode: "w+"
-- 	format  "\"%\" \"%\" -U MAXScript \"%\"  pause" maxVers maxfile script to:str
	format  "\"%\" \"%\" -U MAXScript \"%\" " maxVers maxfile script to:str
-- 	format  "\"%\" -U MAXScript \"%\" " maxVers script to:str
	close  str
		
-- lancer un .bat qui ouvre max avec le fichier à traiter et qui passse le script de traitement en parametres
	ShellLaunch batFile ""
	
-- 	ShellLaunch maxVers maxfile
	
-- DOSCOMMAND ne passe pas les scripts
	str2 = "start \"" + maxVers + "\" \"" + maxfile + "\" -U MAXScript \"" + script + "\""
	str2 = "\"" + maxVers + "\" \"" + maxfile + "\" -U MAXScript \"" + script + "\""
	doscommand str2 

-- sauver la version aprés le traitement

	/*
	doscommand " \"C:\Program Files\Autodesk\3ds Max 2015\3dsmax.exe\" -mxs \"b=box(); render\" "
	doscommand " C:\\Program Files\\Autodesk\\3ds Max 2015\\3dsmax.exe -U MAXScript D:\\githubDEV_maxscript\\00_wipsceneManagement\\testLoadScript.ms  pause"
	HiddenDOSCommand   " \"C:\\Program Files\\Autodesk\\3ds Max 2015\\3dsmax.exe\" -U MAXScript \"D:\\githubDEV_maxscript\\00_wipsceneManagement\\testLoadScript.ms\"  pause"
	wipFile = @"T:\ADN Patrimoine\Routedepibrac_0917\Perspectives\Scene3D\route_de_pibrac_11[Clean].max"
	if doesFileExist wipFile do shellLaunch (GetDir #maxroot + "3dsmax.exe") wipFile
	
	shellLaunch (GetDir #maxroot + "3dsmax.exe") ""  -u MAXScript "D:/github/DEV_maxscript/00_wip/sceneManagement/testLoadScript.ms"
	3dsmax -u MAXScript "D:/github/DEV_maxscript/00_wip/sceneManagement/testLoadScript.ms"
*/


