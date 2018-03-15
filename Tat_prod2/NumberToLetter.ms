
-- return array de valeur en base 26
fn convertNum n =
(
	n1 = n /10 + 1
	n2 = n - (n1 - 1)*10 +1
	[n1,n2]
)


fn renameWithLetter s padding: 1 =
(
	alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

	search = "Planche"
	num
	ref = s.name

	refAr = filterString  ref "_"
	numOk = false
	endName  = ""

	for i = 4 to refAr.count do 
	(
		endName = endName + "_" + refAr[i]
	)

	res = matchpattern  ref  pattern: (refAr[1] + "_"+ refAr[2] + "_" + search + "??" + endname)

	-- récupérer le numero 
	if res == true do 
	(
		ref2 = substituteString ref (refAr[1] + "_"+ refAr[2] + "_" + search) ""
		numStr = substituteString ref2  endName ""
		num = numStr as integer
		
		if num != undefined then numOk = True
	)

	-- changer le nom
	char = undefined
	if numOk == true and padding == 1 then
	(
		char = alphabet[num+1]
	)
	else if numOk == true and padding == 2 then
	(
		res = convertNum num
		char = alphabet[res[1]] + alphabet[res[2]]
	)
	else
	(
		format "pas renommable: %\n" s.name
	)
	
	
	if char != undefined then
	(
-- 		newname = refAr[1] + "_"+ refAr[2] + "_" + search + char + endName
		s.name = refAr[1] + "_"+ refAr[2] + "_" + search + char + endName
	)
	
)

sel = objects as array
for s in sel do renameWithLetter s padding:2
	
/*
pattern = "\w+(\d+\d+)\w+"
test = dotnetObject "System.Text.RegularExpressions.Regex" pattern


pattern =@"\w+(\d+\d+)\w+"
	input =  $.name
	rgx = dotnetObject "System.Text.RegularExpressions.Regex" pattern
	result = rgx.Replace input " "
*/

search = "Planche"
refAr = filterString  $.name "_"
id
for i = 1 to refAr.count do
(
	res = matchpattern refAr[i] pattern: (search + "*")
	if res == true then id = i
)
id
startName = ""
endName = ""

for i = 1 to (id-1) do startname += refAr[i] + "_"
for i = (id +1)  to refAr.count  do endName += "_" + refAr[i] 
startName
endName 



