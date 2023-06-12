
 
showproperties  $.material

sMat = $.material.texmap_diffuse_color

propNamesAr = getPropNames sMat
for p in propNamesAr do 
(
	format "p: % val: %\n" p (getProperty sMat p)
)
 
 
 
getProperty $.material.texmap_diffuse_color.coords #U_Tiling
setProperty 
 
bmpAr = VRayBitmap ()
bmpAr2 = Bitmaptexture()

showproperties $.material.bump.normal_map.coordinates

showproperties bmpAr2.coordinates
showproperties bmpAr.coordinates

bmpAr2.coords.U_Offset


coordsParams = #(#blur , #mapping , #mapChannel, #mappingType, #UVW_Type, #U_Mirror, 
	#V_Mirror, #U_Tile, #V_Tile, #showMapOnBack, #Noise_On, 
	#Noise_Animate, #UVTransform, #realWorldScale, #realWorldHeight, 
	#realWorldWidth, #phase, #U_Offset, #V_Offset, #U_Tiling, #V_Tiling, 
	#W_angle, #V_Angle, #U_Angle, #Blur_Offset, 
	#Noise_Amount, #Noise_Size, #Noise_Levels)
