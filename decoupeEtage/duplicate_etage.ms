/*
sel = selection as array
-- s = $w
id = 1
jump = 1

for s in sel do
(
	newS = copy s
	var = s.name
	var[id] = (((var[id] as integer) + jump) as string)
	newS.name = var
	
	newS.wirecolor = s.wirecolor

	move newS [0,0,300]
)
*/

fn incrementName n charId: 1 inc: 1 =
(
	local newName
	local count
	
	try (count = n[charId] as integer) catch(count = undefined)
	
	if not count == undefined then
	(
		newName = n
		newName[charId] = ((count + inc) as string)
	)
	newName
)

-- incrementName "205" charId: 2 inc: 2

fn copyIncNameNMove s id:1 jump:1 moving: true decay: [0,0,300] =
(
	local newS
	local newName = incrementName s.name charId: id inc: jump
	
	if newName == undefined then (format "fail: %\n" s.name)
	else
	(
		newS = copy s
		
		newS.name = newName
		
		newS.wirecolor = s.wirecolor
		
		s.layer.addnode newS
		
		if moving then move newS decay
	)
	newS
)

try(destroydialog incNameRLT )catch()

rollout incNameRLT "Duplicate Etages"
(
	group "renaming"
	(
		spinner idSP "character index:" type: #integer range:  [1,1000,1] across: 2
		spinner jumpSP "increment:" type: #integer  range: [-100,100,1]
	)
	
	group "moving"
	(
		spinner xSP "x:" type: #worldunits  range: [-1000,1000,0] across: 3
		spinner ySP "y:" type: #worldunits range: [-1000,1000,0]
		spinner zSP "z:" type: #worldunits range: [-1000,1000,300]
	)
	
	button cloneBT "duplicate"
	
	on idSP changed val do
	(
-- 		format "youpi\n"
		sel = selection as array
		if sel.count > 0 then
		(
-- 			local var = sel[1].name
			testName = incrementName sel[1].name charId: val inc: jumpSP.value
			format "new name: %\n" testName
		)
	)
	
	on jumpSP changed val do
	(
		sel = selection as array
		if sel.count > 0 then
		(
-- 			local var = sel[1].name
			testName = incrementName sel[1].name charId: idSP.value inc: val
			format "new name: %\n" testName
		)
	)
	
	on cloneBT pressed do
	(
		sel = selection as array
		newSel = #()
		for s in sel do
		(
			copyS = copyIncNameNMove s id:idSP.value jump:jumpSP.value moving: true decay: [xSp.value, ySP.value, zSp.value]
			if not copyS == undefined then append newSel copyS
		)
		select newSel
	)
)
createdialog incNameRLT width: 400