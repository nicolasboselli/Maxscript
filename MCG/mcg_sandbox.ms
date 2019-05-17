plugin simpleObject cube_sphere
	name:"sandbox2"
	classID:#(0x44CEBD01, 0x6A6F36C8)
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
		cube_size ui:cube_size default:0 type:#float animatable:true
		amount ui:amount default:5 type:#float animatable:true
		inset ui:inset default:5 type:#float animatable:true
		mat_id ui:mat_id default:5 type:#integer animatable:true
		smooth_id ui:smooth_id default:5 type:#integer animatable:true
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
		pluginDefinitionFile = @"N:\Ressources_Nico\github\00_wip\Maxscript\MCG\mcg_sandbox.maxtool"
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
		pluginGraphDependencies = #(@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Mesh_Extrude_All_Polygons.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Cube_Mesh_Primitive.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Mesh_Extrude_Polygons.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Mesh_Polygons.maxcompound",@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Group_Indices_by_Value.maxcompound")

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
		spinner cube_size "cube_size" range:[-10000, 10000, 0] type:#float
		spinner amount "amount" range:[-10000, 10000, 5] type:#float
		spinner inset "inset" range:[-10000, 10000, 5] type:#float
		spinner mat_id "mat id" range:[-10000, 10000, 5] type:#integer
		spinner smooth_id "smooth id" range:[-10000, 10000, 5] type:#integer

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
		local args = dotnet_ValueToDotNetObject #(cube_size, amount, inset, mat_id, smooth_id) argsType
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
