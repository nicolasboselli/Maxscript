dir = 1
start = -2000

if dir == 1 then
(
	for i = 1 to 2000 do
		(
		$.EditablePoly.slice [1,0,0] [start,0,0] flaggedFacesOnly:on
		start += 6		)
)
else 
	(
		if dir == 2 then
			( 
				for i = 1 to 2000 do
					(
					$.EditablePoly.slice [0,1,0] [0,start,0] flaggedFacesOnly:on
					start += 6
					)
			)
			else
			(
				for i = 1 to 2000 do
					(
					$.EditablePoly.slice [0,0,1] [0,0,start] flaggedFacesOnly:on
					start += 6
					)
			)
	)		

/*	
subobjectLevel = 2
$.edgeChamferOpen = on
$.edgeChamfer = 0.5
*/
