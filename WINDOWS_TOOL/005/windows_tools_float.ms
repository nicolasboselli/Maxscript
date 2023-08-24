


try(closeRolloutFloater windowsToolsRF)catch()
windowsToolsRF = newRolloutFloater "Windows Tools" 300 650 80 200

filein (getroot() + "BOXERIZE/006/boxerize.ms")
filein (getroot() + "BOXERIZE_archi/002/boxerize_archi.ms")
filein (getroot() + "objReplacer/005/resizerTool_live.ms")
filein (getroot() + "objReplacer/006/obj_replacer.ms")

filein "windows_opener.ms"
filein "ParallaxPlacer.ms"
filein "windows_settings.ms"


try( DestroyDialog objReplacerRLT )catch()
try( DestroyDialog boxerizeRLT )catch()
try( DestroyDialog changeArchVizWindowsRLT )catch()
try( DestroyDialog windowsResizerRLT )catch()
try( DestroyDialog parallaxplacerRLT )catch()
try( DestroyDialog openFenetresRLT )catch()
try( DestroyDialog windowsSettingsRLT )catch()

addRollout openFenetresRLT windowsToolsRF 
addRollout parallaxplacerRLT windowsToolsRF
addRollout boxerizeRLT windowsToolsRF rolledUp: true
addRollout changeArchVizWindowsRLT windowsToolsRF rolledUp: true
addRollout windowsResizerRLT windowsToolsRF rolledUp: true
addRollout objReplacerRLT windowsToolsRF rolledUp: true
addRollout windowsSettingsRLT windowsToolsRF rolledUp: true 