-- renommage des bones
bonesAr = for o in objects where classof o == BoneGeometry collect o 
select bonesAr
for b in bonesAr do 
(
	
	newname = substitutestring b.parent.name "_MDL" "_EndBone_RIG"
	format "bone: %, parent: %, newname: %\n" b.name b.parent.name newname
	b.name = newname
)

-- ajout de try()catch() sur les floatscript des percent des pathdeform des spline
for s in selection  do
(
	oldStr = s.modifiers["Path Deform Binding"].Percent_along_path.controller.script
	newStr = "Try(\n" + oldStr + "\n)\ncatch(100.0)"
	s.modifiers["Path Deform Binding"].Percent_along_path.controller.script = newStr
	format "Patched: %\n" s.name
)


-- Duplication des twist
for s in selection do
(
-- 	s = $
	posCtrl = copy s
	posCtrl.size = 150
	posCtrl.Wirecolor = color 224 86 86
	posCtrl.name = substitutestring s.name "CTRL" "Pos_CTRL"
)

-- compenser le decalage des twist
-- freeze transform twist

-- collecter les morceaux d'un part
s = $
nameAr = filterString  s.name "_"
onePat = "*_" +nameAr[3]+ "_" + nameAr[4] + "_*"

for o in objects do
(
	res = matchpattern o.name pattern:onePat
	if res then print o.name
)

-- patch y rotation
-- spline01, spline02, Bambou01, bambou02
sel = selection as array
for s in sel do
(
	test = s.rotation.controller.y_rotation.controller.GetValue "CtrlTrem" asobject: true 
	CtrlTremDec = radTodeg test.value
	s.rotation.controller.y_rotation.controller.AddConstant "CtrlTremDec" CtrlTremDec
	s.rotation.controller.y_rotation.controller.script = "degtorad (CtrlTrem +  CtrlTremDec)" 
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
