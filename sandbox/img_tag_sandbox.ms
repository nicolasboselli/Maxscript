
try(destroydialog imgTagRLT)catch()

rollout imgTagRLT "img Tag Rollout"
(
	
	-- the_bmp = bitmap 200 200 color: red --filename:  @"M:\Biblio\VISIOLAB\8-Scripts\Production\Maxscript\MATERIALS_TOOLS\load_ral.jpg" 
	imgTag testImpTag "test"  bitmap: ( bitmap 300 300 color: red ) align: #center -- [opacity:<float>] [transparent:<color>] [iconName:<filename>] [iconSize:<point2>]	 [ applyUIScaling:<bool> ]
	
 	on testImpTag mousedown do
	(
		format "mousedown\n"
	) 
	
	on testImpTag lbuttondown p2 fl do
-- 	on testImpTag mouseover  p2 fl do
	(
		format "v1: % v2: %\n" p2 fl
	) 
)
CreateDialog imgTagRLT 500 500


 /* 
rcmenu MyRCmenu
(
	menuItem mi_cs "First Option" checked:false
	menuItem mi_rs "Second Option" checked:false
)

rollout ui_items "ui items"
(
	button a2 "button"
	on a2 rightClick do print a2
	checkbutton a4 "checkbutton"
	on a4 rightClick do print a4
	local bm = bitmap 50 50 color:red
	imgtag b5 "imgtag" bitmap:bm align:#center
	on b5 mousedown v1 v2 do
	format "% ; % ; % ; %\n" b5 #mousedown v1 v2
	on b5 lbuttondown v1 v2 do
	format "% ; % ; % ; %\n" b5 #lbuttondown v1 v2
	on b5 mbuttondown v1 v2 do
	format "% ; % ; % ; %\n" b5 #mbuttondown v1 v2
	on b5 rightClick v1 v2 do
	format "% ; % ; % ; %\n" b5 #rightClick v1 v2
	on b5 rbuttondown v1 v2 do
	format "% ; % ; % ; %\n" b5 #rbuttondown v1 v2
	on b5 mouseup v1 v2 do
	format "% ; % ; % ; %\n" b5 #mouseup v1 v2
	on b5 click v1 v2 do
	format "% ; % ; % ; %\n" b5 #click v1 v2
	on b5 lbuttonup v1 v2 do
	format "% ; % ; % ; %\n" b5 #lbuttonup v1 v2
	on b5 mbuttonup v1 v2 do
	format "% ; % ; % ; %\n" b5 #mbuttonup v1 v2
	on b5 rbuttonup v1 v2 do
	format "% ; % ; % ; %\n" b5 #rbuttonup v1 v2
	on b5 dblclick v1 v2 do
	format "% ; % ; % ; %\n" b5 #dblclick v1 v2
	on b5 lbuttondblclk v1 v2 do
	format "% ; % ; % ; %\n" b5 #lbuttondblclk v1 v2
	on b5 mbuttondblclk v1 v2 do
	format "% ; % ; % ; %\n" b5 #mbuttondblclk v1 v2
	on b5 rbuttondblclk v1 v2 do
	format "% ; % ; % ; %\n" b5 #rbuttondblclk v1 v2
	on b5 mouseout v1 v2 do
	format "% ; % ; % ; %\n" b5 #mouseout v1 v2
	on b5 mouseover v1 v2 do
	format "% ; % ; % ; %\n" b5 #mouseover v1 v2
	mapbutton a11 "mapButton"
	on a11 rightClick do print a11
	materialbutton a12 "materialbutton"
	on a12 rightClick do print a12
	pickbutton a13 "pickbutton"
	on a13 rightClick do (print a13; popupmenu MyRCmenu)
)
createdialog ui_items width:100   */

