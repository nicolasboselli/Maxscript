sel = $

ctrTemp =  Star radius1:3.5 radius2:4 fillet1:0 fillet2:0 numPoints:12 distort:0 \
rotation: sel.rotation position: sel.position \
wirecolor:  sel.wirecolor name: (uniquename "relais")

ctrTemp  = converttosplineshape ctrTemp
updateshape ctrTemp

sel.children[1].parent = ctrTemp

	-- création d'un helper à la position et la rotation du porteur
ctrTempHlp = point size: 3  axistripod: false box: true cross: true \
rotation: sel.rotation position: sel.position \
wirecolor:  sel.wirecolor parent: sel name: "tata"

select ctrTemp

-- CREATION DE LA PARENTE MULTIPLE
ctrTemp.position.controller = position_constraint ()
ctrTemp.rotation.controller = orientation_constraint ()

				
-- ajout du helper dans les controller constraint
ctrTemp.position.controller.appendtarget sel.children[1] 100
ctrTemp.rotation.controller.appendtarget  sel.children[1]  100

-- rendre les controleurs de poids animable
loop_count = ctrTemp.position.controller.weight.count
ctrTemp.position.controller.weight[loop_count].controller = bezier_float ()
ctrTemp.rotation.controller.weight[loop_count].controller = bezier_float ()

ctrTemp = undefined
ctrTempHlp = undefined

