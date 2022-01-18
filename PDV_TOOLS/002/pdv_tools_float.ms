try(closeRolloutFloater pdvToolsRF)catch()
pdvToolsRF = newRolloutFloater "Pdv Tools" 200 1050 80 200


filein "pdv_tools.ms"
filein "place_suns.ms"
filein "captureCams.ms"

try( DestroyDialog pdv_cam_RLT )catch()
try( DestroyDialog placeSun2RLT )catch()
try( DestroyDialog captureCamRLT )catch()

addRollout pdv_cam_RLT pdvToolsRF
addRollout placeSun2RLT pdvToolsRF
addRollout captureCamRLT pdvToolsRF
