/*
AMELIORATIONS


-- placer un custom attribute sur les controller spline pour controller le smooth de la spline
*/



--DEBUGggs
-- pour faire une une copie d'ik spine il faut organiser la selection en selectionnant en premier le l'objet qui a le moins de reference.
-- maj: accrocher une première série de helper à la spline. attacher tous les helpers des bones à cette série et la copie devrait fonctionner

execute(openfile ((getDir #scripts) + "\zz_rig\bakBones.ms"))

-- getThisScriptFilename() 


bn = $ as array


BakBonesFN bn

---------------------------------------------------------------------------------------------------------
-- TUNAGE DES BONES 


-- creation des helpers d'orientation pour le twist des bones
bn_pts = #()
ptOnSplineAr = #()
hlp_orient = #()
hlp_orient_up = #()


for o in bn do
(
	pointTemp = point name: (uniquename "hlp_bn") box: off axistripod: on cross: off wirecolor: green size: (units.decodeValue "10cm") rotation: o.rotation pos: o.position
	ptOnSpline = point name: (uniquename "ptOnSpline") box: on axistripod: off cross: on wirecolor: orange size: (units.decodeValue "5cm") rotation: o.rotation pos: o.position
	pointTempdw = point name: (uniquename "hlp_orient_dw") box: off axistripod: on cross: off wirecolor: yellow size: (units.decodeValue "8cm") rotation: o.rotation pos: o.position
	pointTempUp = point name: (uniquename "hlp_orient_up") box: off axistripod: on cross: off wirecolor: blue size: (units.decodeValue "8cm") rotation: o.rotation pos: o.position
	
	append bn_pts pointTemp
	append ptOnSplineAr  ptOnSpline
	append hlp_orient pointTempdw
	append hlp_orient_up pointTempUp
	 
)


-- attachement des bones aux helpers en positions
for i = 1 to bn_pts.count do
( 
	bn_pts[i].pos = bn[i].pos
	bn[i].pos.controller = Position_xyz ()
	bn[i].pos.controller = Position_Constraint ()
	bn[i].pos.controller.constraints.appendtarget bn_pts[i] 100
)

-- attachement des bones aux helpers en rotation
yo = bn_pts.count-1
for i = 1 to yo do
(		
	bn[i].rotation.controller = LookAt_Constraint ()
	bn[i].rotation.controller.constraints.appendTarget bn_pts[i+1] 100 
	bn[i].rotation.controller.upnode_world = off
	bn[i].rotation.controller.pickUpNode = bn_pts[i]
	bn[i].rotation.controller.upnode_ctrl = 1
	bn[i].rotation.controller.StoUP_axis = 1
	bn[i].rotation.controller.upnode_axis = 1

	bn[i].rotation.controller.viewline_length_abs = off
	bn[i].rotation.controller.lookat_vector_length = 0
)
	
---------------------------------------------------------------------------------------------------------
-- CREATION DE LA SPLINE
-- créer la spline
os = bn

os_pos = for o in os collect in coordsys parent o.pos

test = line name: (uniquename "zkin_line")
addnewspline test
for i = 1 to os.count do 
addknot test 1 #smooth #curve os_pos[i]
updateshape test	
ligne = test
guide =  copy ligne

--/*
-- NETTOYAGE DE LA SPLINE (amelioration : redefintion)


--nb = numKnots ligne
knots = numKnots ligne

if knots > 2 do 
(
	for i = 1 to (knots - 2) do
	(
		deleteknot ligne 1  2
		updateshape ligne
	)
)


--*/

---------------------------------------------------------------------------------------------------------

	print "skinWay"
	-- controle de la spline AVEC UN SKIN
	---- creation d'un helper a chaque vertex de la spline

	-- recuperation des numeros de knots important
	knots = numKnots ligne
	knots_max = knots * 3

	-- creation de l'array des knots important
	nb_array = #(2, 3 )

	append nb_array (knots_max - 2)
	append nb_array (knots_max - 1)
	makeUniqueArray nb_array

	setKnotType ligne 1 1 #beziercorner
	setKnotType ligne 1 knots #beziercorner

	-- recuperation des positions des knots controlleurs
	pos1 = getknotpoint ligne 1 1
	pos2 = getoutvec ligne 1 1
	pos3 = getinvec ligne 1 knots
	pos4 = getknotpoint ligne 1 knots

	-- creation de l'array des positions de knots controlleur
	pos_array = #(pos1, pos2, pos3, pos4)

	-- creation des helpers de positions pour les knots controlleurs
	hlp_spline = for o in pos_array collect point pos: o name: (uniquename "hlp_spline") size:  (units.decodeValue "5cm") box: true cross: true  axistripod: false  wirecolor: yellow

	--for o in hlp_spline do o.parent = hlp_spline_pos
	hlp_spline[2].parent  =  hlp_spline[1]
	hlp_spline[3].parent  = hlp_spline[4]

	---- application d'un skin a la spline
	select ligne
	modPanel.addModToSelection (Skin ()) ui:on


	---- enregistrement de chaque helper dans le skin
	for o in hlp_spline do
	(
	skinOps.addbone ligne.modifiers[#skin] o 0
	)


	---- alignement des helpers
	in coordsys parent hlp_spline[2].pos = [20,0,0]
	in coordsys parent hlp_spline[3].pos = [-20,0,0]


---------------------------------------------------------------------------------------------------------
-- CONTRAINTE DES BONES A LA SPLINE
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


for i = 1 to ptOnSplineAr.count do
(
ptOnSplineAr[i].pos.controller = position_xyz ()
ptOnSplineAr[i].pos.controller = Path_Constraint ()

ptOnSplineAr[i].position.controller.constraints.appendTarget ligne 50

deletekeys ptOnSplineAr[i].pos.controller #allkeys
ptOnSplineAr[i].pos.controller.PERCENT = 0

ptOnSplineAr[i].pos.controller.PERCENT.controller = float_list ()
ptOnSplineAr[i].pos.controller.PERCENT.controller.available.controller = float_script ()
percent = ratio_plus[i] 
ptOnSplineAr[i].pos.controller.PERCENT.controller.float_script.controller.addconstant "percent" percent
ptOnSplineAr[i].pos.controller.PERCENT.controller.float_script.controller.script = "percent"
ptOnSplineAr[i].pos.controller.loop = off
ptOnSplineAr[i].pos.controller.PERCENT.controller.weight[1] = 0
)


for i = 1 to bn_pts.count  do
(
	bn_pts[i].parent =  ptOnSplineAr[i]
	in coordsys Parent bn_pts[i].rotation = eulerangles 0 0 0
	in coordsys Parent bn_pts[i].position = [ 0, 0, 0]
		
	hlp_orient[i].parent = ptOnSplineAr[i]
	in coordsys Parent hlp_orient[i].rotation = eulerangles 0 0 0
	in coordsys Parent hlp_orient[i].position = [ 0, 0, 0]
		
	hlp_orient_up[i].parent = ptOnSplineAr[i]
	in coordsys Parent hlp_orient_up[i].rotation = eulerangles 0 0 0
	in coordsys Parent hlp_orient_up[i].position = [ 0, 0, 0]
)


---------------------------------------------------------------------------------------------------------
-- CREATION DU TWIST

-- attachement des heper de twist à la spline
/*
bn_pts_pos_ctr = for o in bn_pts collect o.pos.controller
for i = 1 to hlp_orient.count do hlp_orient[i].pos.controller = copy bn_pts_pos_ctr[i]
for i = 1 to hlp_orient_up.count do hlp_orient_up[i].pos.controller = copy bn_pts_pos_ctr[i]
*/

-- preparation des helpers d'orientation haut
for i = 1 to (hlp_orient_up.count-1) do 
(
	hlp_orient_up[i].rotation.controller = Euler_xyz ()
	hlp_orient_up[i].rotation.controller = LookAt_Constraint ()
	hlp_orient_up[i].rotation.controller.constraints.appendTarget hlp_orient_up[i+1] 50
	hlp_orient_up[i].rotation.controller.viewline_length_abs = off
	hlp_orient_up[i].rotation.controller.target_axis = 2
	hlp_orient_up[i].rotation.controller.target_axisFlip = off


	hlp_orient_up[i].rotation.controller.upnode_world = off
	hlp_orient_up[i].rotation.controller.pickUpNode = hlp_orient_up[i+1]
	hlp_orient_up[i].rotation.controller.upnode_ctrl = 1

	hlp_orient_up[i].rotation.controller.upnode_axis = 1
	hlp_orient_up[i].rotation.controller.StoUP_axis = 1
)

-- preparation des helpers d'orientation bas

for i =  2 to hlp_orient.count do 
(
	hlp_orient[i].rotation.controller = Euler_xyz ()
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

-- contraindre helper bones aux twist
part = 100/(bn_pts.count-2)
for i = 1 to bn_pts.count do
(
	bn_pts[i].rotation.controller = euler_xyz ()
	bn_pts[i].rotation.controller = Orientation_Constraint ()
	bn_pts[i].rotation.controller.constraints.appendTarget hlp_orient[i] ((100-part*i)+part)
	bn_pts[i].rotation.controller.constraints.appendTarget hlp_orient_up[i] (part*i-part)
)


---------------------------------------------------------------------------------------------------------

-- CREATION DES CONTROLEURS SPLINE
-- creation des controller
ctr_dw = circle name: (uniquename "ctr_dw") radius:10 rotation: hlp_spline[1].rotation  pos: hlp_spline[1].pos radius: (units.decodeValue "20cm") wirecolor: yellow
ctr_up = circle name: (uniquename "ctr_up") radius:10 rotation: hlp_spline[4].rotation  pos: hlp_spline[4].pos radius: (units.decodeValue "20cm") wirecolor: yellow

hlp_spline[1].parent = ctr_dw
hlp_spline[4].parent = ctr_up

ecart = distance ctr_dw ctr_up
-- linker les controleurs de twist en rotation

hlp_orient_up[hlp_orient_up.count].rotation.controller = Orientation_Constraint ()
hlp_orient_up[hlp_orient_up.count].rotation.controller.appendTarget ctr_up 50

hlp_orient[1].rotation.controller = Orientation_Constraint ()
hlp_orient[1].rotation.controller.constraints.appendTarget ctr_dw 50

-- aligner les controlleurs bézier
in coordsys parent hlp_spline[3].position =  [0,0,(ecart/3)*-1] 
in coordsys parent hlp_spline[2].position =  [0,0,(ecart/3)] 

-- parenté des controlleurs bézier
hlp_spline[3].parent = ctr_up
hlp_spline[2].parent = ctr_dw

