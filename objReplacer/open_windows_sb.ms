try(destroydialog windowsSettingsRLT)catch()
rollout windowsSettingsRLT "Windows Settings"
(
	
	group "settings:"
	(
		button tagAsWindowsBT "tag as Windows" across: 3
		button clockwiseBT "tag right" 
		button antiClockwiseBT "tag left"
	)
	
	group "cleaning user properties:"
	(
		button cleanWindowsTemplateBT "delete windows properties"
		button clearTagBT "delete opening properties"
	)
		
	fn deleteUserProp node prop = 
	(
		if getUserProp node prop != undefined do
		(
			 buff = (getUserPropBuffer node) as stringStream 
			 newb = stringStream ""
			 while not eof buff do
			 (
				  str = readLine buff
				  if str != "" and not matchpattern str pattern:("*" + prop + "*=*") do format "%\n" str to:newb
			 )
			 setUserPropBuffer node (replace_LF_with_CRLF (newb as string))
		)
	)
	
	on clockwiseBT pressed do
	(
		sel = selection as array
		for s in sel do setUserProp s "pivotFenetre" "true"
	)
	
	on antiClockwiseBT pressed do
	(
		sel = selection as array
		for s in sel do setUserProp s "pivotFenetre" "false"
	)
	
	on tagAsWindowsBT pressed do
	(
		sel = selection as array
		for s in sel do
		(
			if iskindof s dummy and isgrouphead s then
			(
				setUserProp s "windowsTemplate" "true"
			)
		)
	)
	
	on clearTagBT pressed do
	(
		sel = selection as array
		for s in sel do deleteUserProp s "pivotFenetre"
	)
	
	on cleanWindowsTemplateBT pressed do
	(
		sel = selection as array
		for s in sel do deleteUserProp s "windowsTemplate"
	)
	
)
-- createdialog windowsSettingsRLT width: 300

try(destroydialog openFenetresRLT)catch()
rollout openFenetresRLT "Windows Tools"
(
	local windowsSet
	
	group "scenes infos:"
	(
		edittext windowsCountET "windows ready:" readonly: true across: 2
		button selectAllWIndowsBT "select All"
	)
	
	group "actions on selection:"
	(
		button openWindowsBT "open windows" across: 3 
		button openRightBT "open right"
		button openLeftBT "open left"

		button closewindowsBT "close windows" across: 2
		button flipWindowsBT "flip windows" enabled: false
		
		spinner randomOpenSP "percent:" range: [0,100,100] enabled: true across: 2
		button randomOpenWindowsBT "random open" enabled: true
	)
		
	fn findWindows oneArray = 
	(
		windowsSet = #()
		for h in oneArray where iskindof h dummy and isgrouphead h do 
		(
			local res
			try(res = (getUserProp h "windowsTemplate")as booleanClass)catch(res = false)
			if res then append windowsSet h
		)
		windowsSet
	)
	
	on openFenetresRLT open do
	(
-- 		findWindows (selection as array)
		findWindows (helpers as array)
		format "windows count: %\n" windowsSet.count
		windowsCountET.text = windowsSet.count as string
	)
	
	on selectAllWIndowsBT pressed do
	(
		findWindows helpers 
		select windowsSet
	)
	
	on openWindowsBT pressed do
	(
		sel = selection as array
-- ouverture de la fenetre
		for s in sel do
		(
			local res
			try(res = (getUserProp s "pivotFenetre")as booleanClass)catch(res = undefined)
			if res != undefined then
			(
				-- 
				if res then
				(
					rotate s (eulerangles 0 0 45)
				)
				else if not res then
				(
					rotate s (eulerangles 0 0 -45)
				)
			)
		)
	)
	
	on openRightBT pressed do
	(
		sel = selection as array
		
		for s in sel do
		(
			local res
			try(res = (getUserProp s "pivotFenetre")as booleanClass)catch(res = undefined)
			if res != undefined then
			(
				if res then
				(
					rotate s (eulerangles 0 0 45)
				)
				else if not res then
				(
-- 					rotate s (eulerangles 0 0 -45)
				)
			)
		)
	)
	
	on openLeftBT pressed do
	(
		sel = selection as array
		
		for s in sel do
		(
			local res
			try(res = (getUserProp s "pivotFenetre")as booleanClass)catch(res = undefined)
			if res != undefined then
			(
				if res then
				(
-- 					rotate s (eulerangles 0 0 45)
				)
				else if not res then
				(
					rotate s (eulerangles 0 0 -45)
				)
			)
		)
	)
	
	on closewindowsBT pressed do
	(
		sel = selection as array
		for s in sel do
		(
			local res
			try(res = (getUserProp s "pivotFenetre")as booleanClass)catch(res = undefined)
			if iskindof res booleanClass then
			(
				bakpos = s.position
				in coordsys parent s.rotation = (quat 0 0 0 1)
				s.position = bakpos
			)
		)
	)
	

)
createdialog openFenetresRLT width: 300

/*
getUserProp 
setUserProp $ "pivotFenetre" "true"
setUserProp $ "pivotFenetre" "false"

sel = selection as array
-- ouverture de la fenetre
for s in sel do
(
	local res
	try(res = (getUserProp s "pivotFenetre")as booleanClass)catch(res = undefined)
	if res != undefined then
	(
		if res then
		(
			rotate s (eulerangles 0 0 90)
		)
		else if not res then
		(
			rotate s (eulerangles 0 0 -90)
		)
	)
)

-- femeture de la fenetre
for s in sel do
(
	local res
	try(res = (getUserProp s "pivotFenetre")as booleanClass)catch(res = false)
	if res then
	(
		bakpos = s.position
		in coordsys parent s.rotation = (quat 0 0 0 1)
		s.position = bakpos
	)
)
*/