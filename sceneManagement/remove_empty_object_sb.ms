-- getnumfaces $
objCount = (geometry as array).count
zeroObjAr = #()
count = 0
for o in geometry do 
(
	
	count += 1
	try
	(
		if getnumfaces o == 0 do
		(
			append zeroObjAr o
			format "o: % count: % / %\n" o.name count objCount
		)
		
	)
	catch
	(
		
	)

)
select zeroObjAr

/* for i = zeroObjAr.count to 1 by - 1 do delete zeroObjAr[i] */

