try(destroydialog openFenetresRLT)catch()
rollout openFenetresRLT "open Fenêtres"
(
	group "tags"
	(
		button clockwiseBT "rotation horaire" across: 3
		button antiClockwiseBT "rotation anti-horaire"
		button clearTagBT "clear tags"
	)
	
	group "actions"
	(
		button openWindowsBT "open windows" across: 3
		button closewindowsBT "close windows"
		button flipWindowsBT "flip windows"
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