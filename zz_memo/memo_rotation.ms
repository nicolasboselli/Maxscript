rot_target  = in coordsys $root $target.rotation as angleaxis
	
rot_target.z

in coordsys $root $.rotation =  (angleAxis 360 [0,0,-1])

rot_temp = $.rotation as angleaxis
in coordsys parent $.rotation as angleaxis
in coordsys $root2 $.rotation as angleaxis
$.rotation = (angleAxis 360 [0,0,-1])

in coordsys parent  $.rotation

rot_temp.numrevs

rot_temp.axis.z

$.transform