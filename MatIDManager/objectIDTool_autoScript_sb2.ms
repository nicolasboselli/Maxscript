visioIDsIni = getFilenamePath (getThisScriptFilename()) + "visiolabIDs.ini"
VisioIdsAr = execute (getINISetting visioIDsIni "VisiolabIDs" "VisioIdsAr")
VisioLabelsAr = execute (getINISetting visioIDsIni "VisiolabIDs" "VisioLabelsAr")
	


-- stringScript append "toto"
format "toto" to: stringScript
stringScript
	
	
	
-- stringScript as string

-- (stringStream "toto") 
--  "tpt"

stringScript = stringStream  ""
append stringScript "try(destroydialog gbufferChannel0RLT)catch()\n"
append stringScript "rollout gbufferChannel0RLT (\"Visiolab Objects ID Tool v.\"  + ( getScriptVersion (getThisScriptFilename()) as string))\n"
append stringScript "(\n"
append stringScript ")\n"
append stringScript"createdialog gbufferChannel0RLT width: 400\n"

execute (stringScript as string)