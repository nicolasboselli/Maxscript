-- renaommage des bones
bonesAr = for o in objects where classof o == BoneGeometry collect o 
select bonesAr
for b in bonesAr do 
(
	
	newname = substitutestring b.parent.name "_MDL" "_EndBone_RIG"
	format "bone: %, parent: %, newname: %\n" b.name b.parent.name newname
	b.name = newname
)

-- 
