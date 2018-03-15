
-- PREPARATION DE LA SPLINE
s = $
animatevertex s #all
num_spline_s = numsplines s

num_knots = numknots s
num_knots_s = for i = 1 to num_spline_s collect numknots s i


-- CREATION SPLINESHAPE AVEC  LES SPLINES SEPAREES


---- collecte spline apres spline
source_s = #()
pas = 0
for a = 1 to num_spline_s do
(
test = for i = (1+(pas*3))  to ((num_knots_s[a]+pas)*3) collect s[4][8][i].value
append source_s test
pas += num_knots_s[a]
)

---- creation des splines l'une aprés l'autre dans la même shape

s3 = splineshape ()

for a = 1 to num_spline_s do
(
b = addnewspline s3 
for i = 1 to num_knots_s[b] do 
(
addknot s3 b #beziercorner #curve source_s[b][i*3 - 1] source_s[b][i*3 - 2] source_s[b][i*3]
)
updateshape s3
)




-- CREATION SPLINESHAPE AVEC TTES LES SPLINES A LA SUITE

---- collecte des positions des knots
knots_pos = for i = 1 to (num_knots*3) collect s[4][8][i].value
knots_pos.count

---- création des spline à la suite
s4 = splineshape ()
addnewspline s4
for i = 1 to num_knots do addknot s4 1 #beziercorner #curve knots_pos[i*3 - 1] knots_pos[i*3 - 2] knots_pos[i*3]
updateshape s4




for o in source_s do print o
source_s[2][1]

/*
--increment
pas = 0
pas += 1
*/
