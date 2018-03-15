	--PREPARATION DU PORTEUR A LA PREMIERE UTILISATION
	
	-- backup de l'animation du porteur
	test = copy $.transform.controller
	
	-- crée un relais (controleur spline et helper) parente 
	rot_temp = $.rotation
	pos_temp = $.position
	ctr_color = $.wirecolor
	
	ctr_temp = circle radius: 10 rotation: rot_temp position: pos_temp wirecolor: ctr_color
	
	ctr_temp_hlp = point size: 3 rotation: rot_temp position: pos_temp axistripod: false box: true cross: true
	converttosplineshape ctr_temp
	updateshape ctr_temp
	
	ctr_temp_hlp.parent = ctr_temp
	
	-- parenter le relais au parent du porteur
		-- si le parent est l'univers														-- si le parent est un autre objet de la scene
	if $.parent == undefined then ctr_temp.parent = undefined else ctr_temp.parent = $.parent

	-- collage de l'animation du porteur sur le relais
	ctr_temp.transform.controller = test
	
	-- remplace les controllers de position et de rotation du porteur par des controllers contraintes
	$.position.controller = position_constraint ()
	$.rotation.controller = orientation_constraint ()
	
	-- ajoute le helper du relais  dans les contraintes
	$.position.controller.appendtarget ctr_temp_hlp 100
	$.position.controller.weight[1].controller = bezier_float ()
	$.rotation.controller.appendtarget ctr_temp_hlp 100
	$.rotation.controller.weight[1].controller = bezier_float ()
	
	-- changer l'aspect des controlleurs spline 
		-- donner l'aspect du porteur au relais
	copy_ctr = copy $
	converttosplineshape copy_ctr
	updateshape copy_ctr
	addandweld ctr_temp copy_ctr -1
	deletespline ctr_temp 1
	updateshape ctr_temp
	
		-- donner un aspect locker (star) ou porteur
	s = $
	lock_spline = Star radius1:5 radius2:4 fillet1:0 fillet2:0 numPoints:12 distort:0 rotation: rot_temp pos:pos_temp isSelected:on
	converttosplineshape lock_spline
	updateshape lock_spline
	addandweld s lock_spline -1
	updateshape s
	
	num_splines = numSplines s
	
	for i = 1 to ( num_splines - 1 ) do 
	(
		deletespline s 1
		updateshape s
	)
	
	updateshape s
	select s
	
	-- renommer  le nouveau controleur spline
	name_temp = $.name
	if ctr_temp.parent == undefined then ctr_temp.name = (uniquename (name_temp + "_world_relais")) else ctr_temp.name = (uniquename ( name_temp + "_" + ctr_temp.parent.name + "_relais"))
	
	-- renommer le helper du nouveau controleur spline
	ctr_temp_hlp.name = "hlp_" + ctr_temp.name
	
	-- renommer  le porteur
	$.name = name_temp + "_locked"
	


	
	-- ajouter le helper du nouveau relais dans le stack_relais
--append $.modifiers[#'Attribute Holder'].multi_parent_on_fly.stack_relais ctr_temp_hlp


	
-- creer un modifier recover pour recréer le modifier, si il est détruit, à partir des contraintes

