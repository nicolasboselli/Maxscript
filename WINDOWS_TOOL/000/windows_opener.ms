/*
maj UI
-faire l'ouverture des fenetres  avec des tirettes
- geler la tirette de la fenetre inactive
*/


try(destroydialog openFenetresRLT)catch()
rollout openFenetresRLT "Windows Opener"
(
	local windowsSet
	
	group "scenes infos:"
	(
		edittext windowsCountET "windows ready:" readonly: true across: 2
		button selectAllWIndowsBT "select All"
	)
	
	group "actions on selection:"
	(
		button openWindowsBT "open windows" 
		
		button openLeftBT "open left" across: 2
		button openRightBT "open right" 

		button closewindowsBT "close windows" -- across: 2
-- 		button flipWindowsBT "flip windows" enabled: false
		
-- 		spinner randomOpenSP "percent:" range: [0,100,100] enabled: true across: 2
-- 		button randomOpenWindowsBT "random open" enabled: true
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


