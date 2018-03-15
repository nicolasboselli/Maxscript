-- create point on knot spline
pointCreated = #()
oneLine = $
splineCount = numSplines oneLine

for i = 1 to splineCount do
(
	knotsCount = numKnots oneLine i
	for k = 1 to knotsCount do
	(
		-- ctrl pôur knot
		newSuf = "_" + (k as string) + "_RIG"
		ptName = substitutestring oneLine.name "_RIG" newSuf
		
		pos = getKnotPoint oneLine i k
		format "spline: %, knot:%, pos: %\n" i k pos
		
		pt = point pos: pos axistripod: false cross: false box: true center: false \
		name: ptName wirecolor: green size: ((curvelength oneline i)*0.1)
		append pointCreated pt
		
		-- ctrl pour tangent in 
		newSuf = "_" + (k as string) + "_TangentIn_RIG"
		ptName = substitutestring oneLine.name "_RIG" newSuf
		
		pos = getInVec oneLine i k
		format "spline: %, knotIn:%, pos: %\n" i k pos

		pt = point pos: pos axistripod: false cross: false box: true center: false \
		name: ptName wirecolor: green size: ((curvelength oneline i)*0.05)
		append pointCreated pt
		
		-- ctrl pour tangent out 
		newSuf = "_" + (k as string) + "_TangentOut_RIG"
		ptName = substitutestring oneLine.name "_RIG" newSuf
		
		pos = getOutVec oneLine i k
		format "spline: %, knotOut:%, pos: %\n" i k pos

		pt = point pos: pos axistripod: false cross: false box: true center: false \
		name: ptName wirecolor: green size: ((curvelength oneline i)*0.05)
		append pointCreated pt
		
	)
)
select pointCreated


-- create points on knot selected
pointCreated = #()
oneLine = $
splineCount = numSplines oneLine

for i = 1 to splineCount do
(	
	knotsAr = getKnotSelection oneLine i
	print knotsAr
	
	for k in knotsAr do
	(
		newSuf = "_" + (k as string) + "_RIG"
		ptName = substitutestring oneLine.name "_RIG" newSuf
		pos = getKnotPoint oneLine i k
		format "spline: %, knot:%, pos: %\n" i k pos
		pt = point pos: pos axistripod: false cross: false box: true center: false \
		name: ptName wirecolor: green size: 1
		append pointCreated pt
	)
	
)
select pointCreated

-- skinspline
sm = skin ()
addmodifier oneLine sm
modPanel.setCurrentObject sm
for p in pointCreated do skinOps.addbone sm p 0

sk = $.modifiers["skin"]

-- pos = getKnotPoint $ 1 1

skinOps.SelectVertices sk 3

-- create point beetween two points
fn returnSearch s =
(
	local search
	if matchpattern sel[1].name pattern: "*_RIG" then  search = "_RIG"
	else if matchpattern sel[1].name pattern: "*_MDL" then  search = "_MDL"
	else if matchpattern sel[1].name pattern: "*_CTRL" then  search = "_CTRL"
	else if matchpattern sel[1].name pattern: "*_PLOT" then  search = "_PLOT"
	else("search introuvable")
	search
)

-- create first point
fn addFirstLookAtPoint sel =
(
	local pt
	search = returnSearch sel[1]

	ptName = substitutestring sel[1].name search "_LookAt_RIG"
	pt = point box: false axistripod: true cross: false wirecolor: green name: ptName size: 5

	-- postion constraint
	posConstraint = Position_Constraint ()
	for s in sel do posConstraint.appendTarget s 50
	pt.position.controller = position_list ()
	pt.position.controller.available.controller = posConstraint

	-- look at 
	rotConstraint = lookat_constraint ()
	rotConstraint.appendtarget sel[1] 50
	pt.rotation.controller = rotation_list ()
	pt.rotation.controller.available.controller = rotConstraint

	rotConstraint.pickupnode =  sel[1]
	rotConstraint.upnode_world = false
	rotConstraint.StoUP_axis = 1
	rotConstraint.StoUP_axisFlip = false
	rotConstraint.upnode_axis = 1
	rotConstraint.viewline_length_abs = false
	
	pt 
)


sel = undefined
sel = for s in selection collect s 
pt = addFirstLookAtPoint sel


--  add second point
pt2 = copy pt
pt2.rotation.controller.lookat_constraint.controller.pickupnode = sel[2]

select $.rotation.controller.pickupnode

search2 = returnSearch sel[2]
pt2Name = substitutestring sel[2].name search2 "_LookAt_RIG"
pt2.name = pt2Name

-- add inter
inter = point box: true axistripod: false cross: true wirecolor: red size: 5
posConstraint = Position_Constraint ()
posConstraint.appendTarget pt 50
posConstraint.appendTarget pt2 50
inter.position.controller = position_list ()
inter.position.controller.available.controller = posConstraint

rotOrient = orientation_Constraint()
rotOrient.appendTarget pt 50
rotOrient.appendTarget pt2 50
inter.rotation.controller = rotation_list ()
inter.rotation.controller.available.controller = rotOrient



-- scale contraint by distance beetweentwo point
sel = selection as array
-- ajout du script scale
pt1 = sel[1]
pt2 = sel[2]
tgt = sel[3]

tgt.scale.controller = scale_script ()

-- ajout des point node
tgt.scale.controller.addnode  "pt1" pt1
tgt.scale.controller.addnode  "pt2" pt2

-- ajout de la constante size
tgt.scale.controller.addConstant "size" (distance pt1 pt2)

-- ecriture du script
tgt.scale.controller.SetExpression "varsize = distance pt1 pt2
scale = varsize / size 
[scale, 1, 1]"

-- update size value
pt1 = $.scale.controller.getnode "pt1"
pt2 = $.scale.controller.getnode "pt2"

size = distance pt1 pt2

$.scale.controller.SetConstant  "size" size
move pt1 [0,0,1]
move pt1 [0,0,-1]

--
selection[2].name = substitutestring selection[1].name "CTRL" "RIG"

distance selection[1] selection[2]


-- add ctrl
addmodifier $ (EmptyModifier name: "CTRL")

-- orient
sel = selection as array
N1 = sel[1].transform.row1
N2 = sel[2].transform.row1
acos (dot N1 N2) 



in coordsys $FFD008_pTM002_pTM002 $FFD008_pTM002_pTM001.rotation.y
	

-- 
$.rotation.controller[2].controller.getNode 1
$.rotation.controller[2].controller.getNode 2

