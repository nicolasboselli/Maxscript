-------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

-- amelioration: modifier l'apparence du controller à la première application du modifier


-- APPLICATION DU MODIFIER
	
	def = attributes multi_parent_on_fly

(
	parameters main rollout:multi_parent (
		-- ajouter la nouvelle cible dans les constraint controller et dans le rollout
		-- création de parameter nodetab
		stack_relais type:#nodetab tabSizeVariable:true 
		)
	
	rollout multi_parent "Multi Constraints v.0.03" 
	( 

-- 		function
		function createRelaisControlFN sel newParent =
		(
			ctrTemp =  Star radius1:10 radius2:12 fillet1:0 fillet2:0 numPoints:12 distort:0 \
			rotation: sel.rotation position: sel.position \
			wirecolor:  sel.wirecolor parent: newParent name: (sel.name + "_linkTo_" + newParent.name )
			
			ctrTemp  = converttosplineshape ctrTemp
			updateshape ctrTemp
			
				-- création d'un helper à la position et la rotation du porteur
			ctrTempHlp = point size: 3  axistripod: false box: true cross: true \
			rotation: sel.rotation position: sel.position \
			wirecolor:  sel.wirecolor parent: ctrTemp name: (sel.name + "_linkTo_" + newParent.name + "_hlp" )
			
			-- copie du controleur spline 
			modSpline = copy sel
			modSpline = converttosplineshape modSpline
			updateshape modSpline
			
			-- copie du controleur relais 
			modRelais = copy ctrTemp
			modRelais = converttosplineshape modRelais
			updateshape modRelais

			-- transformation du controleur spline en controleur relais
			addandweld sel modRelais -1
			deletespline sel 1
			updateshape sel
			sel.name = sel.name + "_locked"
			
			-- transformation du controleur relais en controleur spline
			addandweld ctrTemp modSpline -1
			deletespline ctrTemp 1
			updateshape ctrTemp
			
			return ctrTempHlp
		)
		
		function freshParentListFN sel =
		(
			local stack_hlp_relais = sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais
			local parentsItemsArr = for o in stack_hlp_relais collect ((o.parent).parent).name
			return parentsItemsArr
		)
		
-- 		vars
		
		
-- 		UI
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
			spinner set_active "Set Influence" range:[0,100,1] type: #float
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
			button Hide_other "Hide Others"
			button Show_other "Show All"
		)
		
		group "destroy"
		(
			button DestroyModBT "Destroy"
		)
			
		-- Variables
		local sel = $
		local ctr_temp
		local ctr_temp_hlp
		local	worldPoint		
	
			
	-- ACTIONS
				
		on multi_parent open do
		(
			-- vérifier le parent de lobjet sélectionné
			-- déterminatiion du premier parent 
			-- prévoir de copier les controleurs de position et de rotation du premier relais
			
			print sel.parent
			if sel.parent == undefined then 
			(
				-- vérifier  que l'objet "world" est présent dans la scène si il n'existe pas le créer
				if (getnodebyname "worldPoint") == undefined	then 
				(
					firstParent = point name: "worldPoint"
					print "je viens de créer le world"
				)
				else
				(
					firstParent = (getnodebyname "worldPoint")
					print "le world existait deja"
				)
			)
			else 
			(
				firstParent = sel.parent
				print "le parent n'est pas le world"
			)
			
			
			print firstParent
			
			-- vérifier s'il y a deja des données dans le cust attribute		
			if sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais.count > 0 then
			(
	-- 			vérifier que le parent de cette première donnée est le firstparent
				if (sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais[1].parent).parent == firstParent then
				(
					-- vérifier le contrôleur en position et rotation
					print " tout est en ordre "
				)
				else
				(
					print "c'est le bordel, casse tout"
				)
					-- et mettre à jour la liste
			)
			else
			(
				-- créer le premier relais par rapport au first parent et l'enregistrer
				FirstRelais = createRelaisControlFN sel firstParent
				-- et le stocker
				append sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais FirstRelais
				print	"c'est bon tu peux y aller maintenant"
				
				bakTrans =  copy sel.transform.controller
				FirstRelais.parent.transform.controller = bakTrans
				
				-- CREATION DE LA PARENTE MULTIPLE
				sel.position.controller = position_constraint ()
				sel.rotation.controller = orientation_constraint ()
				
				-- ajout du helper dans les controller constraint
				sel.position.controller.appendtarget FirstRelais 100
				sel.rotation.controller.appendtarget FirstRelais 100
				
				-- rendre les controleurs de poids animable
				loop_count = sel.position.controller.weight.count
				sel.position.controller.weight[loop_count].controller = bezier_float ()
				sel.rotation.controller.weight[loop_count].controller = bezier_float ()
			)
				
			parents.items = freshParentListFN sel
			
		)
	
		on parents selected oneParent do
		(
			set_active.value = sel.position.controller.weight[parents.selection].controller.value

		)

	-- creation d'un nouveau parent
		on add_active picked obj do
		(
			-- CREATION D'UN NOUVEAU RELAIS relais (helper avec controller spline) parent de l'objet contrainte à la position et à la rotation du porteur avec l'aspect des autres relais

			newParent = obj
			print newParent
			
			-- selectionner un objet auquel se lier
			-- dupliquer le controleur spline de départ 
	-- 		s_name = substituteString $.name "_locked" ""
			ctrTemp = copy sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais[1].parent 
			ctrTemp.name =  (substituteString sel.name "_locked" "") + "_linkTo_" + obj.name
			ctrTemp.wirecolor = sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais[1].parent.wirecolor
			ctrTemp.parent = obj
			-- créer le helper relais
			-- linker le  helper au controleur spline
			-- linker la spline  au parent selectionné
			ctrTempHlp = point size: 3  axistripod: false box: true cross: true \
			rotation: sel.rotation position: sel.position \
			wirecolor:  sel.wirecolor parent: ctrTemp name: (ctrTemp.name + "_hlp" )
			
			-- ajouter du helper dans le stack relais		
			append sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais ctrTempHlp
			
			parents.items = freshParentListFN sel
			
			-- appliquer les contrainte position et rotation au controleur locked
			
			-- CREATION DE LA PARENTE MULTIPLE
			sel.position.controller = position_constraint ()
			sel.rotation.controller = orientation_constraint ()
			
			-- ajout du helper dans les controller constraint
			sel.position.controller.appendtarget ctrTempHlp 0
			sel.rotation.controller.appendtarget ctrTempHlp 0
			
			-- rendre les controleurs de poids animable
			loop_count = sel.position.controller.weight.count
			sel.position.controller.weight[loop_count].controller = bezier_float ()
			sel.rotation.controller.weight[loop_count].controller = bezier_float ()
			
			
			-- ANIMATION DES POIDS DES PARENTS
			-- une frame avant la frame où le nouveau parent est pické créer un clef d'animation sur tous les poids à la position où il sont
			for i = 1 to loop_count do
			(
				addNewKey sel.position.controller.weight[i].controller (slidertime - 1)
				addNewKey sel.rotation.controller.weight[i].controller (slidertime - 1)
			)
			
			-- à la frame où le nouveau parent est pické mettre le poids du nouveau parent à 100 et tous les autres à 0
			animate on at time slidertime sel.position.controller.weight[loop_count].controller.value = 100
			animate on at time slidertime sel.rotation.controller.weight[loop_count].controller.value = 100
			
			for i = 1  to ( loop_count - 1) do animate on at time slidertime sel.position.controller.weight[i].controller.value = 0
			for i = 1  to ( loop_count - 1) do animate on at time slidertime sel.rotation.controller.weight[i].controller.value = 0
		)
	
	-- creation d'une nouvelle clef d'animation des poids des parents
		on active_parent pressed do
		(
			-- collecter le relais selectionné
			num_select = sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.multi_parent.parents.selection
			actived_relais = sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais[num_select].parent

			-- deplacer le relais selectionner à la position courante du porteur en animant le déplacement sur une frame
			addNewKey actived_relais.rotation.controller (slidertime - 1)	
			addNewKey actived_relais.position.controller (slidertime - 1)
			
			animate on
			(
				at time slidertime actived_relais.rotation = sel.rotation
				at time slidertime actived_relais.position = sel.position
			)

		-- à la frame précedente créer une clef d'animation pour conserver les poids
			loop_count = sel.position.controller.weight.count
			for i = 1 to loop_count do
			(
				addNewKey sel.position.controller.weight[i].controller (slidertime - 1)
				addNewKey sel.rotation.controller.weight[i].controller (slidertime - 1)
			)
			
		-- à la frame où le bouton est pressé porter le poids du parent selectionner à 100 et le poids des autres à 0

			for i = 1  to ( loop_count) do animate on at time slidertime sel.position.controller.weight[i].controller.value = 0
			for i = 1  to ( loop_count) do animate on at time slidertime sel.rotation.controller.weight[i].controller.value = 0
			
			animate on at time slidertime sel.position.controller.weight[num_select].controller.value = 100
			animate on at time slidertime sel.rotation.controller.weight[num_select].controller.value = 100
		)

		on go_to_relais pressed do
		(
			-- collecter le relais selectionné
			num_select = sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.multi_parent.parents.selection
			actived_relais = sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais[num_select].parent
			
			-- à la frame précedente créer une clef d'animation pour conserver les poids
			loop_count = sel.position.controller.weight.count
			
			for i = 1 to loop_count do
			(
				addNewKey sel.position.controller.weight[i].controller (slidertime - 1)
				addNewKey sel.rotation.controller.weight[i].controller (slidertime - 1)
			)
			
		-- à la frame où le bouton est pressé porter le poids du parent selectionner à 100 et le poids des autres à 0

			for i = 1  to ( loop_count) do animate on at time slidertime sel.position.controller.weight[i].controller.value = 0
			for i = 1  to ( loop_count) do animate on at time slidertime sel.rotation.controller.weight[i].controller.value = 0
			
			animate on at time slidertime sel.position.controller.weight[num_select].controller.value = 100
			animate on at time slidertime sel.rotation.controller.weight[num_select].controller.value = 100

		)
	
		on up_name pressed do
		(	
			-- rafraichit les noms en fonction de leur changement 
			parents.items = freshParentListFN sel
		)
			
		on Hide_other pressed do
		(
			-- collecter le relais du parent selectionner dans le modifier
			num_select = sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.multi_parent.parents.selection
			actived_relais = sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais[num_select].parent
			-- récupérer la couleur normale du relais
			total_relais_hlp =  sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais
			total_relais = for o in total_relais_hlp collect o.parent
			total_color = for o in total_relais collect o.wirecolor
			good_color = #()
			for o in total_color do if o != (color 150 150 150) do append good_color o

			-- appliquer au relais selectionner la couleur normale du relais
			actived_relais.wirecolor = good_color[1]
			actived_relais.scale = [ 1 , 1 , 1 ]
			-- collecter les autres relais du porteur
			sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais.count
			total_relais_hlp =  sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais
			others_relais = for o in total_relais_hlp collect o.parent
			deleteitem others_relais num_select
			-- passer le wirecolor des autres relais en gris
			for o in others_relais do 
				(
					o.wirecolor =  (color 150 150 150)
					o.scale = [ 0.6 , 0.6 , 0.6]
				)
			-- prévoir un message d'erreur quand aucun parent n'est selectionné
		)
	
		on Show_other pressed do
		(
			-- récupérer la couleur normale du relais
			total_relais_hlp =  sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais
			total_relais = for o in total_relais_hlp collect o.parent
			total_color = for o in total_relais collect o.wirecolor
			good_color = #()
			for o in total_color do if o != (color 150 150 150) do append good_color o
			
			-- passer tous les relais de la bonne couleur
			for o in total_relais do 
			(
				o.wirecolor =  good_color[1]
				o.scale = [ 1 , 1 , 1 ]
			)	
		)
	
		on DestroyModBT pressed do
		(
			if 2 > 1 then print "youpi"
			-- récupérer le premier contrôleur
			relaisArr = for o in sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais collect o
			relaisNum = relaisArr.count
			firstCtrl = relaisArr[1].parent
			
			sel.position.controller = position_XYZ ()
			sel.rotation.controller = Euler_XYZ ()
			sel.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais = #()
			
			-- ramener le premier controlleur à la position et à la rotation du controleur locked
			firstCtrl.rotation = sel.rotation
			firstCtrl.position = sel.position
			
			-- renommer le premier controlleur comme le controleur locked
			firstCtrl.name = (substituteString sel.name "_locked" "")
			
			-- selectionner tous les enfants du controleur locked 
			objToReParentArr = sel.children 
			
			-- les lier au premier controleur
			for o in objToReParentArr do o.parent = firstCtrl
			
			-- supprimer tous les autres controleur créés
			if relaisNum > 1 then 
			(
				print "oiuhom"	
				for i = 2 to relaisNum do delete relaisArr[i].parent
			)
			
			-- supprimer tous les helpers
			for o in relaisArr do delete o

			-- supprimer le controleur locked
			
			delete sel
			select  firstCtrl
			
-- 	 		deleteModifier $ 1
			
		)
		
	)
)

modPanel.addModToSelection (emptymodifier ()) ui:on
custAttributes.add $.modifiers[#'Attribute Holder'] def

/*	
$.modifiers[#'Attribute Holder'].multi_constraints_in_the_air.multi_constraint.constraints.selection
$.modifiers[#'Attribute Holder'].multi_constraints_in_the_air.stack_constraints
*/
-------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
	
/*
-- MULTIPARENT RECOVER

num_constraints = $.position.controller.getNumTargets ()
parents_list = for i = 1 to num_constraints collect $.position.controller.getNode i
	
$.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais = parents_list
	*/
