
if not iskindof (layermanager.getlayerfromname "01_CAM_LIGHT") MixinInterface then layermanager.newlayerfromname "01_CAM_LIGHT"
if not iskindof (layermanager.getlayerfromname "02_BAT") MixinInterface then layermanager.newlayerfromname "02_BAT"
if not iskindof (layermanager.getlayerfromname "HAB") MixinInterface then layermanager.newlayerfromname "HAB"
if not iskindof (layermanager.getlayerfromname "OFF") MixinInterface then layermanager.newlayerfromname "OFF"

if not iskindof (layermanager.getlayerfromname "CORBEILLE") MixinInterface then layermanager.newlayerfromname "CORBEILLE"
if not iskindof (layermanager.getlayerfromname "PLAN") MixinInterface then layermanager.newlayerfromname "PLAN"


daddy = layermanager.getlayerfromname "OFF"
planL = layermanager.getlayerfromname "PLAN"
corbeilleL = layermanager.getlayerfromname "CORBEILLE"

corbeilleL.setParent daddy
planL.setParent daddy
