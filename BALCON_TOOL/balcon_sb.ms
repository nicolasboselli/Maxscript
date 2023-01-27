
/*


maj:
au lieu de créer des spline, récupérer les objets depuis un selection ou le project manager
prob: taper des faces qui sont supperposés dans un même objet
*/




-- créer des surfaces plannes et bien orientées sur lesquelles travailler
	-- duppliquer la selection
	-- collecter les face orientées vers le haut
	-- supprimer les autres Faces
	-- detacher les objets par elements et groupes de Vertex

-- travailler les impacts sur chaque objet
s = $
shift = 50
rayCount = 0
impactCount = 0
for xval = s.min.x to s.max.x by shift do
(
	
	for yval = s.min.y to s.max.y by shift do
	(
		rayCount += 1
		oneRay = ray  (point3 xval yval 1000) (point3 0 0 -1)
		res = intersectRay s oneRay
		if res != undefined then
		(
			point pos: res.position
			format "res: %\n" res
			impactCount += 1
		)
		
-- 		format "ray: % pos: %\n" rayCount (point3 xval yval 1000)
	)
)	
format "impactCount :%\n" impactCount
format "rayCount: %\n" rayCount


-- pour l'amenagement
	-- decouper les surface en carré de 4m²
	-- trouver les angles de la suface



