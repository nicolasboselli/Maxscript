/*
maj:
-- one structure for all asset
	-- init from scene
		-- file name construction: root + assets folderName + relativePath + assetname + version + assetName + ".max"
	-- init from selection
	-- init from ini file
	-- init from controller

-- conf: asset tank: zz_ressources3D
-- include merge as method of asset class
	-- parameters:
		-- root
		-- relative path
		-- asset name
		-- last version
*/


fn fileTime file =
(
	dotnetFile = dotnetClass "System.IO.File"
	fileDate = dotnetFile.GetLastWriteTime file
	timeZero = (dotnetobject "system.datetime" 1980 1 1 0 0 0)
	timeLapse = fileDate.subtract timeZero
	ElapsedSeconds = timeLapse.TotalSeconds
	ElapsedSeconds as integer
)


fn localTimeStr =
(
	timeAr = getLocalTime() 
	timeStr = stringstream ""
-- 	format "%_%_%_%_%_%_%" timeAr[1] timeAr[2] timeAr[4] timeAr[5] timeAr[6] timeAr[7] timeAr[8] to: timeStr
	format "%_%_%_%_%" timeAr[1] timeAr[2] timeAr[4] timeAr[5] timeAr[6] to: timeStr
	timeStr as string
)

-- getUpperFolder maxFilePath
fn getUpperFolder currentPath =
(
	pathAr = filterString  currentPath "\\"
	
	-- test if there is an hardisk path or unc path
	if pathAr.count > 1 then 	res = findString pathAr[1] ":"
	
	-- 
	if res == undefined then upperPath = "\\\\"
	else upperPath = ""
		
	for i = 1 to (pathAr.count - 1) do upperPath =upperPath + pathAr[i] + "\\"

	upperPath
)	

fn returnAllHierarchyDown selArray=
(
	for s in selArray do
	(
		if s.children.count > 0 then
		(
			for c in s.children do  append selArray c
		)
	)
-- 	print selArray
	selArray
)

fn cleanFilename filename =
(
	local cleanName =substituteString filename "\\\\" "\\"
-- 	cleanName =substituteString filename "\\" "/"
	cleanName
)

fn returnDigit num =
(
	numStr = ""
	if num<=9 then numStr = "00" + (num as string)
	else if num>9 then numStr = "0" + (num as string)
	else if num>99 then numStr = (num as string)
	numStr
)




