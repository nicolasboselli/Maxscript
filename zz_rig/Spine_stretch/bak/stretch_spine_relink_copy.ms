-- strech_spine after copy

-- avant la copy, récupérer les noms de tous les controller de knot
s = $
num_knots = numknots s
knots_ctr = for i = 1 to (num_knots * 3) collect copy s[4][8][i].controller
	

-- faire la copy
-- aprés la copy relinker tous les knots avec leur controller initiaux.

s= $ 
num_knots = numknots s
for i = 1 to (num_knots * 3) do s[4][8][i].controller = bezier_point3 ()	
for i = 1 to (num_knots * 3) do s[4][8][i].controller = knots_ctr[i]
