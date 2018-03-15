-- à l'application du modifier: 
	-- backup de l'animation du porteur
	-- remplace les controllers de position et de rotation du porteur par des controllers contraintes
	-- crée un relais (controleur spline et helper) parente avec le parent du porteur à la position et à la rotation du porteur
	-- application du modifier
	def = attributes multi_constraints_in_the_air

(
	parameters main rollout:multi_constraint (
		-- ajouter la nouvelle cible dans les constraint controller et dans le rollout
		-- création de parameter nodetab
		stack_constraints type:#nodetab tabSizeVariable:true 
		)
	
	rollout multi_constraint "Multi Constraints" 
	( 
		group "List Constraints"
			(
			-- un rollout pour memoriser les parents
			listBox constraints "Constraints"  height:10 items: #()
			-- un bouton pour update name
			button up_name "Update Names" 
			-- un bouton ajouter et activer le parent
			)
	
		group "Set Constraints"
			(
			-- un bouton pour picker le parent
			Pickbutton  add_active "Add and Active New Constraint"
			-- un bouton pour activer le parent
			button active "Active Constraint"
			-- un spinner pour regler l'influence du parent
			spinner set_active "Set Influence" 
			)
			
		group "Show Constraints"
			(
			-- show relais
			button show_relais "Show the Relais"
			-- show parent
			button show_parent "Show the Parent"
			)
			
	-- Variables

			
			
	-- ACTIONS
	
			
	on add_active picked obj do
	(
	-- crée une cible (helper avec controller spline) parente du parent à la position et à la rotation du porteur
	-- ajouter la nouvelle cible dans les constraint controller 
	-- ajouter la cible dans le stack constraint
	append $.modifiers[#'Attribute Holder'].multi_constraints_in_the_air.stack_constraints obj
	constraints.items = for i = 1 to stack_constraints.count collect stack_constraints[i].name
	)

	on up_name pressed do
	(	
	-- rafraichit les noms en fonction de leur changement 
	constraints.items = for i = 1 to stack_constraints.count collect stack_constraints[i].name
	)
			
	
	)
)

modPanel.addModToSelection (emptymodifier ()) ui:on
custAttributes.add $.modifiers[#'Attribute Holder'] def

/*	
$.modifiers[#'Attribute Holder'].multi_constraints_in_the_air.multi_constraint.constraints.selection
$.modifiers[#'Attribute Holder'].multi_constraints_in_the_air.stack_constraints
*/

	-- ajouter la nouvelle cible dans les constraint controller et dans le rollout
		-- création de parameter nodetab
	-- collage de l'animation du porteur sur la source
	
-- interface graphique (un modifier avec)
---- un rollout pour memoriser les parents
	-- updater le rollout par rapport au node tab
---- un bouton pour update name
	-- rafraichit les noms en fonction de leur changement 
---- un bouton ajouter et activer le parent
	-- lorqu'on selecttionne un objet et qu'on clique sur ce bouton:
		-- crée une cible (helper avec controller spline) parente du parent à la position et à la rotation du porteur
		-- ajouter la nouvelle cible dans les constraint controller et dans le rollout
---- un bouton pour activer le parent
	-- monte l'influence du parent selectionner à 100% en créant une clef d'animation
---- un spinner pour regler l'influence du parent
	-- permet de régler l'influence d'un parent, animable
	
---- show relais
	-- selectionne dans le viewport le relais du parent selectionné dans le rollout
---- show parent
	-- selectionne dans le viewport le parent selectionner dasn le rollout

