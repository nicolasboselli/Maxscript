-- sel = selection as Array
-- getClassInstances VRayBitmap  target: $

try(DestroyDialog DisplayMapRLT)catch()
rollout DisplayMapRLT "Display Texture"
(	
	local toggleState = true
	
	button textureOnBT "Textures OFF"
	button textureOffBT "Textures ON"
	button textureOnOffBT "toggle ON/OFF"
	
	on textureOnBT pressed do
	(
		--- agit sur la visibilité des material avec showTextureMap
		sel = selection as Array
		for s in sel do
		(
			matAr = getClassInstances vraymtl  target: s
			for vr in matAr do showTextureMap vr false
				
			v2sAr = getClassInstances VRay2SidedMtl  target: s
			format "v2sAr: %\n" v2sAr
			for v2s in v2sAr do showTextureMap v2s v2s.frontMtl.texmap_diffuse  false
		)
	)
	
	on textureOffBT pressed do
	(
		sel = selection as Array
		for s in sel do
		(
			matAr = getClassInstances vraymtl  target: s
			for vr in matAr do showTextureMap vr true
				
			v2sAr = getClassInstances VRay2SidedMtl  target: s
			format "v2sAr: %\n" v2sAr
			for v2s in v2sAr do showTextureMap v2s v2s.frontMtl.texmap_diffuse  true
		)
	)
	
	on textureOnOffBT pressed do
	(
		sel = selection as Array
		for s in sel do
		(
			matAr = getClassInstances vraymtl  target: s
			for vr in matAr do showTextureMap vr toggleState
				
			v2sAr = getClassInstances VRay2SidedMtl  target: s
			format "v2sAr: %\n" v2sAr
			for v2s in v2sAr do showTextureMap v2s v2s.frontMtl.texmap_diffuse  toggleState
		)
		
		toggleState = not toggleState
	)
	
)
CreateDialog DisplayMapRLT


/* 

--- agit sur la visibilité des texture diffuse avec showTextureMap
sel = selection as Array
for s in sel do
(
	matAr = getClassInstances vraymtl  target: s
	for vr in matAr do
	(
		bmpAr = getClassInstances Bitmaptexture  target: vr
		
		for m in bmpAr do
		(
			format "		vr: % m: % \n" vr m
			try(showTextureMap vr vr.texmap_diffuse false)catch(format "FAIL!	vr: % m: % \n" vr m)
		)
	)
)

sel = selection as Array
for s in sel do
(
	matAr = getClassInstances vraymtl  target: s
	for vr in matAr do
	(
		bmpAr = getClassInstances Bitmaptexture  target: vr
		
		for m in bmpAr do
		(
			format "	vr: % m: % \n" vr m
			try(showTextureMap vr vr.texmap_diffuse true)catch(format "FAIL!	vr: % m: % \n" vr m)
		)
	)
)




-- agit sur la visibilité des bitmap avec showInViewport
sel = selection as Array
for s in sel do
(
	matAr = getClassInstances vraymtl  target: s
	for vr in matAr do
	(
		bmpAr = getClassInstances Bitmaptexture  target: vr
		
		for m in bmpAr do 
		(
			showTextureMap vr m false
		)
	)
)

sel = selection as Array
for s in sel do
(
	matAr = getClassInstances vraymtl  target: s
	for vr in matAr do
	(
		bmpAr = getClassInstances Bitmaptexture  target: vr
		
		for m in bmpAr do 
		(
			showTextureMap vr m true
		)
	)
)

 */

/* 
--- agit sur la visibilité des material avec showInViewport
sel = selection as Array
for s in sel do
(
	matAr = getClassInstances vraymtl  target: s
	for vr in matAr do vr.showInViewport = false
)

sel = selection as Array
for s in sel do
(
	matAr = getClassInstances vraymtl  target: s
	for vr in matAr do vr.showInViewport = true
)
 */




/*
VRay2SidedMtl

meditmaterials[activeMeditSlot].showInViewport = not meditmaterials[activeMeditSlot].showInViewport 

getMeditMaterial 2


 meditmaterials[activeMeditSlot][2]

showTextureMap meditmaterials[activeMeditSlot][2].frontMtl false
meditmaterials[activeMeditSlot][2].frontMtl

v2s =  meditmaterials[activeMeditSlot][2]
showTextureMap v2s v2s.frontMtl.texmap_diffuse  false


showTextureMap meditmaterials[activeMeditSlot] meditmaterials[activeMeditSlot][2].frontMtl.texmap_diffuse  true

*/


--Pour afficher les textures des objets dans le viewport en utilisant MaxScript, vous pouvez utiliser la fonction showTextureMap. 
-- Voici un exemple de script qui active l'affichage des textures pour tous les matériaux d'une scène :

/* for m in (getMtlSlots (getMtlBySlot (getMtlSlots $) 1)) do (
    showTextureMap m true
) */
