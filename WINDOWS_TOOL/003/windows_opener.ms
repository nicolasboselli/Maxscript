/*
maj UI
x-faire l'ouverture des fenetres  avec des tirettes
- geler la tirette de la fenetre inactive: rendre les tirettes interactives à la selection, necessite un event
- faire fonctionner sur les fenetres coulissantes

debug;
	x- dès qu'on tourne la fenêtre, les battant s'ouvre dans n'importe quel sens, revoir les formules
	- fermer les battant avant de replacer le pivot de la fenetre
	- finir le reset fenetres parce que les tirettes marchent à l'envers sur une fenetre flippé

x - le place windows pivot doit placer le pivot en bas à gche de la fenetres, même quand la fenetre est flippée en y 

x au reset de scale inverser le boolean des pivotfenetres


newMatrix = ((eulerangles 0 0 -10) as Matrix3) * $.transform
newMatrix.translation = $.transform.translation
$.transform = newMatrix


*/


try(destroydialog openFenetresRLT)catch()
rollout openFenetresRLT "Windows Opener"
(
	local windowsSet
	local windowsFlipSet
	local winListR, winSlideListR
	local winListL, winSlideListL
	local bakVal = 0
	
	group "scenes infos:"
	(
		edittext windowsCountET "windows ready:" readonly: true across: 2
		button selectAllWIndowsBT "select All"
		edittext flippedWindowsCountET "flipped windows:" readonly: true across: 2
		button selectFlipWIndowsBT "select"
	)
	
	group "actions on selection:"
	(
		slider openAllSL "open selection"  range:[0,360,0] type: #integer ticks:18
		
		slider openLeftSL "open left" across: 2 range:[0,360,0] type: #integer ticks:8
		slider openRightSL "open right" range:[0,360,0] type: #integer ticks:8
		
		button closewindowsBT "close windows" -- across: 2
		button symWindowsBT "flip windows"

	)
	
	group "fixing:"
	(
		button placePivot1BT "place ouvrants pivots" across: 2
		button placePivot2BT "place windows pivots"
		button resetWindowsBT "reset windows scale" enabled: true -- voir pivotPlacer_sb.ms
		
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
	
	fn resetUI = 
	(
		findWindows (helpers as array)
-- 		format "windows count: %\n" windowsSet.count
		windowsCountET.text = windowsSet.count as string
		
		windowsFlipSet = for w in windowsSet where w.scale.y < 0 collect w
		flippedWindowsCountET.text = windowsFlipSet.count as string
	)

	
	on openFenetresRLT open do
	(		
		resetUI ()
	)
	
	on selectAllWIndowsBT pressed do
	(
		findWindows helpers 
		select windowsSet
	)
	
	on selectFlipWIndowsBT pressed do
	(
		findWindows helpers
		windowsFlipSet = for w in windowsSet where w.scale.y < 0 collect w
		select 	windowsFlipSet
	)

	
	on openAllSL buttondown do
	(
		format "openAllSL.buttondown openAllSL.value: % \n" openAllSL.value 
		
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
			w.transform = inverse(rotateZMatrix  -openAllSL.value) * initMatrix
		)
		
		for w in winListL do
		(
			initMatrix = w.parent.transform
			initMatrix.translation = w.transform.translation
			w.transform = inverse(rotateZMatrix openAllSL.value) * initMatrix
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
		winSlideListR = #()
		
		for s in sel do
		(
			local res
			try(res = (getUserProp s "pivotFenetre")as booleanClass)catch(res = undefined)
			if res != undefined and res then append winListR s
				
			try(res = (getUserProp s "slideFenetre")as booleanClass)catch(res = undefined)
			if res != undefined and res then append winSlideListR s
		)
		
		for w in winListR do
		(
			initMatrix = w.parent.transform
			initMatrix.translation = w.transform.translation
			w.transform = inverse(rotateZMatrix openRightSL.value) * initMatrix
		)
				
		bakval = openRightSL.value
	)
	
	on openRightSL changed  val do
	(		
		for w in winListR do
		(
			w.transform = (rotateZMatrix (val - bakval)) * w.transform
		)
		
		for  w in winSlideListR do
		(
			if openRightSL.value < 150 then
			(
				w.transform = ((transMatrix (point3  0 ((val - bakval)* -1 ) 0 )) * w.transform)
			)
			else
			(
				w.transform = ((transMatrix (point3  0 ((val - bakval)) 0 )) * w.transform)
			)
		)
		
		bakval = val
	)

	
	on openLeftSL buttondown do
	(
-- 		format "openLeftSL.buttondown\n"
		sel = selection as array
		winListL = #()
		winSlideListL = #()
		
		for s in sel do
		(
			local res, res2
			try(res = (getUserProp s "pivotFenetre")as booleanClass)catch(res = undefined)
			if res != undefined and not res then append winListL s
				
			try(res = (getUserProp s "slideFenetre")as booleanClass)catch(res = undefined)
			if res != undefined and not res then append winSlideListL s
		)
		
		for w in winListL do
		(
			initMatrix = w.parent.transform
			
			initMatrix.translation = w.transform.translation
			w.transform = inverse(rotateZMatrix openLeftSL.value) * initMatrix			
		)
				
		bakval = openLeftSL.value
	)
	
	
	on openLeftSL changed  val do
	(
-- 		format "openLeftSL.changed val: %\n" val
		for w in winListL do
		(
			w.transform = (rotateZMatrix ((val - bakval)*-1) ) * w.transform
		)
		
		for  w in winSlideListL do
		(
			if openLeftSL.value < 200 then
			(
				w.transform = ((transMatrix (point3  0 ((val - bakval)) 0 )) * w.transform)
			)
			else
			(
				w.transform = ((transMatrix (point3  0 ((val - bakval)* - 1) 0 )) * w.transform)
			)
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
		
		closewindowsBT.pressed()
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
		format "Pivots des ouvrants recalés\n"
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
				if s.scale.y >= 0 then
				(
					bbVal = nodeGetBoundingBox s s.transform
-- 					format "bbVal: %\n" bbVal
					s.pivot = ( transMatrix(point3 (bbVal[2].x) (bbVal[2].y) (bbVal[1].z)) * s.transform).translation
				)
				else if s.scale.y < 0 then
				(
					bbVal = nodeGetBoundingBox s (scalematrix (point3 1 -1 1) * s.transform)
					s.pivot = ( transMatrix(point3 (bbVal[2].x) (bbVal[2].y) (bbVal[1].z)) * (scalematrix (point3 1 -1 1) * s.transform)).translation
				)
			)
			else(format "This is not a windows\n")
		)
		format "Pivots des fenêtres recalés\n"
	)
	
	on symWindowsBT pressed do
	(
		-- symetrie de la fenetre en Y
		
		hlps = findWindows (selection as array)
		for h in hlps do
		(
				h.pivot = h.center
				h.transform =  scalematrix (point3 1 -1 1) * h.transform
		)
		
		
-- 		placePivot2BT.pressed()
		resetWindowsBT.pressed()
		resetUI()
	)
	
	
	on resetWindowsBT pressed do
	(
		closewindowsBT.pressed()
-- 		placePivot1BT.pressed()
		placePivot2BT.pressed()
		
		-- hlps = findWindows helpers
		local newH
		hlps = findWindows (selection as array)

		for h in hlps where h.scale.y < 0 do
		(
			format "h.name: % h.scale: %\n" h.name h.scale.y
			local bakName = h.name
			local bakLayer = h.layer
			bakTM = h.transform
			
			-- ramene la fenetre au centre du monde flippée en y
			h.transform = scalematrix (point3 1 -1 1)
			
			-- traitement des objets
			objs = #()
			parents = #()

			hMembers = #(h)
			for dad in hMembers do 
			(
				for c in dad.children do append hMembers c
			)
			format "hMembers: %\n" hMembers
			
			explodeGroup h
				
			for h in hMembers where isvalidnode h do 
			(
				format "h: % parent: %\n" h h.parent
				append objs h
				append parents h.parent
			)

			for o in objs do o.parent = undefined 

			for o in objs do 
			(
				resetxform o
				convertToPoly o
			)
-- 			for o in objs do convertToPoly o

			
			for i = 1 to objs.count do objs[i].parent = parents[i]
			
			newH = group objs
			newH.name = bakName
			bakLayer.addnode newH
			-- tagger comme fenetre
			setUserProp newH "windowsTemplate" "true"
			select newH
			setGroupOpen newH true
			setGroupOpen newH false
			
			-- replacer le pivot en bas à gauche
			bbVal = nodeGetBoundingBox newH newH.transform
			format "bbVal: %\n" bbVal
			newH.pivot = ( transMatrix(point3 (bbVal[2].x) (bbVal[2].y) (bbVal[1].z)) * newH.transform).translation
				
			-- inverser la valeur des ouvrants
			for o in objs do try(setUserProp o "pivotFenetre" (not (getUserProp o "pivotFenetre")))catch()
				
			-- replacer le groupe
			newH.transform = scalematrix (point3 1 -1 1) * bakTM 	

			
		)	
		
		placePivot1BT.pressed()
		format "Reset done\n"
		resetUI ()
	)
)
createdialog openFenetresRLT width: 300




