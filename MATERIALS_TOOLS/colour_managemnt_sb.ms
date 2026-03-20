 ColorPipelineMgr.GetRenderingColorSpaceList()
 ColorPipelineMgr.GetFileIOColorSpaceList()
 ColorPipelineMgr.GetDisplayList()
 
showInterface ColorPipelineMgr

ColorPipelineMgr.GetDefaultOutputConversion ()


ColorPipelineMgr.SetDefaultOutputConversion  #ColorSpaceConversion colorSpace: "sRGB"

ColorPipelineMgr.mode
ColorPipelineMgr.LinearSRGBColorSpace


ColorPipelineMgr.Mode 
ColorPipelineMgr.OCIOConfigPath 
ColorPipelineMgr.Status 
ColorPipelineMgr.RenderingColorSpace 
ColorPipelineMgr.DisplayGamma 
ColorPipelineMgr.DataColorSpace 
ColorPipelineMgr.InputRulesCount 
ColorPipelineMgr.LinearSRGBColorSpace 

renderingSpaces = ColorPipelineMgr.GetRenderingColorSpaceList()
fileSpaces = ColorPipelineMgr.GetFileIOColorSpaceList()
displays = ColorPipelineMgr.GetDisplayList()


format "Render Space Descriptions:\n"
for rs in renderingSpaces do (
    dsc = ColorPipelineMgr.GetColorSpaceDescription rs
    format "% : %\n" rs dsc
)

format "File Space Descriptions:\n"

for rs in fileSpaces do (
    dsc = ColorPipelineMgr.GetColorSpaceDescription rs
    format "% : %\n" rs dsc
)

format "Display View Descriptions:\n"

for dsp in displays do (
    format "Display: %\n" dsp
    vs = ColorPipelineMgr.GetViewList dsp 
    for v in vs do(
        append views v    
        format "  view % : %\n" v (ColorPipelineMgr.GetDisplayViewDescription dsp v)    
    )
    
)

outputColorConversion