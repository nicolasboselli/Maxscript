try(closeRolloutFloater balconizerRF)catch()
balconizerRF = newRolloutFloater "Balconizer" 200 700 -- 80 200

filein "ObjBalconizer_alpha1.ms"
filein "SplineBalconizer_alpha1.ms"

try( DestroyDialog BalconizerRLT )catch()
try( DestroyDialog Balconizer2RLT )catch()
-- try( DestroyDialog captureCamRLT )catch()

addRollout  Balconizer2RLT balconizerRF
addRollout  BalconizerRLT balconizerRF
-- addRollout captureCamRLT pdvToolsRF