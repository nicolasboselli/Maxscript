plugin simpleObject sandbox2
	name:"sandbox2"
	classID:#(0x1B5BD08E, 0x14FB9B59)
	category:"MCG tools"
	usePBValidity:true
(
	local pluginDefinitionFile -- the plugin definition file
	local pluginInstance -- the plugin instance created from the plugin definition
	local _meshWrapper -- the dotnet wrapper around our mesh pointer
	local argsType = dotNetClass "System.Object[]" -- used when creating args array
	local dotnet_ValueToDotNetObject = dotnet.ValueToDotNetObject
	local tmHandler
	local owningNode
	--simulation locals
	local _lastTime = 0.0
	local interactiveMode = false

	-- function wrappers
	local _meshWrapper_SetValue
	local pluginInstance_UpdateMesh

	-- value wrapper local and function wrapper declarations


	parameters main rollout:params
	(
		col_count ui:col_count default:1 type:#integer animatable:true
		col_size ui:col_size default:50 type:#worldUnits animatable:true
		row_size ui:row_size default:50 type:#worldUnits animatable:true
		rows_count ui:rows_count default:1 type:#integer animatable:true
		amount ui:amount default:0 type:#worldUnits animatable:true
		inset ui:inset default:0.5 type:#float animatable:true
		mat_id ui:mat_id default:1 type:#integer animatable:true
		smooth_id ui:smooth_id default:0 type:#integer animatable:true
		_dummy type:#boolean invisibleInTV:true -- this exists to enable easy invalidation of the object
		pluginGraph type:#filename assettype:#MaxCreationGraph readOnly:true enumAsAsset:true 
		pluginGraphDependencies type:#filenametab assettype:#MaxCreationGraph readOnly:true enumAsAsset:true tabSize:0 tabSizeVariable:true	
	)



	fn RunSimLoop updateFxn = (
		local result = ok
		try (
			result = updateFxn ()
		)
		catch()
		return result
	)

	fn initialize = 
	(
		pluginDefinitionFile = @"N:\Ressources_Nico\github\00_wip\Maxscript\MCG\mcg_sandbox2.maxtool"
		local c = dotNetClass "Viper3dsMaxBridge.GeometryPluginInstance"
		local cid = this.classId
		local refMakerWrapperClass = dotnetclass "Autodesk.Max.MaxPlus.ReferenceMaker"
		local _pluginOwner = refMakerWrapperClass._CreateWrapper this
		pluginInstance = c.CreateInstance cid[1] cid[2] pluginDefinitionFile _pluginOwner
		pluginInstance_UpdateMesh = pluginInstance.UpdateMesh
		local meshWrapperClass = dotnetclass "Autodesk.Max.MaxPlus.Mesh"
		_meshWrapper = meshWrapperClass._CreateWrapper undefined
		_meshWrapper_SetValue = _meshWrapper._SetValue
		pluginGraph = pluginDefinitionFile
		pluginGraphDependencies = #(@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Mesh_Extrude_All_Polygons.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Plane_Mesh_Primitive.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Mesh_Extrude_Polygons.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Mesh_Polygons.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Group_Indices_by_Value.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Mesh_from_QuadMesh_with_Hidden_Edges.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Plane_QuadMesh_Primitive_from_Lines.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Plus_One.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Offset_Line.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Line_from_Vector.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Vector_from_X.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Vector_from_Y.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Mesh_Hide_QuadMesh_Edges.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Divide_by_Two.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Flat_Map.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Array_of_Sampled_Floats.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Line_from_Interpolated_Segments.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Points_on_Line.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Array_of_Interpolated_Vectors.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\DEPRECATED_Origin.maxcompound")

		-- value wrapper local initializations

	)

	on create do 
	(
		initialize()
	)

	on clone fromObj do 
	(
		initialize()
	)

	on load do 
	(
		initialize()
	)

	on update do 
	(
		initialize()
	)

	fn installTMHandler theNode =
	(
		owningNode = theNode
		if (tmHandler == undefined and owningNode != undefined) then ( tmHandler = when transform owningNode changes do ( _dummy = not _dummy ))
	)

	on postload do
	(
		installTMHandler(refs.dependentnodes this firstonly:true)
	)

	on attachedToNode theNode do
	(
		installTMHandler(theNode)
	)

	tool create 
	(
		on mousePoint click do 
		(
			case click of 
			(
				1: nodeTM.translation = gridPoint
				2: #stop
			) 
		) 
	) 

	rollout params "Parameters"
	(
		spinner col_count "col count" range:[-10000, 10000, 1] type:#integer
		spinner col_size "col size" range:[-10000, 10000, 50] type:#worldUnits
		spinner row_size "row size" range:[-10000, 10000, 50] type:#worldUnits
		spinner rows_count "rows count" range:[-10000, 10000, 1] type:#integer
		spinner amount "amount" range:[-10000, 10000, 0] type:#worldUnits
		spinner inset "inset" range:[-10000, 10000, 0.5] type:#float
		spinner mat_id "mat_id" range:[-10000, 10000, 1] type:#integer
		spinner smooth_id "smooth_id" range:[-10000, 10000, 0] type:#integer

	)




	rollout MCG_Editor "MCG Editor"(
		button MCG_Editor_btn "Open in MCG Editor"
		on MCG_Editor_btn pressed do
		(
			if (doesFileExist pluginDefinitionFile) then 
			(
				geBridge = dotNetClass "ProceduralContentActions.PCGraphEditorBridge"
				geBridge.LoadGraph pluginDefinitionFile
			)
			else (
				local msgStream = stringstream ""
				format "File '%' is missing.\n" pluginDefinitionFile to:msgStream
				local msgStr = msgStream as string
				if GetQuietMode() then
					format msgStr
				else
					MessageBox msgStr title: "Missing maxtool file" beep:false
			)
		)
	)


	fn transformGetter = 
	(
		if(isValidNode(owningNode)) then owningNode.Transform else matrix3 1
	)

	fn updateMesh = 
	(
		if (pluginInstance == undefined) then ( return undefined )
		local args = dotnet_ValueToDotNetObject #(col_count, col_size, row_size, rows_count, amount, inset, mat_id, smooth_id) argsType
		pluginInstance_UpdateMesh (currentTime as integer) _meshWrapper args
		ok
	)

	on buildMesh do
	(

		if (PreInvokeMethod != undefined ) then PreInvokeMethod()
_meshWrapper_SetValue mesh
		RunSimLoop updateMesh
		_meshWrapper_SetValue undefined

		if (PostInvokeMethod != undefined ) then PostInvokeMethod()
		ok
	)

)
