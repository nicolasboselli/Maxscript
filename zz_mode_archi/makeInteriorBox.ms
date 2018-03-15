-- polyop.moveVert $ #all [10,10,10]

fn roundNumber num =
(
	local roundNumStr
	num = num as float
	
	wholeNumberString = num as string
	
	wholenumbers = filterstring wholeNumberString "e"
	if wholenumbers.count ==2 then
	(
		wholeNumberString = "0.0"
-- 		roundNumStr = "0.0"
	)
	
	wholenumbers = filterstring wholeNumberString "."
	if wholenumbers.count ==2 then 
	(
		unit = wholenumbers[1]
		numberstring = wholenumbers[2]
		decimal = substring numberstring  1 3
		roundNumStr = unit + "." + decimal
	)
	
	execute roundNumStr
)


-- test = -1.21095e-007
-- test = 5.35465
-- test = 5
-- str = test as  string
-- roundNumber test



-- traitement sur la copie avant le deplacement
-- préserver certains open edge
lockedEdge = polyop.getEdgeSelection $.baseobject
-- créer la copie
interior = copy $
interior.name = $.name + "_IntBox"
select interior

-- delete open edge
openEdge = polyop.getOpenEdges interior.baseobject
edgeToDel = openEdge - lockedEdge
polyop.deleteEdges interior.baseobject edgeToDel





-- delete face horizontale
maxFaces = polyop.getNumFaces interior.baseobject
facesTodel = #()
-- count = 0
for f = 1 to maxFaces do
(
	nrl = polyop.getFaceNormal  interior f
	if  close_enough nrl.z 1 3 or close_enough nrl.z -1 3  then
	(
		append facesToDel f
-- 		count += 1
-- 		format "face: %, normale: %\n" f nrl
	)
)
-- format "faces Horizontales: % \n" count
polyop.deleteFaces interior.baseobject facesToDel

-- flip normales
max modify mode
modPanel.setCurrentObject $.baseobject
subObjectLevel = 4
polyop.flipNormals $ #all
subObjectLevel = 0

-- delete face en vis a vis
-- intersectRay <node> <ray> 
s = $
maxFaces = polyop.getNumFaces s

facesToDel = #()
for f = 1 to maxFaces do
(
	local 
	test = ray (polyop.getFaceCenter s f) (polyop.getFaceNormal  s f)
	impact = intersectRay s test
	if impact != undefined then
	(
		dist = distance test.pos impact.pos
		if dist < 30 and dist > 0 then
		(
			append facesToDel f
-- 			format "face: %, impact: %, distance: %\n" f impact dist
		)
	)
)
format "faces to del: % \n" facesToDel
polyop.deleteFaces s facesToDel

-- flip normales
max modify mode
modPanel.setCurrentObject $.baseobject
subObjectLevel = 4
polyop.flipNormals $ #all
subObjectLevel = 0

-- collect info vertex
maxVert = polyop.getNumVerts interior.baseobject
globalMoving = #()

-- for each vertex
for i = 1 to maxVert do
(
	deco = "##############"
-- 	format "\n% vertex: % %\n" deco i deco
	
	-- get face by vertex
	facBitAr = polyop.getFacesUsingVert interior #{i}	
	facAr = facBitAr as array
	
	moving = #()
	
	-- collect normal
	for f in facAr do
	(
		-- get normals
		tmp = polyop.getFaceNormal  interior f
		
		
		-- clean movement value
		xVal = roundNumber tmp.x 
		yVal = roundNumber tmp.y 
		zVal = roundNumber tmp.z 
		normalRound = [xVal, yVal, zVal]
		
		normal = normalize normalRound
		
		appendifunique moving normal
		
-- 		format "normal: % , rounded: %, normalize: %\n" tmp  normalRound normal
		
		/*
-- 		print normal.x
		normalMod = normal*-25
		
	-- clean movement value
		xVal = roundNumber normalMod.x 
		yVal = roundNumber normalMod.y 
		zVal = roundNumber normalMod.z 
		
		appendifunique moving [xVal, yVal, zVal]
		*/
		
	)
	
	
	-- compare angles
	val = -25
	angMax = 30 -- replace by angle collection with tresohld
	
	angAr = #()
	endMoving = #(moving[1]*val)
	
	for k = 1 to moving.count do
	(
		for j = 1 to moving.count do
		(
			if j > k then
			(
-- 				print "youpi"
				ang = acos (dot moving[k]  moving[j]) 
-- 				format "n%:%, n%:%, angle:%\n" k  moving[k] j moving[j] ang
				if ang> angMax then
				(
					ang = acos (dot moving[1]  moving[j]) 
					if ang> angMax then appendifunique endMoving (moving[j]*val)
				)
-- 				if ang < 15.0 then append angAr ang 
			)
		)
	)
	
	-- collect first
	-- if in follower angle > 15 then test with first
		-- collect angle
		-- if angle > 15  and different from collected angle treshold collect folower 
	

-- 	format "vert: %, endMoving: %\n" i endMoving

	
	append globalMoving endMoving
)
-- globalMoving
-- globalMoving

-- move vertex

for i = 1 to globalMoving.count do
(
	for mov in globalMoving[i] do polyop.moveVert interior #{i} mov
)


-- flip normales
max modify mode
modPanel.setCurrentObject $.baseobject
subObjectLevel = 4
polyop.flipNormals $ #all
subObjectLevel = 0





