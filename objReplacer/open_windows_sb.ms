try(destroydialog openFenetresRLT)catch()
rollout openFenetresRLT "open Fenêtres"
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
	
	group "actions:"
	(
		
		button openWindowsBT "open windows" across: 3
		button openRightBT "open right"
		button openLeftBT "open left"
		
		
		button closewindowsBT "close windows" across: 2
		button flipWindowsBT "flip windows" enabled: false
	)
	
	group "random:"
	(
		button selectAllWIndowsBT "select All"
		spinner randomOpenSP "percent opening" range: [0,100,100] enabled: false
		button randomOpenWindowsBT "random open windows" enabled: false
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
	
	on selectAllWIndowsBT pressed do
	(
		local sel = #()
-- 		clearselection()
		for h in helpers where iskindof h dummy and isgrouphead h do 
		(
			local res
			try(res = (getUserProp h "windowsTemplate")as booleanClass)catch(res = false)
			if res then append sel h
		)
		select sel
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