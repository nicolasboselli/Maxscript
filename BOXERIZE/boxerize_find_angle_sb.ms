dot s.transform.row1 normalsCollected[i]


acos(dot [0.0245736,0.999698,0]  [-0.0245575,-0.999698,0])

v1 = [-0.0245577,-0.999698,0]
v2 = [-0.0245577,-0.999698,0]
acos(dot v1 v2)

[-0.0245577,-0.999698,0] normalsCollected[2]: [-0.0245577,-0.999698,0]

-- v1 = $fenetre_detach_2.transform.row1
-- v2 = $fenetre_detach_62.transform.row1
fd2 =  $fenetre_detach_2
fd62 = $fenetre_detach_62

multi = 100

v1x1000 = fd2.transform.row1*multi
v1 = normalize (point3 (floor v1x1000.x) (floor v1x1000.y) (floor v1x1000.z))

v2x1000 = fd62.transform.row1*multi
v2 = normalize (point3 (floor v2x1000.x) (floor v2x1000.y) (floor v2x1000.z))

acos(dot v1 v2)

((((acos(dot fd2.transform.row1 fd62.transform.row1))*100)as integer)as float)/100

acos(dot (point3 0 1 0) (point3 0 -1 0))
	
	
v = $.transform.row1
	
for i = 1 to 20 do
(
	format "i: %\n" i
	if i == 5 then exit
)

testAngle: -nan(ind).0 s.transform.row1: [-0.025,-1,0] normalsCollected[1]: [-0.025,-1,0]

v1 = [-0.025,-1,0]
v2 = [-0.025,-1,0]

acos(dot v1 v2)

acos -2