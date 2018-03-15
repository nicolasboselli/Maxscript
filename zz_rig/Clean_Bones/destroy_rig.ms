

--recreate bones chain sur os contraints
	
c = [1,0,0]
bn_pts = $ as array
bn_pts_pos = for o in bn_pts collect in coordsys parent o.pos
os = for i= 1 to (bn_pts.count-1) collect (BoneSys.createBone bn_pts_pos[i]  bn_pts_pos[i+1]  c )
bn_pts_bonus = point ()	
bn_pts_bonus.pos =bn_pts_pos[bn_pts.count] + ( bn_pts_pos[bn_pts.count] - bn_pts_pos[(bn_pts.count)-1])/10
os_bonus = BoneSys.createBone bn_pts_pos[bn_pts.count]  bn_pts_bonus.pos c 

append os os_bonus
	
for i = 1 to os.count-1 do os[i+1].parent = os[i]

--delete $B
delete bn_pts_bonus
delete bn_pts

------------------------------------------------------------------------------------------	

--recreate bones chain sur chaine d'os ou sur points libres

c = [1,0,0]
GGos = for i= 1 to (bn_pts.count-1) collect (BoneSys.createBone bn_pts_pos[i]  bn_pts_pos[i+1]  c )
bn_pts_bonus = point ()	
bn_pts_bonus.pos =bn_pts_pos[bn_pts.count] + ( bn_pts_pos[bn_pts.count] - bn_pts_pos[(bn_pts.count)-1])/10
os_bonus = BoneSys.createBone bn_pts_pos[bn_pts.count]  bn_pts_bonus.pos c 

append os os_bonus
	
for i = 1 to os.count-1 do os[i+1].parent = os[i]


delete bn_pts_bonus
G
------------------------------------------------------------------------------------------
-- REBOOT BONES
-- recolter position dans systeme world et parent
-- recolter rotation
-- placer des controller rotation et position xyz
-- reset scale et realign chain bones
-- appliquer rotation et position au pemier bone
-- appliquer position par rapport au parent sur les autres os

-- nettoyer les bones de tous les controllers tous en preservant leur position

