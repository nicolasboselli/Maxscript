global StructuredStorage = dotnet.loadassembly @"C:\Users\Visiolab\Desktop\StructuredStorage_V10.2_binaries\64\CalumMcLellan.StructuredStorage.dll"
-- global StructuredStorage = dotnet.loadassembly (getroot() + "sceneManagement/StructuredStorage_V10.2_binaries/64/CalumMcLellan.StructuredStorage.dll")

/*
fn walkDir3 dir pattern =
(
	local maxFiles = 2000
	local maxFolds = 1000
	local dirArr = #(dir)
	local fileArr = #()
	
	-- collecte des fichiers dans le premier dossier
	local ff = getFiles (dir + pattern)
	for f in ff do append fileArr f
	
	local i = 0
	
	local foldersCount = 0
	local fileCount = 0
	
	-- pour chaque dossier
	for d in dirArr do
	(
		i += 1
-- 		format "i:%\n" i
		local dirTmp = GetDirectories  (d + "\\*")
-- 		format "scanned: %\n" d 
-- 		format "dirArr.count: %\n" dirArr.count
		
		if dirTmp != undefined then 
		(
			if dirTmp.count > 0 then
			(
				for j = 1 to dirTmp.count do
				(
					foldersCount += 1
-- 					append dirArr dirTmp[j] 
					insertItem  dirTmp[j] dirArr (i+j)
					
					-- collect files
					local fTmp = getFiles (dirTmp[j] + pattern)
					for f in fTmp do
					(
						PropertySets = dotnetobject "CalumMcLellan.StructuredStorage.PropertySets" f on -- ON is for read only
						member = dotnetclass "CalumMcLellan.StructuredStorage.PropertySetIds"
						
						fileCount += 1
						
						if PropertySets.Contains member.UserDefinedProperties do
						(
							pp = PropertySets.item[member.UserDefinedProperties]
							enum = pp.GetEnumerator()
					-- 		format "enum: %\n" enum
							enum.MoveNext()
							while enum.current != undefined do
							(
								if enum.current.name == "RailClone_Inside" then format "railclone_inside: %, %\n" enum.current.value f 
					-- 			format "\t%: %\n" enum.current.name enum.current.value
								enum.MoveNext()
							)
					-- 		enum.Dispose()
						)
						
					)
					if fileArr.count > maxFiles then exit
				)
			)
		)
		
-- 		format "dirArr.count: %\n" dirArr.count
		if i  > 1000 then exit
		if fileArr.count > maxFiles then exit
	)
	
	format "foldersCount: %\nfileCount: %\n" foldersCount fileCount
	
	
	sort fileArr
)
*/

fn returnDigit num =
(
	numStr = ""
	if num<=9 then numStr = "00" + (num as string)
	else if num>9 then numStr = "0" + (num as string)
	else if num>99 then numStr = (num as string)
	numStr
)

fn incrementMaxFileName f =
(
	local fpath = getFilenamePath f
	local ftype = getFilenameType f
	local fname = getFilenameFile f
	local nameAr = filterString  fname "."
	local oldNumStr = nameAr[nameAr.count]
	local newNum = (oldNumStr as integer) + 1
	local newNumStr = returndigit newNum
	local newfname = substitutestring fname oldNumStr newNumStr
	
	fpath + newfname + ftype
)


fn walkDir4 dir pattern =
(
-- 	local maxFiles = 2000
-- 	local maxFolds = 1000
	local dirArr = #(dir)
	local fileArr = #()
	
	local i = 0
	
-- 	local foldersCount = 0
-- 	local fileCount = 0
	
	-- collecte des fichiers dans le premier dossier
-- 	local ff = getFiles (dir + pattern)
-- 	for f in ff do append fileArr f
	
	-- pour chaque dossier
	for d in dirArr do
	(
		i += 1
		local dirTmp = GetDirectories  (d + "\\*")
		
-- 		collect sub folders
		if dirTmp != undefined then 
		(
			if dirTmp.count > 0 then
			(
				for j = 1 to dirTmp.count do
				(
-- 					foldersCount += 1
					-- insert folder dans l'array
					insertItem  dirTmp[j] dirArr (i+j)
				)
			)
		)
		if dirArr.count  > 1000 then exit
		
		-- collect files du dossier
		local fTmp = getFiles (d + pattern)
		for f in fTmp do
		(
			PropertySets = dotnetobject "CalumMcLellan.StructuredStorage.PropertySets" f on -- ON is for read only
			member = dotnetclass "CalumMcLellan.StructuredStorage.PropertySetIds"
			
-- 			fileCount += 1
			
			if PropertySets.Contains member.UserDefinedProperties do
			(
				pp = PropertySets.item[member.UserDefinedProperties]
				enum = pp.GetEnumerator()
		-- 		format "enum: %\n" enum
				enum.MoveNext()
				while enum.current != undefined do
				(
					if enum.current.name == "RailClone_Inside" then 
					(
-- 						format "railclone_inside: %, %\n" enum.current.value f 
-- 						format "class: %\n" (classof  enum.current.value)
						
						if enum.current.value == true then
						(
							--  verifier qu'il y a un increment au dessus
							local newFile = incrementMaxFileName f
-- 							format "railclone_inside: %, %\n" enum.current.value f 
							
							if not doesfileexist newFile then 
							(
								format "railclone_inside: %, %\n" enum.current.value f 
								append fileArr f
							)
							
								-- si il y a un incremant au dessus : passer
								-- si il n y a pas d'increamnt au dessus : retourner fichier
						)
						
					)
					enum.MoveNext()
				)
		-- 		enum.Dispose()
			)
			
		)
-- 		if fileArr.count > maxFiles then exit	
		if fileArr.count > 1000 then exit				
	)
	
	format "foldersCount: %\nfileCount: %\n" dirArr.count fileArr.count
	
	sort fileArr
)


-- maxfile = (maxFilePath + maxFileName)






-- touver les fichiers modelisation
dir = "T:\Green City Immobilier\St Maur_0418"
pattern =  "*.modelisation.*.max"
-- test = walkDir3 dir pattern
test = walkDir4 dir pattern
-- test.count
-- touver le dernier increment de chaque fchier modelisation
-- retourner si il y a du railclone dedans
