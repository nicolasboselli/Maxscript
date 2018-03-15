eye = $

hlpEyeRoot = point name:(uniquename "hlp_eye_root") size:(units.decodeValue "4cm") \
cross: false box: true axistripod: false wirecolor: green rotation: eye.rotation position: eye.position

hlpEye = point name:(uniquename "hlp_eye_root") size:(units.decodeValue "2cm") \
cross: false box: false axistripod: true wirecolor: green rotation: eye.rotation position: eye.position parent: hlpEyeRoot


eye.parent = hlpEye

hlpEyeCtrRoot = point name:(uniquename "hlp_eye_ctr_root") size:(units.decodeValue "4cm") \
cross: true box: false axistripod: false wirecolor: green rotation: eye.rotation position: (eye.position + [20,0,0])

hlpEyeCtr = point name:(uniquename "hlp_eye_ctr") size:(units.decodeValue "2cm") \
cross: true box: true axistripod: false wirecolor: green rotation: eye.rotation parent: hlpEyeCtrRoot position: hlpEyeCtrRoot.position

hlpEye.rotation.controller.x_rotation.controller = bezier_float ()
hlpEye.rotation.controller.y_rotation.controller = bezier_float ()
hlpEye.rotation.controller.z_rotation.controller = bezier_float ()

hlpEye.rotation.controller.x_rotation.controller = float_script ()
hlpEye.rotation.controller.y_rotation.controller = float_script ()
hlpEye.rotation.controller.z_rotation.controller = float_script ()

hlpEye.rotation.controller = rotation_script ()
hlpEye.rotation.controller.addnode "helpEye" hlpEyeCtr
hlpEye.rotation.controller.addnode "helpEyeRoot" hlpEyeCtrRoot

hlpEyeScript = stringstream  ""
format "( eulerAngles ((in coordsys helpEyeRoot helpEye.pos.y)*-10) ((in coordsys helpEyeRoot helpEye.pos.x)*10) 0 ) " to: hlpEyeScript

hlpEye.rotation.controller.script = hlpEyeScript as string

crtEyeRoot = circle name:(uniquename "ctrEyeRoot") wirecolor: yellow rotation:  hlpEyeCtrRoot.rotation position: hlpEyeCtrRoot.position radius: (units.decodeValue "4cm")
crtEye = circle name:(uniquename "ctrEye") wirecolor: yellow rotation:  hlpEyeCtr.rotation position: hlpEyeCtr.position radius: (units.decodeValue "2cm") parent: crtEyeRoot

hlpEyeCtrRoot.parent =  crtEyeRoot

hlpEyeCtr.parent = crtEye