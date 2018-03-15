aa = 10
bb = 10

cc = $mouchard.pos
dd =$driver1.pos
ee = $driver2.pos
ff = in coordsys $driver1 $mouchard.pos
gg = in coordsys $driver2 $mouchard.pos

-- à améliorer: lorsque la condition est rempli, 
-- 1- le mouchard s'aligne sur le test et relève ses coordonnées. 
-- 2-les coordonnées deviennent une nouvelle constante qui s'ajoute à la position des driver
-- attention : si je rajoute un controller au test pour le rendre libre il faudra penser à soustraire la position libre à la position contrainte.