-- AJOUT DE KNOT

s = $ -- recuperation de la spline
if s.parent == undefined then
(
hlp_spline_pos = point pos: s.pos -- creation du parent de la spline
s.parent = hlp_spline_pos -- parenté de la spline
)

-- collecte du nombre de knots
knot_num = numknots s

-- creation de controller test
/*
animatevertex s #all
updateshape s
for i = 1 to (knot_num*3) do s[4][8][i].controller = point3_script ()
*/

-- collecte des controleurs de vertex
vertex_ctr = for i = 1 to (knot_num*3) collect s[4][8][i].controller

-- nettoyage de la spline, destruction des controleurs
addmodifier s (Edit_Spline())
convertto s SplineShape

-- ajout d'un knot et collecte du numero du knot
knot_plus = refinesegment s 1 1 0.5
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
	
/*
for i = 1 to vertex_ctr.count do
s2[4][8][i].controller = copy s[4][8][i].controller
*/
/*
animatevertex s (knot_num*3 - 1)
updateshape s

animatevertex s #all

s = $
nbk = numknots s 1


addNewSpline s
for i = 1 to nbk do 
addKnot s 2 #bezier #curve (getKnotPoint s 1 i) (getinvec s 1 i) (getoutvec s 1 i) 
updateshape s

b2.pos.controller = copy b1.pos.controller

*/