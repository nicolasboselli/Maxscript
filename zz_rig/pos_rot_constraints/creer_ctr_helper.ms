-- CREATE CONTROL HLPER

hlp = $

ctr_hlp = circle name: (uniquename "ctr_hlp") radius: 5 rotation: hlp.rotation pos: hlp.pos

hlp.controller.pos.controller = position_xyz ()
hlp.controller.pos.controller = position_constraint ()
hlp.controller.pos.controller.constraints.appendTarget ctr_hlp 100

hlp.controller.rotation.controller = Euler_XYZ ()
hlp.controller.rotation.controller = Orientation_Constraint ()
hlp.controller.rotation.controller.constraints.appendTarget ctr_hlp 100 