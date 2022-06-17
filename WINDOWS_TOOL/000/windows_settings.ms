/*
to do:

/- caler chaque pivot dans le coin bas des battants et de la fenetre
- redimensionner les fenetres 
- remettre le scale d'une fenetre dans le bon sens
*/

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
createdialog windowsSettingsRLT width: 300