-- CREATION DES CONTROLLEURS DE SPLINE

--creation de la variable spline
ligne = $

--creation du helper de la spline
hlp_spline_pos = point  rotation: ligne.rotation pos: ligne.pos
ligne.parent = hlp_spline_pos

-- recuperation des numeros de knots important
knots = numKnots ligne
knots_max = knots * 3

-- creation de l'array des knots important
nb_array = #(2, 3 )

append nb_array (knots_max - 2)
append nb_array (knots_max - 1)
makeUniqueArray nb_array


-- creation de controller d'animations script sur les knots controlleur
for o in nb_array do 
(
animatevertex ligne o
ligne[4][8][o].controller = point3_script ()
)

-- recuperation des positions des knots controlleurs
pos1 = getknotpoint ligne 1 1
pos2 = getoutvec ligne 1 1
pos3 = getinvec ligne 1 knots
pos4 = getknotpoint ligne 1 knots

-- creation de l'array des positions de knots controlleur
pos_array = #(pos1, pos2, pos3, pos4)

-- creation des helpers de positions pour les knots controlleurs
hlp_spline = for o in pos_array collect point pos: o
for o in hlp_spline do o.parent = hlp_spline_pos
hlp_spline[2].parent  =  hlp_spline[1]
hlp_spline[3].parent  = hlp_spline[4]

-- creation des controlleurs script sur les  knots controlleurs à partir des helpers de positions
for i= 1 to nb_array.count do
(
ligne[4][8][nb_array[i]].addconstant "hlp_spline_pos" hlp_spline_pos
ligne[4][8][nb_array[i]].addconstant "hlp_pos" hlp_spline[i]
ligne[4][8][nb_array[i]].script = "in coordsys hlp_spline_pos hlp_pos.pos"
)

