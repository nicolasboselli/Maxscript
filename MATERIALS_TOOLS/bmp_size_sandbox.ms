bmpAr = getclassinstances bitmaptexture target: scenematerials
k = 0
totalSize = 0

for i = 1 to bmpAr.count do
(
	local oneSize = 0
	oneFile = bmpAr[i].filename

	if onefile == undefined then 
	(
		continue
	)
	else if doesfileexist oneFile then 
	(
		oneSize = getFileSize oneFile as integer
-- 		if oneSize 
	)
	else()
	if oneSize > 10000000 then
	(
		k+=1
		totalSize += onesize
		format "% size: \t%mo path: %\n" i (oneSize/1000000) oneFile
	)
)
format "total maps: %\n" k
format "total size: %mo \n" (totalSize/10^6)
-- classof 50L
-- 50L as integerc
	
