oneAr = for i = 5 to 7 collect i
	
twoAr = for i = 10 to 100 by 10 collect i

startToDel = 5
endToDel = 7

for i = startToDel to endToDel do deleteitem twoAr startToDel
for i = oneAr.count to 1 by -1 do insertitem oneAr[i] twoAr (startToDel)
for i = 1 to oneAr.count do insertitem oneAr[i] twoAr (i + startToDel - 1)
	
PS = $

tes = #()

PSPS.stack_objSet[0]

insertitem 1 tes 1

insertitem $Sphere002 PSPS.stack_objSet 3

append  PSPS.stack_objSet  $Sphere003

classof stack_quatxTemp[1]