-- maj: 

-- générer un fichier fonction associé au panel et ptet fusionner les deux fichiers.
-- prévoir le double affichage des boutons "label"/"id"
-- supprimer les boutons au clic droit
-- mettre la selection de l'objet dans la scene au double clic
-- prévoir les fonctions de renommages
-- charger elternativement les sets de textes
-- vérifier qu'il n'y a plus d'objet blank avant de générer le fichier final

-- gérer les array d'objets
-- faire qu'aux clics sur les boutons on puisse faire plusieurs sélections


-- bug: à la première ouverture du control panel impossible de charger le button placer. à la deuxieme ça fonctionne le fichier semble ne pas être lisible pour la fonction qui lit ligne par ligne
-- lorsqu'on rafraichit la prévu en empuyant sur "rafraichie la prévue fn" cela rajoute un nouveau panneau à gauche. aprés un ajout mais pas aprés un delete

-- getThisScriptFilename() 

-- prob: comment stocker les arrays de séléction dans le helper? pas d'array d'array? piste: créer un plugin avec trois attributs(le nom, l'id, l'array de selection) et stockés les plugins dans un arraytab


global imgForSizeGlob = openBitmap  tempImgFile

-- import des fonction des boutons
-- execute (openfile "G:\Program Files\Autodesk\3ds Max 2012\Scripts\zz_rig\control_panel\button_fonction.ms")

-- functions

-- genere la premiere prevue, place le panneau image à l'ouverture
fn firstViewFN ctr img rlt  =
(
	
-- 		chargement du fichier
	buttonPlacerBuf = openFile ((getFilenamePath (getThisScriptFilename())) + "button_placer_UI.ms")
	strStr = FileToStringSteamFN buttonPlacerBuf

-- 		collecte du header
	header = ColStrToFN strStr "REP1"
	
-- 		creation du fichier button
	buttonSetBuf = openFile (createButFileFN ctr)
	buttonSet = FileToStringSteamFN buttonSetBuf

-- 		collecte du footer
	footer = ColStrFromFN strStr "REP1"

	-- addition des fichiers
	body = (header as string) + "\n" + (buttonSet as string) +"\n" + (footer as string)

	global TempCtr =  ctr
	global tempImgFile = img.filename
	global tempbuttonEditor = CtrStackUIRLT2
	global tempSupRlt = rlt
	
	vizRlt = execute body
	
	AddSubRollout rlt.cluster1 vizRlt
	
	TempCtr = undefined
	tempImgFile =undefined
	tempbuttonEditor = undefined
	tempSupRlt = undefined

	return vizRlt
)

-- fonction pour rafraichir la vue
-- param: le helper, le fichier bitmap
fn reFreshViewFN ctr img rlt vizRlt =
(

	removeSubRollout rlt.cluster1 vizRlt
	
	print "check 1"
-- 		chargement du fichier
	buttonPlacerBuf = openFile ((getFilenamePath (getThisScriptFilename())) + "button_placer_UI.ms")
	strStr = FileToStringSteamFN buttonPlacerBuf
	close buttonPlacerBuf
		
-- 		collecte du header
	header = ColStrToFN strStr "REP1"
	print "check 2"
		
-- 		creation du fichier button
	buttonSetBuf = openFile (createButFileFN ctr)
	buttonSet = FileToStringSteamFN buttonSetBuf
	print "check 3"
	
-- 		collecte du footer
	footer = ColStrFromFN strStr "REP1"
		print "check 4"
		
	body = (header as string) + "\n" + (buttonSet as string) +"\n" + (footer as string)
			print "check 5"
	print body

	global TempCtr =  ctr
	global tempImgFile = img.filename
	global tempbuttonEditor = CtrStackUIRLT2
	global tempSupRlt = rlt

	vizRlt = execute body
	
	AddSubRollout rlt.cluster1 vizRlt
	
	TempCtr = undefined
	tempImgFile =undefined
	tempbuttonEditor = undefined
	tempSupRlt = undefined

	return vizRlt
	
)

-- fonction pour retrouver le helper dans la scene
fn ViewFileStreamFN fs =
(
	test = newScript()
	debug = FileToStringSteamFN fs
	print (debug as string) to: test
)

fn FileToStringSteamFN fs =
(
	cond = true

	
	str = ""
	while (cond == true) do
	(
		
		try 
		(
			str = str + readLine fs + "\n"
		)
		
		catch 
		(
			cond = false
-- 			print "fuck!"
		)
		
	)
	strStream = str as stringstream
	return strStream
)

-- collecte un string jusqu'à un repère
fn ColStrToFN fs unStr =
(
	local cond = true
	
	seek fs 0
	
	local strStok = ""
	local str = ""
	
	while (cond == true) do
	(
		
		try 
		(
			str = readLine fs 
			strStok = strStok + "\n" + str
			
			if((findstring str unStr)!= undefined)then
			(
				cond = false
-- 				print"ici!"
				
			)
			else
			(
-- 				print"pas là"
			)
		)
		
		catch 
		(
			cond = false
-- 			print "fuck!"
		)
		
	)
	strStream = strStok as stringstream
	return strStream
)

-- collecte un string à partir d'un repère
fn ColStrFromFN fs unStr =
(
	local stop = false
	local colLine = false
	
	seek fs 0
	
	local strStok = ""
	local str = ""
	
	while (stop == false) do
	(
		
		try 
		(
			str = readLine fs 
			if (colLine) then strStok = strStok + "\n" + str
						
			if((findstring str unStr)!= undefined)then
			(
				colLine = true
-- 				print"ici!"
				
			)
			else
			(
-- 				print"pas là"
			)
		)
		
		catch 
		(
			stop = true
-- 			print "fuck!"
		)
		
	)
	strStream = strStok as stringstream
	return strStream
)

-- genere le fichier texte des buttons
fn createButFileFN ctr =
(
	local s = 20
	tempPath = (maxFilePath + "setButtonTemp.ms")
	
	oneFileStr = createFile tempPath
	close oneFileStr
	
	fileButBuF = openFile  tempPath mode: "w+"
	
	try
	(
		for i = 1 to ctr.butIDAr.count do 
		(

	-- 			format "yo!" to: fileButBuF
			format "button % \"%\" pos: % width: % height: % \n" ctr.butIDAr[i]  ctr.butLabAr[i] \
			([ctr.XcoordAr[i],ctr.YcoordAr[i]] - [(s/2),(s/2)]) s s to: fileButBuF
				
			if ctr.objAr[i] != $xxxxblankxxxx do
			(
			format "on  % pressed do \n(\n local s =  #( $% ) \n select s \n) \n \n" ctr.butIDAr[i]  ctr.objAr[i].name to: fileButBuF
			)
		)
		close fileButBuF
	)catch(close fileButBuF)
	
-- 	edit tempPath
	return tempPath
)

/* rollout complet plus image */
rollout buttonPlacerRLT "Button Placer"
(
	
	local visible = true
	local ctrStack = FindCtrStackFN ()
	local imgForSize = openBitmap tempImgFile
	
	subrollout cluster1 "buton placer" height: (imgForSize.height + 100) width: imgForSize.width  across: 2
	subrollout cluster2 "buton" height: (imgForSize.height + 100)
	
)

rollout CtrStackUIRLT2 "Button Editor" 
(
-- 	vars
	local supRlt = buttonPlacerRLT
	local vizRlt
	local s = 20
	local ctrVar = TempCtr
	local endFile = tempEndFile
	local imgFile = openBitmap tempImgFile
	
	
-- 	UI
-- 	pickbutton ctrStackPB "Pick Control"
	editText butCountET "ID count:" readonly: true
	
	listBox butNamArLB "ID buttons liste:" readonly: true height: 40 across: 3
	listBox butLabArLB "Lab buttons liste:"  height: 40
	listbox objArLB "obj liste:"  height:40
	
	group "Gestion Liste ID"
	(
		
		button delSelBT "Del selection" across: 2
		editText renameET "rename:"
	)
	
	group "Gestion liste Bouton"
	(
	)
		
	group "Gestion Liste d'objet" 
	(
		
		button addObjBT "add" across: 6
		button addBlankBT "<blank>"
		button delObjBT "del"
		button upBT "^"
		button dwBT "v"
		button selectBT "select" 
		editText objNameET "Rename:"
	)
	
-- 	button genMS "générer fichier bouton" 
	button genMS2 "générer fichier script" across: 3
	button genMS3 "rafraichir la prévu"
	button genMS4 "rafraichir la prévu fn"
	
-- 	EVENTS
	
	on CtrStackUIRLT2 open do
	(
		
-- 		ctrStackPB.text = ctrVar.name		
		
		butCountET.text = (ctrVar.butCount as string)
-- 		butNamArLB.items = for o in ctrVar.butLabAr collect o
		objArLB.items = for o in ctrVar.objAr collect o.name	
		
		butNamArLB.items = for  o in ctrVar.butIDAr collect o
		butLabArLB.items = for  o in ctrVar.butLabAr collect o
		
		-- import du sub rollout de l'image
		vizRlt = firstViewFN ctrVar imgFile supRlt 
		
-- 		visualSelCtrRLT.ctrStack = ctrVar
	)
	
	on addObjBT pressed do
	(
-- 		tempAr = $selection as array
		try
		(
			insertitem $ ctrVar.objAr objArLB.selection
			deleteitem ctrVar.objAr (objArLB.selection + 1)
-- 		append ctrVar.objAr $
		)catch(print "selection  non conforme")
		
		objArLB.items = for o in  ctrVar.objAr collect o.name
	)
	
	on delObjBT pressed do
	(
		if (objArLB.selection > ctrVar.butLabAr.count ) then
		(
		deleteitem ctrVar.objAr objArLB.selection
		objArLB.items = for o in  ctrVar.objAr collect o.name
		)
	)
	
	on upBT pressed do
	(
		try
		(
			bakObj = ctrVar.objAr[objArLB.selection - 1 ] 
			ctrVar.objAr[objArLB.selection - 1 ]= ctrVar.objAr[objArLB.selection]
			ctrVar.objAr[objArLB.selection] = bakObj
			
			objArLB.items = for o in  ctrVar.objAr collect o.name
			
			objArLB.selection = objArLB.selection - 1
			butLabArLB.selection = objArLB.selection
		)
		catch(print "raté")
	)
	
	on dwBT pressed do
	(
		try
		(
			bakObj = ctrVar.objAr[objArLB.selection + 1 ] 
			ctrVar.objAr[objArLB.selection + 1 ]= ctrVar.objAr[objArLB.selection]
			ctrVar.objAr[objArLB.selection] = bakObj
			
			objArLB.items = for o in  ctrVar.objAr collect o.name
			
			objArLB.selection = objArLB.selection + 1
			butLabArLB.selection = objArLB.selection
		)
		catch(print "raté")
	)
	
	on butLabArLB selected elt do
	(
		try
		(
			objArLB.selection = elt
			objNameET.text = objArLB.items[elt]
			select ctrVar.objAr[elt]
			
		)
		catch
		(
			objArLB.selection = 0
			objNameET.text = ""
		)
		
		renameET.text = butLabArLB.items[elt]
	)
	
	on objArLB selected elt do
	(
		try
		(
			butLabArLB.selection = elt
			renameET.text = butLabArLB.items[elt]
			select ctrVar.objAr[elt]
		)
		catch
		(
			butLabArLB.selection = 0
			renameET.text = ""
		)
		
		objNameET.text = objArLB.items[elt]
	)
	
-- 	suppression d'un bouton
	on delSelBT pressed do
	(
		deleteitem ctrVar.butIDAr butLabArLB.selection
		deleteitem ctrVar.butLabAr butLabArLB.selection
		deleteitem ctrVar.XcoordAr butLabArLB.selection
		deleteitem ctrVar.YcoordAr butLabArLB.selection
		
		deleteitem ctrVar.objAr butLabArLB.selection
		
		butNamArLB.items = for  o in ctrVar.butIDAr collect o
		butLabArLB.items = for  o in ctrVar.butLabAr collect o
		objArLB.items = for o in  ctrVar.objAr collect o.name
			
	)
	

	
	on addBlankBT pressed do
	(
		if (getnodebyname  "xxxxblankxxxx") == undefined then point name:  "xxxxblankxxxx" else blank = getnodebyname   "xxxxblankxxxx"
		
		-- 		tempAr = $selection as array
		try
		(
			insertitem blank ctrVar.objAr objArLB.selection
			deleteitem ctrVar.objAr (objArLB.selection + 1)
-- 		append ctrVar.objAr $
		)catch(print "selection  non conforme")
		
		objArLB.items = for o in  ctrVar.objAr collect o.name
	)
	
-- 	edite le fichier final
	on genMS2 pressed do
	(
-- 		createFile "J:\_svn\Chaperon rouge\00 - max\le_chaperon/test2.ms"
		panelTestBuf =  openFile endFile mode: "w+"
				
-- 		fichier d'entete
		format " rollout panel2 \"blabala\" \n
		(	local chapBmp2 = openBitmap  \"% \"
			bitmap test2   bitmap: chapBmp2  pos: [0,0]
		"  imgFile.filename	to: panelTestBuf
		
-- 		set de bouton
-- 		createButFileFN ctrVar
		
-- 		flush  fileButBuF
		fileButBuF = openFile (createButFileFN ctrVar)
		strBuf = FileToStringSteamFN fileButBuF
		format (strBuf as string ) to: panelTestBuf
		close fileButBuF	
		
-- 		fichier footer
		format ")
		createDialog panel2 height: % width: %" imgFile.height imgFile.width to: panelTestBuf
		
		close panelTestBuf		
		fileBufTest =  openFile  endFile
		execute fileBufTest
		
		edit endFile
	)
	
-- 		 met à jour le fichier repère
	
	on genMS4 pressed do
	(
		vizRlt = reFreshViewFN ctrVar imgFile supRlt vizRlt
	)
	
)


createdialog buttonPlacerRLT height: (imgForSizeGlob.height+150) width: (imgForSizeGlob.width + 800)

AddSubRollout buttonPlacerRLT.cluster2 CtrStackUIRLT2

-- AddSubRollout buttonPlacerRLT.cluster1 visualSelCtrRLT
-- removeSubRollout buttonPlacerRLT.cluster1 visualSelCtrRLT