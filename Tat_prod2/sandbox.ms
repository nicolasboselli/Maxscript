sel = selection as array
var = distance sel[1] sel[2]
var == 7.36318
var as double

for s in selection do 
(
	if s.showLinks then
	(
		s.boxmode = true
		s.showLinks = false
	)
	else if not s.showLinks then
	(
		s.boxmode = false
		s.showLinks = true
	)
)


$.boxmode = false

mod 9 2

curvelength $ 1

$.rotation.controller.pickUpNode 

-- $.rotation

h1 = $P_Araignee_D_PattesA_hancheIK_RIG
h2 = $P_Araignee_D_PattesA_genouIK_RIG

h1 -h2

sel = $P_Araignee_D_PattesA_*MDL*
for s in sel do print s
	
select $*001

activeSize = 2.46421
offsetSize = 3.41
curveSize = 5.87421

s = $
s
isDeleted s
s.name

sel = selection as array
for i = 2 to sel.count do
(
-- 	cop =  copy sel[1].baseobject
	sel[i].baseobject =   copy sel[1].baseobject
-- 	delete cop
)

copy $
-- selection[1].baseobject = selection[2].baseobject

-- trouver toutes les dependances d'un objet 
rd = refs.dependents $  -- immediateOnly: true
for d in rd do
(
	if classof d == point then
	(
		format "POINT: %, class:%\n" d.name (classof d)
	)
	else if classof d == Float_Script then
	(
		format "FLOAT_SCRIPT: %, class:%, ref: %\n" d (classof d) (refs.dependentNodes d)
		displayControlDialog d ((refs.dependentNodes d)as string)
	)
	else if classof d == Orientation_constraint then 
	(
		format "ORIENT_CONSTRAINT: %, class:%, ref: %\n" d (classof d) (refs.dependentNodes d)
		displayControlDialog d ((refs.dependentNodes d)as string)
	)
	else
	(
		format "d: %, class:%\n" d (classof d)
	)
)


-- remettre position et rotation a zero
sel = selection as array
for s in sel do
(
	in coordsys parent s.position = [0,0,0]
	in coordsys parent s.rotation = (quat 0 0 0 1)
	
)



sel = selection as array
sel[2].name = substitutestring sel[1].name "CTRL" "SKIN"





-- in coordsys parent $.position = [0,0,0]
-- trouver l'objet porteur d'un controlleur
ctrl = $.position.controller[2].controller.z_position.controller
refs.dependentNodes ctrl

-- afficher la boite de dialogue d'un controller
displayControlDialog ctrl ((refs.dependentNodes ctrl)as string)


select $*BaseName*

$.scale.x

select $*OrientRepli*

$.rotation.controller[2].getNode 1

select $P_Guepe_G_Eyelid_TargetRepli_RIG

highlightctrl false
highlightctrl true
-- showsource highlightctrl
exp(2)
$.scale.z

log(100)


rot = in coordsys parent $Point028Point028.rotation
rot = in coordsys $P_Matfard_D_Pied_IK2_RIG $Point028.rotation
degtorad (rot as eulerAngles).x
(eulerAngles -90 0 0) as quat

$.length = 3
$.width = 3
$.height = 10

showproperties $

$.hardedgedisplaycolor
$.highlights

0.474197