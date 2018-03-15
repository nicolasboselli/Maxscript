s = $
robot_root = 50
robot_root = $robot_root
robot_root.scale.x

$.transform.controller.FK_Sub_Control.controller.position.controller.x_position.controller.addnode "scale_root" $robot_root
s.position.controller.x_position.controller.addnode "scale" $robot_root
$..controller.addnode "scale_root" $robot_root


$Circle028.modifiers[#Attribute_Holder].Custom_Attributes.scale/100

distance $robot_hlp_L_poignet $robot_hlp_L_epaule

distance $robot_hlp_R_poignet $robot_hlp_R_epaule


66*0.75