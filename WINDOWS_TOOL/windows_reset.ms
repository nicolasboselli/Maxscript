/*
reperer les fenetres inversées 
desinstance
remettre la rotation à zero
exploser le Groupe 
memoriser les parents
ResetXForm
refaire les parents
refaire le Groupe 
reprendre la rotation d'origine
*/

-- 	function UI dependant
fn findWindows oneArray = 
(
	windowsSet = #()
	for h in oneArray where iskindof h dummy and isgrouphead h do 
	(
		local res
		try(res = (getUserProp h "windowsTemplate")as booleanClass)catch(res = false)
		if res then append windowsSet h
	)
	windowsSet
)

-- hlps = findWindows helpers
global newH
hlps = findWindows (selection as array)

for h in hlps where h.scale.y < 0 do
(
	format "h.name: % h.scale: %\n" h.name h.scale.y
	
	bakTM = h.transform
	
	-- ramene la fenetre au centre du monde flippée en y
	h.transform = scalematrix (point3 1 -1 1)
	
	-- traitement des objets
 	objs = #()
	parents = #()

	hMembers = #(h)
	for dad in hMembers do 
	(
		for c in dad.children do append hMembers c
	)
	format "hMembers: %\n" hMembers
	
	explodeGroup h
		
	for h in hMembers where isvalidnode h do 
	(
		format "h: % parent: %\n" h h.parent
		append objs h
		append parents h.parent
	)

	for o in objs do o.parent = undefined 

	for o in objs do resetxform o
	
	for i = 1 to objs.count do objs[i].parent = parents[i]
	
	newH = group objs
	
	-- tagger comme fenetre
	setUserProp newH "windowsTemplate" "true"
	select newH
	setGroupOpen newH true
	setGroupOpen newH false
	-- replacer le pivot en bas à gauche
	bbVal = nodeGetBoundingBox newH newH.transform
	format "bbVal: %\n" bbVal
	newH.pivot = ( transMatrix(point3 (bbVal[2].x) (bbVal[2].y) (bbVal[1].z)) * newH.transform).translation
	-- inversion de la valeur du pivot fenetre
	
	newH.transform = scalematrix (point3 1 -1 1) * bakTM 
	
	
)


-- $.transform = scalematrix (point3 1 -1 1)
/*  $.rotation as EulerAngles

$.rotation = (quat   1 0 0 0 )

$.transform

newH = group $  */

-- $.transform * inverse((scalematrix (point3 1 -1 1)) * $.transform)


-- cross $.transform[1] $.transform[3]
