--classe un array en fonction des valeur des numeros des elements

fn compareFN a b =
(
local d = ((replace a.name 1 3 "") as integer) - ((replace b.name 1 3 "") as integer) 
case of
(
(d < 0.): -1
(d > 0.): 1
default: 0
)
)

qsort test compareFN 

test = for p in test collect p
	
--creation boites
for i = 1 to 10 do box ()
test = $ as array
for i=1 to test.count do test[i].pos.x = 50*i
	

