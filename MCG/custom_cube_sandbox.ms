plugin simpleObject custom_cube_sandbox
	name:"custom_cube_sandbox"
	classID:#(0x7D4DC97E, 0x62DBF9E4)
	category:"Max Creation Graph"
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
		Size ui:Size default:10 type:#worldUnits animatable:true
		_dummy type:#boolean invisibleInTV:true -- this exists to enable easy invalidation of the object
		pluginGraph type:#filename assettype:#MaxCreationGraph readOnly:true enumAsAsset:true 
		pluginGraphDependencies type:#filenametab assettype:#MaxCreationGraph readOnly:true enumAsAsset:true tabSize:0 tabSizeVariable:true	
	)

	parameters simParams rollout:simRollout
	(
		StepsPerFrame default:1.0 type:#float animatable:false
	)

	-- If we are running a simulation, this force the updateFxn to be called at regular time intervals
	-- which forces the internal caches to be updated.
	fn RunSimLoop updateFxn = ( 
		local result = ok

		-- If we are not running a simulation, simply call the updateFxn and return the result  
		if interactiveMode then
		(
			--interact with the sim, step one frame forward
			_lastTime += 1.0
			try (
				at time _lastTime (
					result = updateFxn()
				)
			)
			catch()
			return result
		)

		currentFrameTime = (currentTime as float)/TicksPerFrame
		-- We are in simulation mode. 		
		-- If we are at the currentTime just return the updateFxn 
		if (_lastTime == currentFrameTime) then (
			try ( result = updateFxn() )
			catch()
			return result
		)
		-- If we move backwards in time, we reset the simulation
		if ( _lastTime > (ceil currentFrameTime)) then
		(
			_lastTime = (animationRange.start as float)/TicksPerFrame
			pluginInstance.ClearPluginCaches() --clear the cahce, reinitializing the sim
			-- There is a special case that we moved to the begin of the simulation
			-- In this case we have to call the updateFxn once 
			if (_lastTime == currentFrameTime) then (
				try ( result = updateFxn() )
				catch()
				return result
			)
		)
		-- We are moving forwards in time, step forward rounding up to the
		-- nearest subframe step
		lastFrame = floor (currentFrameTime)
		diff = currentFrameTime - lastFrame
		stepSize = (1.0/StepsPerFrame)
		-- the last hard frame + the number of steps to take * step size
		stepToFrame = lastFrame + ((ceil (diff / stepSize)) * stepSize)
		stepped = false
		try
		(
			if _lastTime == ((animationRange.start as float)/TicksPerFrame) then
			( --evaluate at the beginning
				at time _lastTime (
					result = updateFxn ()
				)
			)
			while _lastTime < stepToFrame do 
			(
				stepped = true
				_lastTime += (1.0/StepsPerFrame) --step one forward at our rate
				at time _lastTime (
					result = updateFxn ()
				)
			)
			if not stepped then
			(	--we did not step a frame, return our current result
				at time _lastTime (
					result = updateFxn ()
				)
			)
		)
		catch()
		_lastTime = stepToFrame
		return result
	)

	fn initialize = 
	(
		pluginDefinitionFile = @"N:\Ressources_Nico\github\00_wip\Maxscript\MCG\custom_cube_sandbox.maxtool"
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
		pluginGraphDependencies = #(@"C:\Program Files\Autodesk\3ds Max 2019\MaxCreationGraph\Compounds\Cube_Mesh_Primitive.maxcompound")

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
		spinner Size "Size" range:[-10000, 10000, 10] type:#worldUnits

	)

	rollout simRollout "Simulation"
	(
		button resetSimulation mcgOps.ReinitSimButtonText
		on resetSimulation pressed do
		(
			--clear the caches related to this graph
			pluginInstance.ClearPluginCaches()
			_lastTime = 0.0
			_dummy = not _dummy
		)
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
		local args = dotnet_ValueToDotNetObject #(Size) argsType
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
