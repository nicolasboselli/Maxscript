global cellSetPath = getroot() +"cellsCreator/cellSettings/*"

struct spMurSet (name, wirecolor, hauteur, epaisseur)
struct spPerceSet (name, wirecolor, hauteur, allege, debordAv, debordAr, filename)

try(destroydialog CelSetRLT)catch()
rollout CelSetRLT "Cel setting" 
(
	local cellSetAr
	
	group "configuration:"
	(
		dropdownlist  configDDL "select:"
		button saveBT "save" across: 3 enabled: true
		button saveAsBT "saveAs" enabled: false
		button loadBT "load" enabled: true
	)
	
	fn loadSettings f cat =
	(
		layerStructAr = #()
		mursSettingsAr = getINISetting f cat
		for o in  mursSettingsAr do
		(
			append layerStructAr (execute(getINISetting f cat o))
		)
		layerStructAr
	)
	
	-- 	fn saveSettings f =
-- 	(
-- 		format "start save\n"
-- 		delIniSetting f "mursSettings2"
-- 		
-- 		for l in layerStructAr do
-- 		(
-- 			format "% = %\n" l.name (l as string)
-- 			setINISetting f "mursSettings2" l.name  (l as string)
-- 		)
-- 		refreshUI()
-- 	)
	
	-- fonction ui dependant
	fn refreshUI =
	(
		configDDL.items = for c in cellSetAr collect (getFilenameFile c)
		
-- 		mursMLB.items = for i = layerStructAr.count to 1 by -1 collect layerStructAr[i].name
-- 		mursMLB.items = for p in layerStructAr collect p.name

	)
	
	on CelSetRLT open do
	(
		cellSetAr = getfiles cellSetPath
-- 		format "cellSetAr: %\n" cellSetAr
-- 		if cellSetAr.count == 0 then()
-- 		else loadSettings cellSetAr[1]
-- 		format "cellSetAr: %\n" layerStructAr
		refreshUI()
	)
	
	on saveBT pressed do
	(
		if prepaPercementRLT.isDisplayed  then
		(
			prepaPercementRLT.layerStructAr
		)
		else undefined
		
		if prepaMursRLT.isDisplayed then
		(
			prepaMursRLT.layerStructAr
		)
		else undefined
	)
	

	
)
createdialog CelSetRLT