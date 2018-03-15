s = $
ctr_pos = s.pos.controller[2]
ctr_rot = s.rotation.controller

selectkeys ctr_pos ( interval 10 70 )
selectkeys str_rotation (interval 10 70 )

s = $ as array
test = for o in s collect getSubAnimName o.transform.controller.position.controller 2
test = for o in s collect getSubAnimName o.transform.controller.rotation.controller 2
test = for o in s collect o.pos.controller[2]
	
for o in test do print o
for i = 1 to test.count do print test[i]
	
s.transform.controller.position.controller.x_position.controller.value

select $Circle034

$.pos.controller[2]

start = 360
end = 430

for o in s do
(
selectkeys o.pos.controller[2] ( interval start end )
selectkeys o.rotation.controller[2] ( interval start end )
)

for o in s do
(
deselectKeys o.pos.controller[2] ( interval start end )
deselectKeys o.rotation.controller[2] ( interval start end )
)


ctr_pos = s.pos.controller
deselectKeys 

selectkey $.pos.controller.zero_pos_xyz.controller 4

keys = $.pos.controller.zero_pos_xyz.controller.keys

addNewKey ctr_pos 30
addNewKey ctr_pos 70

numSelKeys 

getKeyIndex $.pos.controller.zero_pos_xyz.controller 100
getKeyTime $.pos.controller.zero_pos_xyz.controller 2

---------------------------------------------------------------------------------------------
start = 360f
end = 450f

s = $ as array
-- position
keys = for o in s collect
(
o.pos.controller[2].controller.keys
)


keys2 = for a = 1 to s.count collect
(
for b = 1 to keys[a].count collect
(
getKeyTime s[a].pos.controller[2].controller b
)
)


for a = 1 to s.count do
(
for i = 1 to keys[a].count do
(
		if keys2[a][i] > start then
		(
			if keys2[a][i] < end  then
			(
			selectkey s[a].pos.controller[2].controller i
			--selectkey s[a].rotation.controller[2].controller i
			)
		)
)
)

-- rotation

keys = for o in s collect
(
o.rotation.controller[2].controller.keys
)


keys2 = for a = 1 to s.count collect
(
for b = 1 to keys[a].count collect
(
getKeyTime s[a].rotation.controller[2].controller b
)
)


for a = 1 to s.count do
(
for i = 1 to keys[a].count do
(
		if keys2[a][i] > start then
		(
			if keys2[a][i] < end  then
			(
			selectkey s[a].rotation.controller[2].controller i
			--selectkey s[a].rotation.controller[2].controller i
			)
		)
)
)
-- creer une cle a l'entree et a la sortie de l'intervalle, recupere les index et selectionner toutes les clefs entre ces deux index suprrimer les cles