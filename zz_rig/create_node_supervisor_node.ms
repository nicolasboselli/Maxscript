s = point () 
s.name = (uniquename "pose_supervisor_")
select s

-- modPanel.addModToSelection (emptymodifier ()) ui:on	

supervisor_track = attributes supervisor_node
(
	parameters main
	(
		stack_node type:#nodetab tabSizeVariable:true subanim: true
		)
)	
-- custAttributes.add s supervisors
custAttributes.add $ supervisor_track