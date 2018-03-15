objs = objects as array

for o in objs where findString o.name "_BIPSKIN"  != undefined do 
(
	o.length = 1
	o.width = 1
	o.height = 1
)	
	
/*
(
	findString o.name "_BIPSKIN"
	
-- 	if findString o.name "_BIPSKIN"  != undefined then print o

)
*/

