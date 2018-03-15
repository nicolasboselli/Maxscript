
--à partir de trois bones
os = $selection as array

-- création de bak bones
BakBonesFN (os)



-- creation de trois point pour l'ikchain
wire_temp = randomColor ()
fkPointAr = for i = 1 to os.count collect 
(
point name: (uniquename "fkPoint_") rotation: os[i].rotation pos:os[i].pos \
	size: 4 box:true cross: true axistripod: false \
	boneEnable: true boneFreezeLength:false  wirecolor: blue
)

for i = 2 to fkPointAr.count do fkPointAr[i].parent = fkPointAr[i-1]