-- maj:  refaire la vue au clic
-- getThisScriptFilename() 


rollout visualSelCtrRLT "Control Placeur"
(
	
-- 	vars
	local ctrStack =  TempCtr
	local imgFile = openBitmap tempImgFile
	local buttonEditor = tempbuttonEditor
	local supRlt = tempSupRlt
-- 	UI
	imgTag  test  bitmap:  imgFile  pos: [0,0]
	
-- 	REP1
	
-- 	 getThisScriptFilename() 
		
	on test mousedown v1 v2 do
	(
		print ctrStack
		s = 20
		
		ctrStack.butCount += 1
		buttonEditor.butCountET.text = (ctrStack.butCount as string)
	
		append ctrStack.butIDAr ("oneBT" + (ctrStack.butCount as string))
		buttonEditor.butNamArLB.items = for  o in ctrStack.butIDAr collect o
			
		append ctrStack.butLabAr (ctrStack.butCount as string)
		buttonEditor.butLabArLB.items = for  o in ctrStack.butLabAr collect o
			
		append ctrStack.XcoordAr v1.x
		append ctrStack.YcoordAr v1.y
		
		if (getnodebyname  "xxxxblankxxxx") == undefined then point name:  "xxxxblankxxxx" else blank = getnodebyname   "xxxxblankxxxx"
		append ctrStack.objAr blank
		
		buttonEditor.objArLB.items = for o in  ctrStack.objAr collect o.name
		
		reFreshViewFN ctrStack imgFile supRlt visualSelCtrRLT
-- 		destroyDialog  visualSelCtrRLT
		
	)
	
)

