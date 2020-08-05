matArToDisp = getclassinstances VRayMtl target: scenematerials  
matArToDisp.count

-- effectIds = for m in vrMtlAr collect m.effect_id
-- sort effectIds

idsArray = #()
for m in matArToDisp do 
(
	test = idsArray[m.effect_Id + 1]
	if test == undefined then insertItem #(m) idsArray (m.effect_Id + 1)
	else insertItem m idsArray[m.effect_Id + 1] 1
)	
idsArray.count

matArToDisp = #()
for a in idsArray where a != undefined do 
(
	join matArToDisp a
)
matArToDisp.count




sorting = 0
fn sortbyId v1 v2 =
(
		-- 	vars
	t0 = timestamp()
	local d
	
	if ( (v1.effect_id) < (v2.effect_id)) then d=1
	else d=-1
		
	sorting += 1
		
	t1 = timestamp()
	if (t1 - t0) > 2 then format "id sorting: % ms\n" (((t1 - t0)as float))
-- 	format "v1: % v2: % d:%\n" v1 v2 d
	--compare les numeros entre eux et les classe	
	case of
	(
		(d < 0.): 1
		(d > 0.): -1
		default: 0
	)
)

(
	t0 = timestamp()
	-- 	(for m in vrMtlAr collect m.effectsChannel)
	qsort   vrMtlAr sortbyId start: 1 end: 300
	t1 = timestamp()
	format "collect id done: % s\n" (((t1 - t0)as float)/1000)	

	-- sorting
	format "id sorting: %\n" sorting
)

nameSorting = 0
fn sortbyname v1 v2 =
(
	-- 	vars
	t0 = timestamp()
	local d
	
	if ( (toupper v1.name) < (toupper v2.name)) then 	d = 1
	else 	d=-1
	nameSorting +=1
	--compare les numeros entre eux et les classe	
	
	t1 = timestamp()
	format "name sorting: % ms\n" (((t1 - t0)as float))
	
	if (d > 0.) then -1
	else if d < 0. then 1
	else 0
	/*
	case of
	(
		(d < 0.): 1
		(d > 0.): -1
		default: 0
	)
	*/
)

(
	t0 = timestamp()
	-- (for m in vrMtlAr collect m.name)
	qsort  vrMtlAr sortbyname
	t1 = timestamp()
	format "collect name done: % s\n" (((t1 - t0)as float)/1000)

	format "nameSorting: %\n" nameSorting
)
