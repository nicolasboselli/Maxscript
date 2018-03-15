
-- autoskinwrap

for s in (selection as array ) do (
	-- s = $
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
	sw.falloff  = 2.2
	sw.distance  = 3
	sw.weightAllVerts = on

	modPanel.setCurrentObject sw
	sw.ConvertToSkin true
	deleteModifier s sw
	deleteModifier s oldSkin

	delete sw_ref

	addmodifier s (Turbosmooth ()) 
	addmodifier s (Point_CacheSpacewarpModifier ())
	s.modifiers[#TurboSmooth].enabled = false

	sleep 0.1
)