theNode = $P_LeLoup_NODE

-- Mdl = $P_LeLoup_MDL005
-- Mdl.modifiers["morpher"]
-- WM3_MC_SetValue Mdl.modifiers["morpher"] 1 100.0


linkTestMod = EmptyModifier name: "Link_Test"
LT = attributes "LinkTest" 
(
	local driver = $P_Loup_D_PaupiereHaute_CTRL
	local driven = $P_LeLoup_MDL005.modifiers["morpher"]
	
-- 	when  transform driver change do (WM3_MC_SetValue driven 1 100.0)
	when  transform driver change id: #testHandler  do (format "val: %\n" driver.position.z)
	
	
)
custAttributes.add linkTestMod LT
addmodifier theNode linkTestMod

driver = $P_Loup_D_PaupiereHaute_CTRL
driven = $P_LeLoup_MDL005.modifiers["morpher"]

when  transform driver change id: #testHandler  do (format "val: %\n" driver.position.z)

deleteAllChangeHandlers id: #testHandler

$.ishidden = false