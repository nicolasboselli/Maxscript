-- Suivi Mr cust Render

-- MR matte render: 
	-- permet de faire des rendus en matte shadows de la selection, 
	-- parametrage du material matte

-- MR_render_without_selection : permet de faire un rendu sans la selection

-- MR_alpha_rendu : 
	-- permet de faire un rendu en blanc de la selection
	-- permet de prendre en compte la transaprence ou les couche d'alpha
	
-- MR_alpha_by material : 
	-- permet de faire un rendu de chaque materiau de la scene en blanc, 
	-- ou de chaque materiaux de la selection 
	-- ou du materiaux selectionné dans l'éditeur de materiaux
	-- ou des materiaux présent dans l'éditeur
	-- fonctionne sur les materiaux dans un mu:lti material
	
-- MR_zdepht: crée une passe de zdepth à partir de réglage sur la camera
-- MR_occlu: crée une passe d'occlu, permet de régler directement le materiau

-- amélioration: 
-- intégrer les differents rollout dans une fenetre unique
-- intégrer directement dans l'UI des fonction de la boite de dialogue du rendu (chemin d'enregistrement, taille de l'image, rendu region, netrender, render elements)