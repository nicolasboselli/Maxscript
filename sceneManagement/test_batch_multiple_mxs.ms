/*    thePath = getSavePath()--get a path dialog to specify the path
   if thePath != undefined do--if the user did not cancel
   (
     theFiles = getFiles (thePath+"\\*.max") --collect all max files in the dir.
     for f in theFiles do-- go through all of them
     (
       loadMaxFile f--load the next file

   -----------------------------------------------------------
   -- MAKE SOME SCRIPTED CHANGES TO THE SCENE HERE...
   -----------------------------------------------------------

       saveMaxFile f --save the file back to disk
     )--end f loop
     resetMaxFile #noPrompt --at the end, you can reset
   )--end if */
   



fn resetposition =
(
	select helpers
	sel = selection as array
	global val
	for s in sel where isGroupHead s do
	(
		
		val = s
		
	)
	val.position = point3 0 0 0 
	val.rotation = EulerAngles 0 0 -90
)


fn renameWindowsMat =
(
	for m in scenematerials where m.override_effect_id == on do
	(
		if  m.effect_id == 2 then
		(
			format "vitrage m:% id:%\n" m m.effect_id
			m.name = "vitrage"

		)
		else if  m.effect_id == 4 then
		(
			format "huisserie m:% id:%\n" m m.effect_id
			m.name = "Huisserie"
			
		)
		else()
	)
)



theFiles = getFiles @"M:\Biblio\VISIOLAB\2-Assets3D\Elements_batiments\Ouvrants\Fenetres\F_*.max"

for i = 1 to theFiles.count do
(
	f = theFiles[i]
	loadMaxFile f
	format "i: %\% f:%\n" i theFiles.count f
	
	cleanFile()
	updateSceneMaterials()
	renameWindowsMat()
   
	saveMaxFile f
)
resetMaxFile #noPrompt --at the end, you can reset
