s = point () 
s.name = (uniquename "pose_supervisor_")
select s


supervisor = attributes supervisor	
(
	parameters main 
	(
		stack_node type:#nodetab tabSizeVariable:true
	)
)	
custAttributes.add s supervisor


modPanel.addModToSelection (emptymodifier ()) ui:on	

open_supervisor = attributes open_supervisor	
(
	parameters main rollout: open_supervisor
	(
	nodeTab type:#nodetab tabSizeVariable:true
	)
	
	rollout open_supervisor "open supervisor"
	(
		button open_supervisor "open supervisor"
		
		on open_supervisor pressed do
		(
			
			rollout supervisor (s.name as string)
			(		
			
			button refresh "refresh list"
			listBox node_list "poses" height:5 items: #()
			pickButton add_node "add node" 
			button select_node "select node"
			button delete_node "delete node"
			
			local nodeTab = $pose_supervisor_001.modifiers[#'Attribute Holder'].supervisor.stack_node
			
			on refresh pressed do print nodeTab
			/*
			on add_node picked obj do
				(
					if obj != undefined do
					(
						append  nodeTab obj
						node_list.items = for i = 1 to nodeTab.count collect nodeTab[i].name
					)
				)
			
			on refresh pressed do
				(
					node_list.items = for i = 1 to nodeTab.count collect nodeTab[i].name
				)
			
			on delete_node pressed do
				(
					nb = node_list.selection
					print nb
					deleteitem nodeTab 1
					node_list.items = for i = 1 to nodeTab.count collect nodeTab[i].name
					--deleteitem collection nb
				)
			
			on select_node pressed do
				(
				nb = node_list.selection
				select nodeTab[nb]
				)
			*/
			)
			
			createdialog supervisor
		)
	)
)
custAttributes.add $.modifiers[#'Attribute Holder'] open_supervisor





custAttributes.delete $ open_supervisor
$.open_supervisor

.source