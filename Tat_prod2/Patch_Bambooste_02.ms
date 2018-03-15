-- renommage RIG001 to LO
rigToLO = for o in objects where matchPattern o.name pattern: "*_RIG001" collect o 
for o in rigToLo do  o.name = substitutestring o.name "RIG001" "LO"
select rigToLO

 
-- renommage des bones
bonesAr = for o in objects where classof o == BoneGeometry collect o 
select bonesAr
for b in bonesAr do 
(
	
	newname = substitutestring b.parent.name "_MDL" "_EndBone_RIG"
	format "bone: %, parent: %, newname: %\n" b.name b.parent.name newname
	b.name = newname
)
-- renommage du path et record
-- record rig et ctrl

-- ajout de try()catch() sur les floatscript des percent des pathdeform des spline
splineAr = for o in objects where matchpattern o.name pattern: "A_*_Part*_Rail_Spline_01_RIG" collect o
select splineAr

undo on
(
	for s in selection  do
	(
		oldStr = s.modifiers["Path Deform Binding"].Percent_along_path.controller.script
		
		s.modifiers["Path Deform Binding"].Percent_along_path.controller = bezier_float()
-- 		if matchPattern s.name pattern:"*try" == false then
-- 		(
-- 			newStr = "Try(\n" + oldStr + "\n)\ncatch(100.0)"
-- 			s.modifiers["Path Deform Binding"].Percent_along_path.controller.script = newStr
-- 			format "Patched: %\n" s.name
-- 		)
	)
)



-- modif structure : remplacement path control par une bete parentée

point_struc =  $*FailleStructure*_Struct_Ext*  as array
select point_struc

for p in point_struc do
(
	if classof p[3][1].controller == path_constraint do
	(
		splinepath = p[3][1].controller.path 
		
		if splinepath != undefined do
		(
			newname = substitutestring splinepath.name "_Struct_Spline_Centre_RIG" "_Bamb_MDL"
			futurparent = getnodebyname newname
			
			if futurparent != undefined do
			(
				print futurparent
				tm = p.transform 
				p[3][1].controller = position_xyz()
				p.Parent =  futurparent
				p.transform  = tm
				
				--delete splinepath
			)
			
		)
	)
)





-- AJOUT de TURNTOPOLY et de XFORM
splineToPoly = #()
for o in objects do
(
	if classof o.baseobject == SplineShape and matchpattern  o.name pattern: "*_MDL" then
	(
		turnOk = false
		for m in o.modifiers do
		(
			if classof m == turn_to_poly then turnOk = true
		)
		if turnOk then format "Ok: %\n" o.name
		else if not turnOk then
		(
			format "NOT Ok: %\n" o.name
			append  splineToPoly o
		)
		else(print "Fail")
	)
)
select splineToPoly

-- for s in selection do
-- (
-- 	for m in s.modifiers where classof m == Point_CacheSpacewarpModifier  do deletemodifier s m
-- 	addmodifier s (turn_to_poly ()) before: 1
-- )



-- for s in selection do   -------------------------------------------------------------------------------------------------------------------------------------
-- (
-- 	xformPresent = false
-- 	for m in s.modifiers where classof m == xform do xformPresent = true
-- 	
-- 	if xformPresent == false then addmodifier s (xform ())
-- )
for s in selection do  ----------------------------------------------------------- rename MDL en PLOT
(
	s.name = substituteString s.name "_MDL" "_PLOT"
)

-- collecte bambous
bambPat = "A_*_Part*_Bamb_MDL"
bambAr = for o in objects where matchpattern o.name pattern: bambPat collect o
select bambAr
-- add xForm and pointCach -----------------------------------------------------------------------------------------------------------------------------------------------
for obj in (selection as array) do (
	
	addmodifier obj (xForm())
	addmodifier obj (Point_CacheSpacewarpModifier())
)

/*
freezeTransform sur ROOT
pt. *_Parent_CTRL
link _CTRL à pt. *_Parent_CTRL
*/




-- application du même multimaterial à tous les bambous
-- clean des materiaux
for i = 1 to scenematerials.count do  meditmaterials[i] = scenematerials[i]

-- COMPENSER LE DECALAGE DU TWIST
-- freeze transform twist

-- pour chaque bambou, collecter les morceaux de la section
fn findSelSet s =
(
	local selSet
	selSet = #()
-- 	s = $
	nameAr = filterString  s.name "_"
	mdlPat = "*_" +nameAr[3]+ "_" + nameAr[4] + "_Bambou_*_MDL"
	rigPat = "*_" +nameAr[3]+ "_" + nameAr[4] + "_Spline_*_RIG"

	for o in objects do
	(
		mdlRes = matchpattern o.name pattern:mdlPat
		rigRes = matchpattern o.name pattern:rigPat
		if mdlRes or rigRes then append selSet o
	)
	selSet
)

-- patcher une section
fn freezeTwist sel =
(
	-- patch y rotation sur spline01, spline02, Bambou01, bambou02
	for s in sel do
	(
		test = s.rotation.controller.y_rotation.controller.GetValue "CtrlTrem" asobject: true 
		CtrlTremDec = radTodeg test.value
		s.rotation.controller.y_rotation.controller.AddConstant "CtrlTremDec" CtrlTremDec
		s.rotation.controller.y_rotation.controller.script = "degtorad (CtrlTrem +  CtrlTremDec)" 
		format "y rotation patched: %\n" s.name
	)
	
	-- patch twist angle
	s = sel[1]
	Ctrl1 = s.modifiers["twist"].angle.controller.GetValue "CtrlTrem" asobject: true
	CtrlTremDec = radTodeg ctrl1.value

	Ctrl2 = s.modifiers["twist"].angle.controller.GetValue "CtrlDep" asobject: true
	CtrlDepDec = radTodeg Ctrl2.value

	s.modifiers["twist"].angle.controller.AddConstant "CtrlTremDec" CtrlTremDec
	s.modifiers["twist"].angle.controller.AddConstant "CtrlDepDec" CtrlDepDec
	s.modifiers["twist"].angle.controller.script = "- (CtrlTrem + CtrlTremDec) + (CtrlDep + CtrlDepDec)"
	
	format "twist patched: %\n" s.name
	
)

-- collecter les section de rails
railBambouAr = for o in objects where matchpattern o.name pattern: "A_*_Part*_Rail_Bambou_01_MDL" collect o
	
-- traitement
for s in railBambouAr do 
(
	oneSection = findSelSet s
	freezeTwist oneSection
)



-- CREATION DE CTRLS SUR LA SPLINE
fn CreateCtrlsOnSpline oneLine = 
(
	local pointCreated
	pointCreated = #()
-- 	oneLine = $
	splineCount = numSplines oneLine

	for i = 1 to splineCount do
	(
		knotsCount = numKnots oneLine i
		for k = 1 to knotsCount do
		(
			newSuf = "_" + (k as string) + "_CTRL"
			ptName = substitutestring oneLine.name "_RIG" newSuf
			pos = getKnotPoint oneLine i k
			format "spline: %, knot:%, pos: %\n" i k pos
			pt = point pos: pos axistripod: false cross: false box: true center: false \
			name: ptName wirecolor: (color 224 86 86) size: 150
			append pointCreated pt
		)
	)
	pointCreated
)

oneline = $
pathCtrls = CreateCtrlsOnSpline oneline
select pathCtrls

-- skinspline
sm = skin ()
addmodifier oneLine sm before: 1
modPanel.setCurrentObject sm
for p in pathCtrls do skinOps.addbone sm p 0

collapseStack $
for s in selection do  maxOps.CollapseNodeTo s 1 off


-- reparent twist
sel = selection as array
for s in sel do
(
	parentName = substitutestring s.name "02_CTRL" "Path_02_RIG"
	print parentName
	oneParent = getNodeByname parentName
	print oneParent
	s.parent = oneParent
)

