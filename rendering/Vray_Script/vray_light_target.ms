vrl =$

-- newTarget = dummy boxsize:[20,20,20] pos: vrl.position
newTarget = targetobject boxsize:[20,20,20] pos: vrl.position wirecolor: vrl.wirecolor

in coordsys vrl move newTarget [0,0,-50]

targetCtrl =  rotation_list ()
targetCtrl.Available.controller = LookAt_Constraint ()
targetCtrl[1].appendTarget newTarget 1
targetCtrl[1].target_axis = 2
targetCtrl[1].target_axisFlip = on
targetCtrl[1].upnode_axis = 2
targetCtrl[1].viewline_length_abs = off


vrl.rotation.controller = Euler_XYZ ()
vrl.rotation.controller = targetCtrl
targetCtrl.weight[2]= 0

