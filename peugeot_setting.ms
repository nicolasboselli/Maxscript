-- shut down diner
-- screens
scenematerials["multi_Group_005"][2].multiplier = 0
-- light
$Light_diner_21.on = off
$Light_diner_02.on = off
$Light_diner_06.on = off
scenematerials["spot_diner"].multiplier = 0



-- light diner screen
scenematerials["multi_Group_005"][2].multiplier = 1
$Light_diner_21.on = on
$Light_diner_02.on = on
$Light_diner_06.on = on
scenematerials["spot_diner"].multiplier = 2


-- switch blue screens
sel = selection as array

toggle = on

for s in sel do
(
	multiMat =  s.material
	for m in multimat where classof m == vraylightmtl do m.texmap_on = toggle
)

-- switch selected lights
sel = selection as array
switch = off
for s in sel where classof s == vraylight do
(
try(s.on = switch)catch()
)