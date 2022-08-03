/*
maj UI
x-faire l'ouverture des fenetres  avec des tirettes
- geler la tirette de la fenetre inactive: rendre les tirettes interactives à la selection, necessite un event
- faire fonctionner sur les fenetres coulissantes

debug;
	- dès qu'on tourne la fenêtre, les battant s'ouvre dans n'importe quel sens, revoir les formules
	- fermer les battant avant de replacer le pivot de la fenetre
	- finir le reset fenetres parce que les tirettes marchent à l'envers sur une fenetre flippé


newMatrix = ((eulerangles 0 0 -10) as Matrix3) * $.transform
newMatrix.translation = $.transform.translation
$.transform = newMatrix


*/


try(destroydialog openFenetresRLT)catch()
rollout openFenetresRLT "Windows Opener"
(
	local windowsSet
	local winListR
	local winListL
	local bakVal = 0
	
	group "scenes infos:"
	(
		edittext windowsCountET "windows ready:" readonly: true across: 2
		button selectAllWIndowsBT "select All"
	)
	
	group "actions on selection:"
	(
		slider openAllSL "open selection"  range:[0,360,0] type: #integer ticks:18
		
		slider openLeftSL "open left" across: 2 range:[0,360,0] type: #integer ticks:8
		slider openRightSL "open right" range:[0,360,0] type: #integer ticks:8
		
		button closewindowsBT "close windows" -- across: 2

	)
	
	group "pivots"
	(
		button placePivot1BT "place ouvrants pivots"
		button placePivot2BT "place windows pivots"
		
	)
	
	group "symmetry"
	(
		button symWindowsBT "flip windows"
		button resetWindowsBT "reset windows scale" enabled: false -- voir pivotPlacer_sb.ms
	)
	
-- 	function UI dependant
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

	
	on openAllSL buttondown do
	(
		sel = selection as array
		winListR = #()
		winListL = #()
		for s in sel do
		(
			local res
			try(res = (getUserProp s "pivotFenetre")as booleanClass)catch(res = undefined)
			if res != undefined then
			(
				if res then append winListR s
				else if not res then append winListL s
			)
			
		)
		
		for w in winListR do
		(
			initMatrix = w.parent.transform
			initMatrix.translation = w.transform.translation
			w.transform = (rotateZMatrix openRightSL.value) * initMatrix
		)
		
		for w in winListL do
		(
			initMatrix = w.parent.transform
			initMatrix.translation = w.transform.translation
			w.transform = (rotateZMatrix openLeftSL.value) * initMatrix
		)
		
		bakval = openAllSL.value
	)
	
	on openAllSL changed val do
	(	
		for w in winListR do
		(
			w.transform = (rotateZMatrix (val - bakval)) * w.transform
		)
				
		for w in winListL do
		(
			w.transform = (rotateZMatrix ((val - bakval)*-1) ) * w.transform
		)
		bakval = val
	)

	on openRightSL buttondown do
	(
		sel = selection as array
		winListR = #()
		
		for s in sel do
		(
			local res
			try(res = (getUserProp s "pivotFenetre")as booleanClass)catch(res = undefined)
			if res != undefined and res then append winListR s
		)
		
		for w in winListR do
		(
			initMatrix = w.parent.transform
			initMatrix.translation = w.transform.translation
			w.transform = (rotateZMatrix openRightSL.value) * initMatrix
		)
		
		bakval = openRightSL.value
	)
	
	on openRightSL changed  val do
	(		
		for w in winListR do
		(
			w.transform = (rotateZMatrix (val - bakval)) * w.transform
		)
		bakval = val
	)

	
	on openLeftSL buttondown do
	(
		sel = selection as array
		winListL = #()
		
		for s in sel do
		(
			local res
			try(res = (getUserProp s "pivotFenetre")as booleanClass)catch(res = undefined)
			if res != undefined and not res then append winListL s
		)
		
		for w in winListL do
		(
			initMatrix = w.parent.transform
			initMatrix.translation = w.transform.translation
			w.transform = (rotateZMatrix openLeftSL.value) * initMatrix
		)
		
		bakval = openLeftSL.value
	)
	
	
	on openLeftSL changed  val do
	(
		for w in winListL do
		(
			w.transform = (rotateZMatrix ((val - bakval)*-1) ) * w.transform
		)
		bakval = val
		
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
				newMatrix3 = s.parent.transform
				newMatrix3.translation = s.transform.translation
				s.transform = newMatrix3
			)
		)
	)
	
	
	on placePivot1BT pressed do
	(
		-- recalage des pivots des ouvrants
		sel = selection as array
		for s in sel do
		(
			try(res = (getUserProp s "pivotFenetre")as booleanClass)catch(res = undefined)
			if iskindof res booleanClass then
			(
				if res then
				(
					bbVal = nodeGetBoundingBox s s.transform
					s.pivot = ( transMatrix(point3 0 (bbVal[2].y) 0) * s.transform).translation
				)
				else if not res then
				(
					bbVal = nodeGetBoundingBox s s.transform
					s.pivot = ( transMatrix(point3 0 (bbVal[1].y) 0) * s.transform).translation
				)
			)
		)
	)
	
	on placePivot2BT pressed do
	(
		-- recalage du  pivot de la fenetre
		sel = selection as array
		for s in sel where iskindof s dummy and isgrouphead s do
		(
			try(res = (getUserProp s "windowsTemplate")as booleanClass)catch(res = undefined)
			if iskindof res booleanClass then
			(
				bbVal = nodeGetBoundingBox s s.transform
				s.pivot = ( transMatrix(point3 (bbVal[2].x) (bbVal[2].y) (bbVal[1].z)) * s.transform).translation
			)
			else(format "This is not a windows\n")
		)
	)
	
	on symWindowsBT pressed do
	(
		-- symetrie de la fenetre en Y
		sel = selection as array
		for s in sel where iskindof s dummy and isgrouphead s do
		(
			try(res = (getUserProp s "windowsTemplate")as booleanClass)catch(res = undefined)
			if iskindof res booleanClass then
			(
				s.pivot = s.center
				s.transform = scale s.transform (point3 1 -1 1) 
			)
			else(format "This is not a windows\n")
		)
		
		placePivot2BT.pressed()
	)
)
createdialog openFenetresRLT width: 300


