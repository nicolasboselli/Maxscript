fn FreezeTransform = 	
	( 		
		local Obj = Selection as array 	
-- 		suspendEditing
		for i = 1 to Obj.count do 		
		( 
			Try
			(	
				local CurObj = Obj[i] 	
				local curRotCtrl = CurObj.rotation.controller
				if  classof curRotCtrl != Rotation_Layer do
				(
					local activeCtrl = undefined
					if (classof curRotCtrl == Rotation_list) do 
					(
						if (curRotCtrl.getCount() == 2 and curRotCtrl.getActive() == 2 and classof curRotCtrl[2].controller == Euler_Xyz) do
						(
							activeCtrl = curRotCtrl[2]
						)
					)

					-- freeze rotation		
					CurObj.rotation.controller = Euler_Xyz()
					CurObj.rotation.controller = Rotation_list() 
					if (activeCtrl != undefined) then
					(
						activeCtrl.x_rotation = 0
						activeCtrl.y_rotation = 0
						activeCtrl.z_rotation = 0
						CurObj.rotation.controller.available.controller = activeCtrl.controller
					)
					else
					(
						CurObj.rotation.controller.available.controller = Euler_xyz() 		
					)
					
					/* "Localization on" */  
				
					CurObj.rotation.controller.setname 1 "Frozen Rotation"
					CurObj.rotation.controller.setname 2 "Zero Euler XYZ"		
				
					/* "Localization off" */ 
					
					CurObj.rotation.controller.SetActive 2

					setAppData (CurObj.rotation.controller[1].controller) 0x100 "InternalFlagByFreezeTransform"
				)
				
				local curPosCtrl = CurObj.position.controller
				if classof curPosCtrl != Position_Layer do
				(
					local activeCtrl = undefined
					if (classof curPosCtrl == position_list) do 
					(
						if (curPosCtrl.getCount() == 2 and curPosCtrl.getActive() == 2 and classof curPosCtrl[2].controller == Position_XYZ) do
						(
							activeCtrl = curPosCtrl[2]
						)
					)
					-- freeze position
					CurObj.position.controller = Bezier_Position() 			
					CurObj.position.controller = position_list() 
					if (activeCtrl != undefined) then
					(						
						activeCtrl.x_position = 0
						activeCtrl.y_position = 0
						activeCtrl.z_position = 0
						CurObj.position.controller.available.controller = activeCtrl.controller
					)
					else
					(
						CurObj.position.controller.available.controller = Position_XYZ() 
					)
						
					/* "Localization on" */  
							
					CurObj.position.controller.setname 1 "Frozen Position" 	
					CurObj.position.controller.setname 2 "Zero Pos XYZ" 			
					
					/* "Localization off" */  
					
					CurObj.position.controller.SetActive 2 		
		
					-- position to zero
					CurObj.Position.controller[2].x_Position = 0
					CurObj.Position.controller[2].y_Position = 0
					CurObj.Position.controller[2].z_Position = 0

					setAppData (CurObj.position.controller[1].controller) 0x100 "InternalFlagByFreezeTransform"
				)
			)	
			/* "Localization on" */  
					
			Catch( messagebox "FreezeTransform Fail" title: "FreezeTransform Fail")
					
			/* "Localization off" */  	
		)
-- 		resumeEditing
	)
	
FreezeTransform()