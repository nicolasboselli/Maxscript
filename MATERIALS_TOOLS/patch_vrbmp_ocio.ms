
VrBmpAr = getClassInstances VRayBitmap --target: sceneMaterials 
for o in VrBmpAr do o.color_space = 2


ColorPipelineMgr.SetDefaultOutputConversion  #ColorSpaceConversion colorSpace: "sRGB"