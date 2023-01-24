try(destroydialog ui_imgtag)catch()
rollout ui_imgtag "imgtag"
(
   local bm = bitmap 100 100 color:red
   imgtag img_tag "imgtag" bitmap:bm align:#center
   fn printButtonStates Flags =
   (
   LMB = bit.get Flags 1
   RMB = bit.get Flags 2
   SHIFT = bit.get Flags 3
   CTRL = bit.get Flags 4
   MMB = bit.get Flags 5
   XB1 = bit.get Flags 6
   XB2 = bit.get Flags 7
   format "LMB:% MMB:% RMB:% SHIFT:% CTRL:% XB1:% XB2:%\n" LMB MMB RMB SHIFT CTRL XB1 XB2
   )
--    on img_tag lbuttondown v1 v2 do printButtonStates v2
   on img_tag mbuttondown v1 v2 do printButtonStates v2
   on img_tag rbuttondown v1 v2 do printButtonStates v2
	   
   on img_tag lbuttondown p1 p2 do 
   (
	  format "p1: % p2: % \n" p1 p2
   )
)
createdialog ui_imgtag width:200