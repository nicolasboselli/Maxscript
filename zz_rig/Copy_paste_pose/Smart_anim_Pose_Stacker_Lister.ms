-- amélioration: prévoir un paramètre pour stocker les poses sous formes de string
-- stocker les poses sous formes de structures
-- prévoir une fonction pour convertir les structures en string et refaire les string en structure

-- fonction pour retrouver les stockers de pose dans la scene
fn checkPSSceneFN =
(
	local poseStackersArray = #()
	for o in ($* as array) do 
	(
		if classof o == point and (findstring o.name "PS") != undefined then	append  poseStackersArray o
	)
	poseStackersArray = makeUniqueArray poseStackersArray
	return poseStackersArray
)	

checkPSSceneFN ()

rollout PoseStackerListerRLT "Pose Stacker Manager"
(
	Listbox psStackerLB "Pose Stacker"
	edittext renamePSET "Rename :"
	button refreshListBT "Refresh List" across: 4
	button createPoseStackerBT "Create New"
	button deletePoseStackerBT "Delete Selected"
	button editPoseStackerBT "Edit"
	
	on PoseStackerListerRLT open do
	(
		psStackerLB.items = for o in (checkPSSceneFN ()) collect o.name
		print "yahoo!"
	)
	
	on psStackerLB selected PoseStackerArg do
	(
		renamePSET.text = (checkPSSceneFN ())[PoseStackerArg].name
	)		
	
	on refreshListBT pressed do 
	(
		psStackerLB.items = for o in (checkPSSceneFN ()) collect o.name
	)
	
	on createPoseStackerBT pressed do
	(
		local PS = point name: (uniquename "PS_")
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
		custAttributes.add PS pose_stacker 
		
		psStackerLB.items = for o in (checkPSSceneFN ()) collect o.name
	)
	
	on deletePoseStackerBT pressed do
	(
		if psStackerLB.items.count > 0 then
		(
			delete (checkPSSceneFN ())[psStackerLB.selection]
			psStackerLB.items = for o in (checkPSSceneFN ()) collect o.name
		)
		else
		(
			messagebox "Créer des Pose Stacker dans la scène."
		)

	)
	
	on editPoseStackerBT pressed do
	(
		if psStackerLB.items.count > 0 then
		(
			select (checkPSSceneFN ())[psStackerLB.selection]
			Createdialog CPP width: 400
			clearselection ()
		)
		else
		(
			messagebox "Créer des Pose Stacker dans la scène."
		)
	)

)

createdialog PoseStackerListerRLT width: 400