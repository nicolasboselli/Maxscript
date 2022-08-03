try(closeRolloutFloater windowsToolsRF)catch()
windowsToolsRF = newRolloutFloater "Windows Tools" 300 650 80 200

filein "windows_opener.ms"
filein "ParallaxPlacer.ms"
filein "windows_settings.ms"

try( DestroyDialog parallaxplacerRLT )catch()
try( DestroyDialog openFenetresRLT )catch()
try( DestroyDialog windowsSettingsRLT )catch()

addRollout openFenetresRLT windowsToolsRF
addRollout parallaxplacerRLT windowsToolsRF
addRollout windowsSettingsRLT windowsToolsRF