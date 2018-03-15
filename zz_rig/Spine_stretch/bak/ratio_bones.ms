--selectionner bones


bn = $ as array

--- bones tunés aux helpers
bn_pts = for i = 1 to bn.count collect point ()
for o in bn_pts do
(
o.Box = on
o.axistripod = off
o.Box = off
)
-- contrainte position des bones
for i = 1 to bn_pts.count do
	( 
	bn_pts[i].pos = bn[i].pos
	bn[i].pos.controller = Position_xyz ()
	bn[i].pos.controller = Position_Constraint ()
	bn[i].pos.controller.constraints.appendtarget bn_pts[i] 100
	)

-- contrainte rotation des bones
yo = bn_pts.count-1
for i = 1 to yo do
	(
		
	bn[i].rotation.controller = LookAt_Constraint ()
	bn[i].rotation.controller.constraints.appendTarget bn_pts[i+1] 100 
	bn[i].rotation.controller.upnode_world = off
	bn[i].rotation.controller.pickUpNode = bn_pts[i]
	bn[i].rotation.controller.upnode_ctrl = 1
	bn[i].rotation.controller.viewline_length_abs = off
	bn[i].rotation.controller.lookat_vector_length = 0
	)
-- créer la spline
os = bn

os_pos = for o in os collect in coordsys parent o.pos

test = line ()
addnewspline test
for i = 1 to os.count do 
addknot test 1 #smooth #curve os_pos[i]
updateshape test	
ligne = test

--redéfinir la spline
--taille chaine boness

boness = bn

longueurs = for i = 1 to (boness.count-1) collect distance boness[i] boness[i+1]

sum = 0
test = for o in longueurs collect sum += o
longueur = test[boness.count-1]
ratio = for i = 1 to (boness.count-1) collect longueurs[i] / longueur

sum = 0
ratio_plus = for o in ratio collect sum += o
insertItem 0 ratio_plus 1


-- contraindre la position des os à la spline
for i = 1 to bn_pts.count do
(
bn_pts[i].pos.controller = Path_Constraint ()
bn_pts[i].position.controller.constraints.appendTarget ligne 50
bn_pts[i].pos.controller.PERCENT = ratio_plus[i] * 100
)


----contraindre l'orientation  des os
-- helper twist bas
hlp_orient = for o in bn_pts collect copy o
for o in hlp_orient do o.axistripod = on
for i =  2 to hlp_orient.count do 
(
hlp_orient[i].rotation.controller = LookAt_Constraint ()
hlp_orient[i].rotation.controller.constraints.appendTarget hlp_orient[i-1] 50
hlp_orient[i].rotation.controller.viewline_length_abs = off
hlp_orient[i].rotation.controller.target_axis = 2
hlp_orient[i].rotation.controller.target_axisFlip = on


hlp_orient[i].rotation.controller.upnode_world = off
hlp_orient[i].rotation.controller.pickUpNode = hlp_orient[i-1]
hlp_orient[i].rotation.controller.upnode_ctrl = 1

hlp_orient[i].rotation.controller.upnode_axis = 1
hlp_orient[i].rotation.controller.StoUP_axis = 1
)

--helper twist haut




----------ajout de contrainte chemin

--$.pos.controller.PERCENT = 0.5
