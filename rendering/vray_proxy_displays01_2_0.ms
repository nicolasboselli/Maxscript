global vmesh_roll 
try ( destroydialog vmesh_rol ) catch()
rollout vmesh_roll "  Vray Proxy Displays" --- by Budi G ( Oct 2010 )
( -- dialog
	
  group " Display :"
	(
	 radiobuttons display_btn "" labels:#("bounding box", "preview from file", "point", "faces", "whole mesh") default:0 columns:1
	)
	
	button prevBT "display all"
	
	fn display_type sel type = ( for i in sel do if classof i == VRayProxy then ( i.display = type ) else () )
		
	on display_btn changed thestate do
	(
		case thestate of 
		(

			1: display_type selection 0

			2: display_type selection 1

			3: display_type selection 2

			4: ( display_type selection 1 ; display_type selection 3 ) -- mesh
			
			5: display_type selection 4
		)
	)--end on pressed

	on prevBT pressed do
	(
		for o in geometry where iskindof o vrayproxy do o.display = display_btn.state
	)
	
) -- dialog
createdialog vmesh_roll width:135 height:110 style:#(#style_sysmenu, #style_toolwindow)
	