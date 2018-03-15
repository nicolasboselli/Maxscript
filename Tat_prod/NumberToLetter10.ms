fn numStringToChar num =
(
	local str = num as string
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

fn charStringToString num =
(
	alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	alphaAr = for i = 1 to alphabet.count collect alphabet[i]
	res = ""
	
	for i = 1 to num.count do
	(
		val =  finditem alphaAr num[i] 
		print alphabet[val]
		res = res + (val as string)
	)
	res
)
-- charStringToString "AAB"

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
	/*
	-- récupérer le numero 
	if res == true do 
	(
		ref2 = substituteString ref (refAr[1] + "_" + search) ""
		numStr = substituteString ref2  endName ""
		try(
			num = numStr as integer
			if num != undefined then numOK = true else()
			
			) catch()

-- 		if num != undefined then numOk = True
	)
	*/
	
	-- changer le nom
-- 	char = undefined
-- 	if numOk then char = numStringToChar numStr
	if numOk then char = numStringToChar newNum

	-- rename
	if char != undefined then
	(
-- 		newname = refAr[1] + "_"+ refAr[2] + "_" + search + char + endName
		newName = refAr[1] +  "_" + search + char + endName
	)
	newName
)


fn replaceInc oneName search newNum =
(
	local checkPattern
	local char
	
	refAr = filterString  oneName "_"
	
	-- recuperation du end name
	endName  = ""
	for i = 3 to refAr.count do endName = endName + "_" + refAr[i]
	
	-- check du nom
	patternToCheck = refAr[1] + "_"+ search + "*" + endname
	checkPattern = matchpattern  oneName  pattern: patternToCheck
	
	-- calcul du caractere
	char = numStringToChar newNum
	
-- 	format "res: %, char: %\n" res char
	-- rename
	if char != undefined and checkPattern == true then
	(
-- 		newname = refAr[1] + "_"+ refAr[2] + "_" + search + char + endName
		newName = refAr[1] +  "_" + search + char + endName
		newName
	)else(print "nouvel increment impossible")
	
)
-- matchpattern  $.name  pattern: "A_StructureBambou*"

count = random 0 10000
for s in selection do
(
	new = replaceInc s.name "StructureBambou" count
	print new
	count += 1
)

