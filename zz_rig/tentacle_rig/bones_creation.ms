

/* deprecated
gap = 0
b0 = bone pos:[0,gap,0]


for i = 1 to 50 do
(
	gap -= 5
	in b0 b = bone pos:[0,gap,0]
	b0 = b
)
*/

boneCount = 32
gap = 8
prev = 0

b = BoneSys.createBone [0,prev,0] [0,(prev-gap),0] [1,0,0]

for i = 1 to boneCount do
(
	prev -= gap
	b0 = BoneSys.createBone [0,prev,0] [0,(prev-gap),0] [1,0,0]
	b0.boneScaleType=#squash
	b0.parent = b
	b = b0
)

-- box

boxCount = 20
gap = 8
prev = 0

b = box pos: $.position length: 5 width: 5 height: 5

for i = 1 to boxcount do
(
-- 	prev += gap
-- 	b0 = BoneSys.createBone [0,prev,0] [0,(prev-gap),0] [1,0,0]
	b0 = box pos: (b.position + [ 0 , -8 , 0]) length: 5 width: 5 height: 5
-- 	b0.boneScaleType=#squash
	b0.parent = b
	b = b0
)




