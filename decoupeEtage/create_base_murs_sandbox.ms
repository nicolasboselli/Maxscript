-- sur une selection de cellule

fn createWall =
(
	-- faire des copies
	sel = selection as array
	maxOps.cloneNodes sel cloneType: #copy newNodes: &wallSplines
	select wallSplines

	-- supprimer les modifiers 
	for w in wallSplines do
	(
		count = w.modifiers.count
		if count > 0 then 
		(
			for i = count to 1 by - 1 do deletemodifier w 1
		)
	)

	-- convertion de tout ce qui n'est pas line ou spline shape
	for w in wallSplines where classof w == rectangle do converttosplineshape w
		
	-- merger toutes les splines dans le meme objet
	-- converttosplineshape wallSplines[1] 
	for i = 2 to wallSplines.count do
	(
	-- 	converttosplineshape wallSplines[i] 
		addAndWeld wallSplines[1] wallSplines[i] 0.1
	)

	-- deselection de tous les segments
	spCount = numsplines wallSplines[1] 
	for sp = 1 to spCount do
	(
	-- 	segCount = numSegments s sp
		setSegSelection wallSplines[1]  sp #()
	)

	updateshape wallSplines[1]

	-- ajout d'un sweep
	addmodifier wallSplines[1] (sweep PivotAlignment:3 length: 250 width: 25)
	wallSplines[1].sweep.PivotAlignment = 3
	wallSplines[1].sweep.CurrentBuiltInShape = 2
	wallSplines[1].sweep[#Bar_Section].length = 250
	wallSplines[1].sweep[#Bar_Section].width = 25
	wallSplines[1].sweep.SmoothPath = off

	-- renommage
	wallSplines[1].name = uniquename "wall_" 

	select wallSplines[1]
)

-- createWall()