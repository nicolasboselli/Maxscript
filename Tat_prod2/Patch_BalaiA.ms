sel = geometry as array
for s in sel where matchpattern s.name pattern: "A_BalaiA_Algue?_MDL*" do
(
	tmpname = substituteString s.name "_MDL" ""
	tmpname = tmpname + "_MDL"
	print tmpname
	s.name = tmpname
)

algue = $
InstanceMgr.GetInstances algue &instances
select instances

fn numStringToChar str =
(
-- 	local str = num as string
	local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	local res = ""
	
	for i = 1 to str.count do
	(
		val =  str[i] as integer + 1
-- 		print alphabet[val]
		res = res + alphabet[val]
	)
	res
)

search = "AlgueE"
if matchPattern $.name pattern: ("*_" + search + "*_*") then
(
	local char = undefined
	local numAr = undefined 
	refAr = filterString $.name search
	print refAr
	if refAr.Count == 2 then
	(
		print "youpi"
		numAr = filterString refAr[1] "_"
	)else(print "fail 2")
	
	if numAr != undefined do 	char = numStringToChar numAr[1]
	
	if char != undefined then
	(
-- 		newname = refAr[1] + "_"+ refAr[2] + "_" + search + char + endName
		newName = refAr[1] + search + char
		newName
	)
	else(print "fail 1 ")
	
)else(print "fail 0")



fn renameWithLetter10 ref search newNum =
(
-- 	search = "StructureBambou"
	num
	numStr
-- 	ref = s.name

	refAr = filterString  ref "_"
	numOk = true
	
	-- recuperation du end name
	endName  = ""
	for i = 3 to refAr.count do 
	(
		endName = endName + "_" + refAr[i]
	)

	res = matchpattern  ref  pattern: (refAr[1] + "_"+ search + "*" + endname)

	if numOk then char = numStringToChar newNum

	-- rename
	if char != undefined then
	(
-- 		newname = refAr[1] + "_"+ refAr[2] + "_" + search + char + endName
		newName = refAr[1] +  "_" + search + char + endName
	)
	newName
)

sel = selection as array
for s in sel do
(
	for m in s.modifiers do
	(
		print (classof m)
		if classof m == shell then 
		(
			print "youpi"
			deletemodifier s m
		)
	)
)



