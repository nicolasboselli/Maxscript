--AJOUT DE CONTROLLER KNOT
-- AJOUT DE KNOT
-- amelioration:
-- numeroter les controleur supplementaire en fonctio  de leur place sur la spline et nom de leur date creation
-- linker les helpers au controleurs spline par des contraintes scripter
-- reprendre la couleur de la spline


-- recuperation de la selection
s = $ 
seg_refine_array = getSegSelection s 1
seg_refine = seg_refine_array[1]


-- precaution pour le test
if s.parent == undefined then
(
hlp_spline_pos = point rotation: s.rotation pos: s.pos -- creation du parent de la spline
s.parent = hlp_spline_pos -- parenté de la spline
animatevertex s #all
updateshape s
knot_num = numknots s
for i = 1 to (knot_num*3) do s[4][8][i].controller = point3_script ()
)
hlp_spline_pos = s.parent
-- collecte du nombre de knots
knot_num = numknots s

-- collecte des controleurs de vertex
vertex_ctr = for i = 1 to (knot_num*3) collect s[4][8][i].controller

-- nettoyage de la spline, destruction des controleurs
addmodifier s (Edit_Spline())
convertto s SplineShape

-- ajout d'un knot et collecte du numero du knot
knot_plus = refinesegment s 1 seg_refine 0.5
updateshape s

-- collecte du nombre de knots
knot_max = numknots s

-- creation des controller
knot_num = numknots s
for i = 1 to (knot_num*3) do animatevertex s i	

-- collage des controllers collecté précédemment
for i = 1 to (knot_plus*3 - 3) do
s[4][8][i].controller = vertex_ctr[i]

for i = (knot_plus*3+1) to (knot_max*3) do
s[4][8][i].controller = vertex_ctr[i-3]
updateshape s
	

--CREATION DES HELPERS
hlp_ctr_mid = 			point name: (uniquename "hlp_ctr_mid") radius:10 pos: (getKnotPoint s 1 knot_plus)
hlp_ctr_mid_in = 		point name: (uniquename "hlp_ctr_mid") radius:10 pos: (getinvec s 1 knot_plus)
hlp_ctr_mid_out = 	point name: (uniquename "hlp_ctr_mid") radius:10 pos: (getoutvec s 1 knot_plus)

-- parenté des helpers
hlp_ctr_mid_in.parent = hlp_ctr_mid
hlp_ctr_mid_out.parent = hlp_ctr_mid

ctr_knot = #(hlp_ctr_mid_in, hlp_ctr_mid, hlp_ctr_mid_out)


-- contraintes des knots aux helpers
-- contrainte en position du knot et des vecteurs
for i = 1 to 3 do
(
s[4][8][(knot_plus*3 - 3 + i)].controller = point3_script ()
s[4][8][(knot_plus*3 - 3 + i)].addconstant "hlp_ctr_mid" ctr_knot[i]
s[4][8][(knot_plus*3 - 3 + i)].addconstant "hlp_spline_pos" hlp_spline_pos
s[4][8][(knot_plus*3 - 3 + i)].script = "in coordsys hlp_spline_pos hlp_ctr_mid.pos"
)


-- creation des helpers spline pour vecteurs
ctr_mid = circle name: (uniquename "ctr_mid") radius:10 rotation: hlp_ctr_mid.rotation  pos: hlp_ctr_mid.pos 

ctr_mid_in = circle name: (uniquename "ctr_mid_in") radius: 5 rotation: ctr_mid.rotation  pos: ctr_mid.pos parent: ctr_mid
ctr_mid_in.pos.controller.x_position.controller = float_script ()
ctr_mid_in.pos.controller.y_position.controller = float_script ()
in coordsys parent ctr_mid_in.pos.z = 100
hlp_ctr_mid_in.parent = world

ctr_mid_out = circle name: (uniquename "ctr_mid_out") radius:5 rotation: ctr_mid.rotation  pos: ctr_mid.pos parent: ctr_mid
ctr_mid_out.pos.controller.x_position.controller = float_script ()
ctr_mid_out.pos.controller.y_position.controller = float_script ()
in coordsys parent ctr_mid_out.pos.z = -100
hlp_ctr_mid_out.parent = world

ctr_knot2 = #(ctr_mid_in, ctr_mid, ctr_mid_out)

for i = 1 to 3 do 
(
ctr_knot[i].pos.controller = Position_Constraint ()
ctr_knot[i].pos.controller.constraints.appendTarget ctr_knot2[i] 50
)
-- alignement des helpers spline vecteurs sur le helpers du knot
-- contrainte parent des helpers spline de vecteurs au helper spline du knot
-- contraindre les helpers vecteurs dans une seule direction
-- contraindre les helpers aux helpers spline
