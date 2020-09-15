-- faceSel = polyop.getfaceselection $ 
-- s.edit_poly.GetSelection  #face


faceSel = $.GetSelection  #face
-- $.GetFaceVertex  faceSel[1] 2

facesNormals = for f in facesel collect polyop.getFaceNormal $.baseobject f
SuperFacesNormals = #(facesNormals[1])

for i = 2 to facesNormals.count do 
(
	appendThis = true
	for j = 1 to SuperFacesNormals.count do
	(
		testAngle = (acos (dot facesNormals[i] SuperFacesNormals[j]))
		
		if  testAngle >= 0.1 then 
		(
			appendThis = false
			format "exit testangle: % facesNormals[%]: %  SuperFacesNormals[%]: % \n" testAngle i facesNormals[i] j SuperFacesNormals[j]
			exit
		)
	)
	if appendThis then append SuperFacesNormals facesNormals[i]
)
SuperFacesNormals