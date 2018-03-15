s = $line001

	modPanel.addModToSelection (Skin ()) ui:on
	
	getKnotPoint s 1 4
	getInVec 
	getOutVec 
	
	skinOps.addbone s.skin $point001 0
	skinOps.addbone s.skin $point002 0
 	skinOps.addbone s.skin $point003 0

	skinOps.SetVertexWeights s.skin 1 
	
	s.skin.Start_Point_Point001
	
	getsubanimnames 
	
	skinOps.SelectVertices s.skin 9
		
	skinOps.IsVertexSelected s.skin 
		
	skinOps.SelectBone s.skin 1
	
	test = #(1,2,3)
	skinOps.SetVertexWeights s.skin 3 2 1
	skinOps.SetVertexWeights s.skin #(1,2,3) #(1,1,1) #(1,1,1)
	skinOps.SetVertexWeights s.skin test 1 1
	skinOps.SetVertexWeights s.skin 6 2 1
	skinOps.SetVertexWeights s.skin 9 3 1
	
	skinOps.SetVertexWeights <Skin> <vertex_integer> \
	( <vertex_bone_integer> | <vertex_bone_array> ) \
	( <weight_float> | <weight_array> )
