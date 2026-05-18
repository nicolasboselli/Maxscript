/*
PDV standalone rollout preferences.
Adapted from Maxscript/rollout_pref/rollout_pref.ms.
Uses prefixed functions to avoid replacing the legacy global helpers.
*/

fn PDV_getPrefsDir =
(
	local baseDir = (GetDir #maxData) + "VisiolabTools\\"
	local prefsDir = baseDir + "PDV_TOOLS\\"
	makeDir baseDir
	makeDir prefsDir
	prefsDir
)

fn PDV_getPrefsFile =
(
	(PDV_getPrefsDir()) + "prefs.ini"
)

fn PDV_writeRolloutParams rlt params =
(
	local prefsFile = PDV_getPrefsFile()
	local cat = rlt.name
	
	for n in params do
	(
		if n == "pos" then
		(
			setINISetting prefsFile cat n ((GetDialogPos rlt) as string)
		)
		else if n == "size" then
		(
			setINISetting prefsFile cat n ((GetDialogSize rlt) as string)
		)
		else
		(
			local p = getProperty rlt n
			if superclassof p == RolloutControl then
			(
				if classof p == CheckboxControl then setINISetting prefsFile cat p.name (p.state as string)
				else if classof p == SpinnerControl then setINISetting prefsFile cat p.name (p.value as string)
				else if classof p == RadioControl then setINISetting prefsFile cat p.name (p.state as string)
				else if classof p == ComboBoxControl then setINISetting prefsFile cat p.name (p.selection as string)
			)
			else if classof p == Array then
			(
				local completeArray = with printAllElements on p as string
				setINISetting prefsFile cat n completeArray
			)
			else if classof p == String then setINISetting prefsFile cat n p
			else if classof p == Point2 then setINISetting prefsFile cat n (p as string)
			else if classof p == BooleanClass then setINISetting prefsFile cat n (p as string)
		)
	)
)

fn PDV_loadRolloutParams rlt params =
(
	local prefsFile = PDV_getPrefsFile()
	local cat = rlt.name
	
	for n in params do
	(
		if n == "pos" then
		(
			local val = getINISetting prefsFile cat n
			if val.count > 0 do try(setDialogPos rlt (execute val))catch(format "PDV pref load pos failed: %\n" (getCurrentException()))
		)
		else if n == "size" then
		(
			local val = getINISetting prefsFile cat n
			if val.count > 0 do try(setDialogSize rlt (execute val))catch(format "PDV pref load size failed: %\n" (getCurrentException()))
		)
		else
		(
			local p = getProperty rlt n
			local val = getINISetting prefsFile cat n
			if val.count > 0 then
			(
				if superclassof p == RolloutControl then
				(
					if classof p == CheckboxControl then p.state = val as BooleanClass
					else if classof p == SpinnerControl then p.value = val as Float
					else if classof p == RadioControl then p.state = val as Integer
					else if classof p == ComboBoxControl then p.selection = val as Integer
				)
				else if classof p == Array then try(setProperty rlt n (execute val))catch(setProperty rlt n #())
				else if classof p == String then setProperty rlt n val
				else if classof p == Point2 then try(setProperty rlt n (execute val))catch()
				else if classof p == BooleanClass then setProperty rlt n (val as BooleanClass)
			)
		)
	)
)
