/*
plans management:
x debug: quand on ouvre un nouveau plan manager alors qu'un premier scene manager est déja ouvert. Le nouveau load ne load pas les préference

*/

try(closeRolloutFloater  plansManagementFloater)catch()
plansManagementFloater = newRolloutFloater "Plans Management Tools" 500 800 -- lockWidth: false

filein "create_plane.ms"
filein "plan_opacity.ms"
filein "Plan_resizer.ms"
filein "transfer_uv.ms"

addRollout createPlaneRLT plansManagementFloater
addRollout opaRLT plansManagementFloater
addRollout transfertUV_RLT plansManagementFloater
addRollout planResizerRLT plansManagementFloater