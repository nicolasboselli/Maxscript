-------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

-- APPLICATION DU MODIFIER
	
	def = attributes multi_parent_on_fly

(
	parameters main rollout:multi_parent (
		-- ajouter la nouvelle cible dans les constraint controller et dans le rollout
		-- création de parameter nodetab
		stack_relais type:#nodetab tabSizeVariable:true 
		)
	
	rollout multi_parent "Multi Constraints" 
	( 
		group "Parents List"
			(
			-- un rollout pour memoriser les parents
			listBox parents "Parents"  height:10 items: #()
			-- un bouton pour update name
			button up_name "Update Names" 
			-- un bouton ajouter et activer le parent
			)
	
		group "Set Parent"
			(
			-- un bouton pour picker le parent
			Pickbutton  add_active "Add and Active New Parent"
			-- un bouton pour activer le parent en déplaçant le relais
			button active_parent "Active Parent"
			-- un bouton pour déplacer le porteur sur le relais
			button go_to_relais "Go To Relais"
			-- un spinner pour regler l'influence du parent
			spinner set_active "Set Influence" 
			)
			
		group "Show Parents"
			(
			-- show relais
			button show_relais "Show the Relais"
			-- show parent
			button show_parent "Show the Parent"
			)
		
		group "Hide / Show Relais"
			(
			-- show others
			button Show_other "Show Others"
			button Hide_other "Hide Others"
			)
			
	-- Variables

			
			
	-- ACTIONS
	
	-- creation d'un nouveau parent
	on add_active picked obj do
	(
		-- CREATION D'UN NOUVEAU RELAIS relais (helper avec controller spline) parent de l'objet contrainte à la position et à la rotation du porteur avec l'aspect des autres relais
			-- création d'un cercle à la position et la rotation du porteur
		rot_temp = $.rotation
		pos_temp = $.position
		ctr_temp = circle radius: 10 rotation: rot_temp position: pos_temp
		converttosplineshape ctr_temp
		updateshape ctr_temp

			-- création d'un helper à la position et la rotation du porteur
		ctr_temp_hlp = point size: 3 rotation: rot_temp position: pos_temp axistripod: false box: true cross: true		
			-- parenté du helper avec le cercle
		ctr_temp_hlp.parent = ctr_temp
			
			-- parenter du cercle avec le parent
		ctr_temp.parent = obj

			-- changement d'apparence du cercle en controleur spline
				-- collecte du modele
		model = $.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais[1].parent
		copy_ctr = copy model
		converttosplineshape copy_ctr
		updateshape copy_ctr
				-- collage du modele
		addandweld ctr_temp copy_ctr -1
		deletespline ctr_temp 1
		updateshape ctr_temp
		
			-- renommer le controleur spline
			name_temp = $.name
			name_temp = substituteString name_temp "_locked" ""
			if ctr_temp.parent == undefined then ctr_temp.name = (uniquename (name_temp + "_world_relais")) else ctr_temp.name = (uniquename ( name_temp + "_" + ctr_temp.parent.name + "_relais"))
		
		-- renommer le helper du nouveau controleur spline
		ctr_temp_hlp.name = "hlp_" + ctr_temp.name
			
		-- ajout du helper dans les controller constraint
		$.position.controller.appendtarget ctr_temp_hlp 0
		$.rotation.controller.appendtarget ctr_temp_hlp 0
		
		-- rendre les controleurs de poids animable
		loop_count = $.position.controller.weight.count
		$.position.controller.weight[loop_count].controller = bezier_float ()
		$.rotation.controller.weight[loop_count].controller = bezier_float ()
		
		-- ajouter du helper dans le stack relais
		append $.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais ctr_temp_hlp
		-- updater le rollout
		parents.items = for i = 1 to stack_relais.count collect stack_relais[i].name
			
		-- ANIMATION DES POIDS DES PARENTS
		-- une frame avant la frame où le nouveau parent est pické créer un clef d'animation sur tous les poids à la position où il sont
		for i = 1 to loop_count do
		(
			addNewKey $.position.controller.weight[i].controller (slidertime - 1)
			addNewKey $.rotation.controller.weight[i].controller (slidertime - 1)
		)
		
		-- à la frame où le nouveau parent est pické mettre le poids du nouveau parent à 100 et tous les autres à 0
		animate on at time slidertime $.position.controller.weight[loop_count].controller.value = 100
		animate on at time slidertime $.rotation.controller.weight[loop_count].controller.value = 100
		
		for i = 1  to ( loop_count - 1) do animate on at time slidertime $.position.controller.weight[i].controller.value = 0
		for i = 1  to ( loop_count - 1) do animate on at time slidertime $.rotation.controller.weight[i].controller.value = 0
		

	)
	
	-- creation d'une nouvelle clef d'animation des poids des parents
	on active_parent pressed do
	(
		-- collecter le relais selectionné
		num_select = $.modifiers[#'Attribute Holder'].multi_parent_on_fly.multi_parent.parents.selection
		actived_relais = $.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais[num_select].parent

		-- deplacer le relais selectionner à la position courante du porteur en animant le déplacement sur une frame
			addNewKey actived_relais.position.controller (slidertime - 1)
			addNewKey actived_relais.rotation.controller (slidertime - 1)
		
		animate on
		(
			at time slidertime actived_relais.position = $.position
			at time slidertime actived_relais.rotation = $.rotation
		)

	-- à la frame précedente créer une clef d'animation pour conserver les poids
		loop_count = $.position.controller.weight.count
				for i = 1 to loop_count do
		(
			addNewKey $.position.controller.weight[i].controller (slidertime - 1)
			addNewKey $.rotation.controller.weight[i].controller (slidertime - 1)
		)
		
	-- à la frame où le bouton est pressé porter le poids du parent selectionner à 100 et le poids des autres à 0

		for i = 1  to ( loop_count) do animate on at time slidertime $.position.controller.weight[i].controller.value = 0
		for i = 1  to ( loop_count) do animate on at time slidertime $.rotation.controller.weight[i].controller.value = 0
		
		animate on at time slidertime $.position.controller.weight[num_select].controller.value = 100
		animate on at time slidertime $.rotation.controller.weight[num_select].controller.value = 100
		
	)

	on go_to_relais pressed do
	(
		-- collecter le relais selectionné
		num_select = $.modifiers[#'Attribute Holder'].multi_parent_on_fly.multi_parent.parents.selection
		actived_relais = $.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais[num_select].parent
		
		-- à la frame précedente créer une clef d'animation pour conserver les poids
		loop_count = $.position.controller.weight.count
				for i = 1 to loop_count do
		(
			addNewKey $.position.controller.weight[i].controller (slidertime - 1)
			addNewKey $.rotation.controller.weight[i].controller (slidertime - 1)
		)
		
	-- à la frame où le bouton est pressé porter le poids du parent selectionner à 100 et le poids des autres à 0

		for i = 1  to ( loop_count) do animate on at time slidertime $.position.controller.weight[i].controller.value = 0
		for i = 1  to ( loop_count) do animate on at time slidertime $.rotation.controller.weight[i].controller.value = 0
		
		animate on at time slidertime $.position.controller.weight[num_select].controller.value = 100
		animate on at time slidertime $.rotation.controller.weight[num_select].controller.value = 100

	)
	
	on up_name pressed do
	(	
	-- rafraichit les noms en fonction de leur changement 
	
	--parents.items = for i = 1 to stack_relais.count collect stack_relais[i].name
	-- prevoir une formule pour raccourcir les noms, ne garder que la fin
	
	s_name_locked = $.name
	s_name = substituteString s_name_locked "_locked" ""
	
	stack_count = $.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais.count
	stack_relais = $.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais
	stack_names = for o in stack_relais collect o.name
	stack_names = for o in stack_names collect substituteString o s_name ""
	stack_names = for o in stack_names collect substituteString o "hlp_" ""

	parents.items = for o in stack_names collect o
	-- récupérer le nom de la selection 
	-- enlever locked du nom
	-- à la collecte des noms des parents enlevé le nom de la selection et relais
	)
			
	
	)
)

modPanel.addModToSelection (emptymodifier ()) ui:on
custAttributes.add $.modifiers[#'Attribute Holder'] def

/*	
$.modifiers[#'Attribute Holder'].multi_constraints_in_the_air.multi_constraint.constraints.selection
$.modifiers[#'Attribute Holder'].multi_constraints_in_the_air.stack_constraints
*/
