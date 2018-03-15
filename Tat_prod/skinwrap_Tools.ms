sel = selection as array
for s in sel do
(
	select s
-- 	redrawviews()
	try
	(
		s.modifiers[#skin_wrap].enabled = false 
	)catch()
)

-- convert to skin
sel = selection as array
for s in sel do
(
	select s
-- 	redrawviews()
	try
	(
		sw = $.modifiers[#skin_wrap]
		modPanel.setCurrentObject sw
		sw.ConvertToSkin true
	)catch()
)


sel = selection as array
for s in sel do
(
	sw = undefined 
	select s
-- 	redrawviews()
	
	sw = $.modifiers[#skin_wrap]
	if sw != undefined then deleteModifier s sw

)

-- skin wrap on selection
sel = selection as array
src = sel[1]
-- tgt = sel[2]

for i = 2 to sel.count do
(
	tgt = sel[i]
	addmodifier tgt (skin_wrap ())
	sw = tgt.modifiers[#skin_wrap]
	sw.meshList = #(src)
	sw.weightAllVerts = on
	modPanel.setCurrentObject sw
	sw.ConvertToSkin true
	deleteModifier tgt sw
)

-- autoskinwrap
s = $
sw_ref = copy s
sw_ref.boxmode = true
sw_ref.name  = substitutestring s.name "_MDL" "_SkinWrap_RIG"
for m in sw_ref.modifiers where classof m != skin do deletemodifier sw_ref m
select sw_ref
for m in sw_ref.modifiers where classof m == skin do modPanel.setCurrentObject  m
	
select s
for m in s.modifiers where classof m == Point_CacheSpacewarpModifier  do deletemodifier s m
for m in s.modifiers where classof m == Turbosmooth   do deletemodifier s m
for m in s.modifiers where classof m == skin do oldSkin = m
-- oldSkin = s.modifiers[#skin]
oldSkin.name = "skin_bak"
oldSkin.enabled = false
id = modPanel.getModifierIndex s oldSkin

addmodifier s (skin_wrap ()) before: id
sw = s.modifiers[#skin_wrap]
sw.meshList = #(sw_ref)
sw.falloff  = 1.2
sw.distance = 1.5
sw.weightAllVerts = on

modPanel.setCurrentObject sw
sw.ConvertToSkin true
deleteModifier s sw
deleteModifier s oldSkin

nameET

