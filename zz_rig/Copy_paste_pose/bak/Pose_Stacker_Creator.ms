

(
s = point () 
s.name = (uniquename "pose_stacker_")
select s

-- modPanel.addModToSelection (emptymodifier ()) ui:on	

pose_stacker = attributes pose_stacker_tracks 
(
	parameters main
	(
		---- une piste pour enregistrer le nombre eelements de chaque pose #intergertab
		stack_number type:#indextab tabSizeVariable:true 
		---- une piste pour enregistrer les objets de references #nodetab
		stack_ref  type:#nodetab tabSizeVariable:true
		---- une piste pour enregistrer les rotations #point4tab
		stack_rotation type:#point4tab tabSizeVariable:true
		---- une piste pour enregistrer les positions #point3tab
		stack_position type:#point3tab tabSizeVariable:true
		-- une piste pour enregistrer les sets de selection #nodetab
		stack_selection type:#nodetab tabSizeVariable:true
		-- une piste pour enregistrer les noms des poses #nodetab
		stack_pose_name type:#stringtab tabSizeVariable:true
	)
)	
-- custAttributes.add s supervisors
custAttributes.add $ pose_stacker 
)
/*
custAttributes.getSceneDefs () 
custAttributes.deleteDef
pose_stacker_tracks
pose_stacker
*/
/*
$.pose_stacker_tracks.stack_number
$.pose_stacker_tracks.stack_ref
$.pose_stacker_tracks.stack_rotation
$.pose_stacker_tracks.stack_position
$.pose_stacker_tracks.stack_selection
$.pose_stacker_tracks.stack_pose_name
*/

--$.pose_stacker_tracks.stack_pose_name = #()
