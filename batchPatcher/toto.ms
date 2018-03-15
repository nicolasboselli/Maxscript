-- save current version as autoback
-- apply maxscript
-- save cleanversion
-- back to  autoback

-- OU
-- save version 
	-- get scenes folder
	sceneFolder = pathConfig.getCurrentProjectFolder() + "\\"  + "scenes"
-- 	num  = pathConfig.getProjectSubDirectoryCount() 
-- 	for i = 1 to num do format "%\n"(pathConfig.getProjectSubDirectory i)
	
-- créer un point bat qui lance une nouvelle instance de max (ouvre le fichier sauvegardé précedemment) et passe un script en parametres
	maxVers = "C:\\Program Files\\Autodesk\\3ds Max 2015\\3dsmax.exe"
	script = "D:\\github\\DEV_maxscript\\00_wip\\sceneManagement\\testLoadScript.ms"
	batFile = sceneFolder + "\\" + "test2.bat" 
	
	str = createFile batFile
	close  str
	
	str = openFile batFile mode: "w+"
	format  " \"%\" -U MAXScript \"%\"  pause" maxVers script to:str
	close  str
	
-- lancer un .bat qui ouvre max avec le fichier à traiter et qui passse le script de traitement en parametres
	ShellLaunch batFile ""
	--"D:/github/DEV_maxscript/00_wip/sceneManagement/testMax.bat" ""
	
	str2 = "start " + "\"" + maxvers + "\"" + " -mxs " + "\""+ script + "\""
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


-- select sel

