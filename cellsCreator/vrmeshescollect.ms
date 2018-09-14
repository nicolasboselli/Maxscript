-- $.fileNamePreview
fn collectOneVrMesh o vrmeshesFolder =
(
-- 	format "start/n"
	local res = false 
	
	-- check du repo de proxies
	if not doesfileexist vrmeshesFolder then makedir vrmeshesFolder
	
	-- creation du nouveau proxy et remap
-- 	format "filename: %\n" o.filename
	if doesfileexist o.filename then
	(
		vrmeshName = getFilenameFile o.filename
		newVrmeshFileName = vrmeshesFolder + "\\" + vrmeshName + ".vrmesh"
		
		-- copy du proxy et remap
		if not doesfileexist newVrmeshFileName then 
		(
			res = copyfile o.filename newVrmeshFileName
			if res then o.filename = newVrmeshFileName
		)
	)
	
	-- creation du nouveau proxy preview et remap
	vrmeshFilePrev = o.fileNamePreview
-- 	format "preview: %\n" o.fileNamePreview
	if vrmeshFilePrev != undefined then
	(
		if doesfileexist o.fileNamePreview then
		(
			vrmeshNamePrev = getFilenameFile vrmeshFilePrev
			newVrmeshFileNamePrev = vrmeshesFolder + "\\" + vrmeshNamePrev + ".vrmesh"
			
			-- copy du proxy et remap
			if not doesfileexist newVrmeshFileNamePrev then 
			(
-- 				format "vrmeshFilePrev >> newVrmeshFileNamePrev\n"
				res = copyfile vrmeshFilePrev newVrmeshFileNamePrev
				if res then o.fileNamePreview = newVrmeshFileNamePrev
			)
		)
	)
-- 	format "done/n"
)


sel = geometry as array
vrProxies = for o in sel where classof o == vrayproxy collect o
	
vrmeshesFolder = @"M:\Interieur\Cellules\Modelisation\Ambiances\AmiensKaufman_01\proxies"
for vr in vrProxies do 
(
	collectOneVrMesh vr  vrmeshesFolder
)