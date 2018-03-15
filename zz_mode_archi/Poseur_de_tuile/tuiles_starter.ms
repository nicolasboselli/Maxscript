$.editablePoly.getselection #face

-- recuperation de la selection d'edge a partir de la face
$.EditablePoly.ConvertSelectionToBorder #Face #Edge
$.EditablePoly.ConvertSelectionToBorder #Face #vertex
edgeBorder = ((polyop.getEdgeSelection $) as array)
redrawviews ()

--edgeBorder = ((polyop.getVertSelection $) as array)

vertexDuo = for o in edgeBorder collect ((polyop.getVertsUsingEdge $ #{o}) as array)

-- classement de l'array d'edge dans le sens des aiguilles d'une montre
--pas = 0
v1 = 23
v2 = 37


fn EdgePosArray v1 v2 =
(	
	--vars
	local test 
	local dep = ((polyop.getVertsUsingEdge $ #{v1} * polyop.getVertsUsingEdge $ #{v2}) as array).count
	--pas +=1
	-- if test == 1 then dd = 1 else dd = -1
	print ""
	print (edgeBorder as string)
	
	test = case of
	(
		(dep == 1 ): 0
		(dep == 0 ): 1
		default: 0
	)
	-- print test
	print (" v1:" + (v1 as string) + " - v2:" + (v2 as string) +  " - deplacement:" + (dep as string) + " - test:" + (test as string) )
	--print (edgeBorder as string)
	print ""
	test
)
 
 qsort  edgeBorder EdgePosArray
 edgeBorder

randomNum = for i = 1  to 10 collect (random 1 100)


findItem randomNum 38
 
 
 

 
 
 edgeBorder = 
 goodArray = #(5, 6 , 15, 23, 37, 7, 8, 16, 34, 24) 
 
 fn EdgePosArray2 v1 v2 =
 (
	 local dd
	 local test = (((v1 as bitarray) * (v2 as bitarray)) as array).count
	 if test == 1 then dd = 1 else dd = -1
		 
	case of
	(
		(dd == 1 ):1
		(dd != 1 ):-1
		default: 0
	)
 )
 
  qsort  vertexDuo EdgePosArray2
 
 -- verif edgeBorder
 pas = 1
  
 i = pas
 polyop.setEdgeSelection $ #{edgeBorder[i]}
 redrawviews ()
 pas += 1
 
 
for v1 in edgeBorder collect
(
	for v2 in edgeBorder collect
	(
		EdgePosArray v1 v2
	)
)

 
for a in vertexDuo collect
(
	for b in vertexDuo collect
	(
		(((a as bitarray) * (b as bitarray)) as array).count
	)

 )

 (
	-- classement array
	fn ySort v1 v2 =
	(
		local dd
		if(v1.y < v2.y) then
			dd=-1
		else
			dd=1
		
	--compare les numeros entre eux et les classe	
		case of
		(
			(dd < 0.):1
			(dd > 0.):-1
			default: 0
		)
	)
 
 
-- recup des vecteurs des edges
vertexVectors = for o in vertexDuo collect  
(
normalize (($.editablePoly.getvertex  o[1]) - ($.editablePoly.getvertex  o[2]))
)


-- comparaison des vecteurs par angle

for i = 1 to (vertexDuo.count - 1) collect
(
acos (dot vertexVectors[i]  vertexVectors[i+1]) 
)

-- recup des deux vecteurs parallèle


polyop.getFaceCenter <Poly poly> <int face> node:<node=unsupplied>

polyop.getFaceNormal <Poly poly> <int face> node:<node=unsupplied>

polyop.getFaceArea <Poly poly> <int face>

*/