try(closeRolloutFloater windowsToolsRF)catch()
windowsToolsRF = newRolloutFloater "Windows Tools" 300 500 80 200

filein "windows_opener.ms"
filein "ParallaxPlacer.ms"

try( DestroyDialog parallaxplacerRLT )catch()
try( DestroyDialog openFenetresRLT )catch()

addRollout openFenetresRLT windowsToolsRF
addRollout parallaxplacerRLT windowsToolsRF