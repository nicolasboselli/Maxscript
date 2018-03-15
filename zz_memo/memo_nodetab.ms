--Amelioration:
---- rafraichir la liste à la selection de l'objet
---- prévoir le cas ou un objet est delete


-- creation du modifier
modPanel.addModToSelection (emptymodifier ()) ui:on

--
toto = attributes toto	
(
	
	parameters main rollout:pose
		(
		nodeTab type:#nodetab tabSizeVariable:true
		)
	rollout pose "test"
		(
			button refresh "refresh list"
			listBox node_list "poses" height:5 items: #()
			pickButton add_node "add node" 
			button select_node "select node"
			button delete_node "delete node"
			
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
			
		)
)


custAttributes.add $.modifiers[#'Attribute Holder'] toto



/*
$box001.modifiers[#'Attribute Holder'].toto.nodeTab
$box001.modifiers[#'Attribute Holder'].toto.node_list

deleteitem  $box001.modifiers[#'Attribute Holder'].toto.nodeTab 1
*/
/*
$box001.modifiers[#'Attribute Holder'].toto.nodeTab

append  $box001.modifiers[#'Attribute Holder'].toto.nodeTab $Point001

test = $box001.modifiers[#'Attribute Holder'].toto.nodeTab
append test  $Point001
*/

--s = #(1,2,3,4)
--append s 6

-- stocké donnée en string sur un objet

/*
s = #(1,2,4,5)

setAppData $Box002 0001 (s as string)
getAppData $Box002 

-- add custom attribute to the scene

newTrackViewNode globalTracks "GUN"
theCont = bezier_float ()
addTrackViewController globalTracks.GUN theCont "myVariable"

myCAs = attributes GUN_Atts
(
parameters GUN_Params
(
GUN_shotTimeArr type:#stringTab tabSize:0 tabSizeVariable:true
)
)
custattributes.add globalTracks.GUN myCAs

*/