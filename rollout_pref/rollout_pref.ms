/*
edgeParams = #("pos","size","addExtrusionCB", "addSweepCB", "extSizeSP", "addExtrusionCB", \
		"removeEdgeCB", "resetXformCB", "collapseXformCB", \
		"createBoxOrientCB", "xformOnBoxCB", 	"collapseXformCB2", \
		"delBoxOrientCB", "keepSelCB")
*/
		
fn writeRolloutParams rlt params =
(
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
	local cat = rlt.name
	
	format "WRITE PREF rollout: %\n" cat
	for n in params do
	(
		-- collect position
		if n == "pos" then
		(
			setINISetting armadasScriptsIni cat n  ((GetDialogPos rlt) as string)
			format "name: pos, value: %\n"  (GetDialogPos rlt)
		)
		-- collect size
		else if n == "size" then
		(
			setINISetting armadasScriptsIni cat n  ((GetDialogSize rlt) as string)
			format "name: size, value: %\n"  (GetDialogSize rlt)
		)
		else if n == "rootPlans" or n == "outputPath" then
		(
-- 			format "getProperty % % : %\n" rlt n (getProperty  rlt n)
			p = getProperty  rlt n
			format "name: %, value:  %\n"  n p
			if p != undefined then 	fileProperties.addProperty #custom n  p
		)
		else
		(
			
			p = getProperty  rlt n
			format "n: %, p: %, classof p: %\n" n p (classof p)
			
			-- collect rollout control
			if superclassof p == RolloutControl then
			(
				
				if classof p == checkboxcontrol then 
				(
					setINISetting armadasScriptsIni cat p.name  (p.state as string)
					format "name: %, value: %, classof: %\n" p.name p.state (classof p)
				)
				else if classof p == SpinnerControl then 
				(
					setINISetting armadasScriptsIni cat p.name  (p.value as string)
					format "name: %, value: %, classof: %\n" p.name p.value (classof p)
				)
				else(format "__FAIL__  name: %, classof: %\n" p (classof p))
			)
			-- collect variable
			else if classof p == Array then
			(
				local completeArray = with printAllElements on p as string
				setINISetting armadasScriptsIni cat n completeArray
			)
			else if classof p == string then
			(
				format "name: %, value: %, classof: %\n" n p (classof p)
				setINISetting armadasScriptsIni cat n p
			)
			else if classof p == Point2 then
			(
				format "name: %, value: %, classof: %\n" n p (classof p)
				setINISetting armadasScriptsIni cat n (p as string)
			)
			else
			(
-- 				setINISetting armadasScriptsIni cat n p
				format "__FAIL__  name: %, classof: %, value: %\n" n (classof p) p
			)
		)
	)
	format "WRITE PREF done\n\n" 
)
-- writeRolloutParams edgeToShapeRLT edgeParams

-- fileProperties.findProperty #custom "rootPlans"
-- fileProperties.getPropertyValue  #custom "rootPlans"

-- filePref = #("rootPlans", "outputPath")


fn loadRolloutParams rlt params =
(
	local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
	local cat = rlt.name
	
	format "LOAD PREF rollout: %\n" cat
	for n in params do
	(
		if n == "pos" then
		(
			local posStr
			try(posStr = getINISetting armadasScriptsIni cat "pos")catch(format "*** % ***\n" (getCurrentException()))
			if posStr.count > 0 then setDialogPos rlt (execute posStr)
			format "name: pos,  value: %\n" posStr
		)
		else if n == "size" then
		(
			try(posStr = getINISetting armadasScriptsIni cat "size")catch(format "*** % ***\n" (getCurrentException()))
-- 			format "name: size, value: %\n"  (GetDialogSize rlt)
		)
		else if n == "rootPlans" then
		(
			local val 
			local testVal = fileProperties.findProperty #custom "rootplans"
			if testVal > 0 then
			(
				val = fileProperties.getPropertyValue  #custom testVal
				format "init with fileproperty name: % val: % \n" n val
			)
			else 
			(
				val = getINISetting armadasScriptsIni cat "root"
				format "init with root: %\n" val
			)
			setProperty  rlt n val
		)
		else if n == "outputPath" then
		(
			local val 
			local testVal = fileProperties.findProperty #custom "outputPath"
			if testVal > 0 then
			(
				val = fileProperties.getPropertyValue  #custom testVal
				format "init with fileproperty name: % val: % \n" n val
			)
			else 
			(
				val = getINISetting armadasScriptsIni cat "outputPath"
				format "init with root: %\n" val
			)
			setProperty  rlt n val
		)
		else
		(
			-- load controls properties
			p = getProperty  rlt n
			
			if superclassof p == RolloutControl then
			(
				local val
				try(val = getINISetting armadasScriptsIni cat n)catch(format "*** % ***\n" (getCurrentException()))
-- 				format "name: %, value: %\n" n val
				
				if classof p == checkboxcontrol and val.count > 0 then 		
				(
					p.state = val as BooleanClass
				)
				else if classof p == SpinnerControl and  val.count > 0 then
				(
					p.value = val as float
				)
			)
			else if classof p == Array then
			(
				local val = getINISetting armadasScriptsIni cat n
				if val.count > 1 then
				(
-- 					format "val: %, classof: %\n" val (classof val)
					local cleanAr = #()
					local tmpAr = execute val
					format "tmpAr: %\n" tmpAr
-- 					cleanAr  = for f in tmpAr where doesfileexist f collect f
-- 					format "cleanAr: %\n" cleanAr
					setProperty  rlt n tmpAr
				)
				else 
				(
					setProperty  rlt n #()
				)
-- 				format "n:%, val:%\n" n rlt.p
			)
			else if classof p == string then
			(
				local val = getINISetting armadasScriptsIni cat n
				format "name: %, STRING value: %\n" n val
				setProperty  rlt n val
			)
			else
			(
				-- load variable
				local val = getINISetting armadasScriptsIni cat n 
				format "__UNKNOWN__ name: %, value: %\n" n val
				setProperty  rlt n val
			)
		)
	)	
	format "LOAD PREF done \n\n" cat
)



-- loadRolloutParams edgeToShapeRLT edgeParams

