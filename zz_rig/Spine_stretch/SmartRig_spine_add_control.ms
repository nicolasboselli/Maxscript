--AJOUT DE CONTROLLER KNOT
-- dans ce script il y a 
---- des array de bones pour le skin, 
---- des arrays de numeros de bones pour le skin, 
---- des array de vertices pour le skin, 
---- des arrays de helpers pour le replacement de la spline, 
---- des arrays de knots pour le replacement de la spline
-- et tout ça se croise


-- recuperation de la selection
s = $ 
subobjectLevel = 0
select s

old_bones_set = #()
old_vertices_set = #()

-- collecte des bones du skin
bones_num = skinOps.GetNumberBones s.modifiers[#skin] 
bones_names_string = for i = 1 to bones_num collect skinOps.GetBoneName s.modifiers[#skin] i 1
old_bones_set =for o in bones_names_string collect getnodebyname o
	
old_bones_num_set = for i = 1 to bones_num collect i

-- collecte des vertex de la spline 
vertices_num = skinOps.GetNumberVertices s.modifiers[#skin]
old_vertices_set = for i = 1 to vertices_num collect i

-- ajout d'un edit spline
addmodifier s (Edit_Spline())
	
-- ecrasement de la spline
convertto s SplineShape	
updateshape s
subobjectLevel = 2
	
-- ajout d'un nouveau vertex
seg_refine_array = getSegSelection s 1
seg_refine = seg_refine_array[1]
knot_plus = refinesegment s 1 seg_refine 0.5
setKnotType s 1 knot_plus #beziercorner
updateshape s

-- créer un array avec les numeros des trois points créés
new_vertices= #((knot_plus*3 - 2), (knot_plus*3 - 1), (knot_plus*3))
-- selection  de la spline
subobjectLevel = 0
select s	

-- créer des helpers pour les nouveaux knots
hlp_ctr_mid_in = 	point name: (uniquename "hlp_ctr_mid")  pos: (getinvec s 1 knot_plus) size: (units.decodeValue "4cm") box: true cross: true  axistripod: false wirecolor: yellow
hlp_ctr_mid = 	point name: (uniquename "hlp_ctr_mid")  pos: (getKnotPoint s 1 knot_plus) size: (units.decodeValue "4cm") box: true cross: true  axistripod: false wirecolor: yellow
hlp_ctr_mid_out = point name: (uniquename "hlp_ctr_mid") pos: (getoutvec s 1 knot_plus) size: (units.decodeValue "4cm") box: true cross: true  axistripod: false wirecolor: yellow

-- parenté des helpers
hlp_ctr_mid_in.parent = hlp_ctr_mid
hlp_ctr_mid_out.parent = hlp_ctr_mid

new_bones = #(hlp_ctr_mid_in, hlp_ctr_mid, hlp_ctr_mid_out)

-- creation des controleurs

ctr_mid = circle radius: (units.decodeValue "20cm") pos: hlp_ctr_mid.pos name: (uniquename "ctr_mid") wirecolor: yellow

-- parenté des helpers aux controleurs
hlp_ctr_mid.parent = ctr_mid

-- collecte de numeros des nouveaux bones
new_bones_num_set = for i = 1 to new_bones.count collect i
new_bones_num_set = for o in new_bones_num_set collect o + old_bones_num_set.count

-- créer un array de tous les bones
bones_set =  old_bones_set + new_bones

old_bones_set_up = deepcopy old_bones_set

insertItem old_bones_set_up[1] old_bones_set_up 1
append old_bones_set_up old_bones_set_up[old_bones_set_up.count]
bones_set_up =  old_bones_set_up + new_bones


-- créer un array numerique des bones 
new_bones_num_set
old_bones_num_set

old_bones_num_set_up = deepcopy old_bones_num_set
insertItem old_bones_num_set_up[1] old_bones_num_set_up 1
append old_bones_num_set_up old_bones_num_set_up[old_bones_num_set_up.count]
bones_num_set = old_bones_num_set_up + new_bones_num_set

-- créer un array de tous les knots de la spline en rapport avec les bones
old_vertices_set
new_vertices
vertices_set

new_vertices_up = for o in new_vertices collect o + 3

vertices_set = old_vertices_set + new_vertices

for o in new_vertices do deleteItem vertices_set new_vertices[1]

for i = 1 to new_vertices.count do insertItem new_vertices_up[i] vertices_set new_vertices[i]

-- replacer les helpers sur les knots
----créer un array des knots
num_knots = numKnots s 1
knot_pos = #()
for i = 1 to num_knots do
( 
append knot_pos (getInVec s 1 i)
append knot_pos (getKnotPoint s 1 i)
append knot_pos (getOutVec s 1 i)
)
---- créer un array des helpers dans le sens des knots
old_bones_set
old_bones_set_up
old_helpers_set = deepcopy old_bones_set_up
new_bones
-- où commencer le replacement
gap = seg_refine*3

--- création de l'array
for i = 1 to new_bones.count do 
(
	insertItem new_bones[i] old_helpers_set (gap + i)
)

for o in old_helpers_set do print o

helpers_set = deepcopy old_helpers_set

for o in helpers_set do print o

/*
--- creation d'un array des parents des helpers
select helpers_set

helpers_parent = for o in helpers_set collect o.parent
select helpers_parent
---- replacer les helpers sur controlleurs des helpers a la position des knot (normalement les arrays sont dans le bon sens)
*/

for i = 1 to helpers_set.count do helpers_set[i].pos = knot_pos[i]

knot_pos.count

-- créer un nouveau skin
select s
modPanel.addModToSelection (Skin ()) ui:on

-- faire rentrer les helpers dans le skin
for o in bones_set do
(
skinOps.addbone s.modifiers[#skin] o 0
)


-- appliquer les influences
vertices_set
bones_set_up
select s
for i = 1 to vertices_set.count do
(
skinOps.SetVertexWeights s.modifiers[#skin] vertices_set[i] bones_num_set[i] 1
)

