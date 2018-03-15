-- list skin bones

oneSkin = $.modifiers[#skin]
showproperties oneSkin

skinOps.GetBoneName oneSkin 1000 1


-- symetrize modeling -x to +x (left to right)

-- script action: save base mesh
-- (test symetry)

-- actions: make modification

-- vars
-- base_mesh
-- modified_mesh
-- modif_rig  (base_mesh)
-- L_modif (copy modified mesh)
-- R_modif (copy base mesh)

-- script action:
	-- modif rig
		-- copy base_mesh as modif_rig
		-- copy modified_mesh as L_modif
		-- morpher on modif_rig + L_modif as morph target
		-- flip modif_rig
		
		-- copy base_mesh as R_modif
		-- add skin wrap on R_modif
		-- add modif_rig on skin_wrap
		-- set on face modification
		-- push morpher on modif_rig
		-- collapse as R_modif
		-- delete modif_rig
		
		-- add morpher on  mesh_modified
		-- select vertex on right side (+x) of R_modif 
		-- add  R_modif target
		-- select selection vertex only
		-- push morpher
		
-- actions: adjust mesh


-- script: replace base mesh