
/*
voletsAr = #()
for o in helpers do
(
	res = getUserProp o "voletRoulant"
	
	if res == undefined then continue
	else if not res then continue
	
	format "res: %\n" res
	append voletsAr o
-- 	try ()catch(false) collect o
)
-- delete voletsAr


-- superclassof $

-- for h in helpers where iskindof h dummy


custAttributes.count $
ca = custAttributes.get $ 1
custAttributes.delete $ 1






$.ouverture_volet.voletRLT.openingSP.value = 80
s = $volet_roulant_034
$.ouverture_volet.vheight
$.ouverture_volet
*/


oneBox = $

voletMod = EmptyModifier name: "Ouverture_Volet"

the_attributes = attributes volets_attributes
(

	Parameters main rollout:voletRLT
	(
		openVal Type: #integer UI:openingSP Default:75
		vheight type: #integer  Default:200
		lamesize type: #integer  Default:5
		voletName type: #string Default: "ploufe"
	)
	
	
 	rollout voletRLT "parametres:"
	(
		local oneArrayMod 
		
		spinner openingSP "Ouverture (%)"  range:[0, 100, 0]  type:#integer
		button testBT "test"
		
		
		fn findArrayMod =
		(
			local res = getnodebyname voletName
			format "res: %\n" res
		)
		
		on voletRLT open do
		(
			findArrayMod()
-- 			$.modifiers[#Array].countZ = ((((( 100 - openVal ) * vheight )/100)/lamesize) as integer)
		)
		
-- 		on testBT pressed do
-- 		(
-- 			local oneArrayMod 
-- 			test = refs.dependents this
-- 			test2 = refs.dependents test[1]
-- 			for t in test2 do
-- 			(
-- 				if iskindof t Arraymodifier then 
-- 				(
-- 					oneArrayMod = t
-- 					format "test: %\n" t (classof t)
-- 					t.countz = random 5 10
-- 				)
-- 			)
-- 		)
		
		on openingSP changed val do
		(
			oneArrayMod.countZ = (((((100 - val)*vheight)/100)/lamesize) as integer)
-- 			$.modifiers[#Array].countZ = (((((100 - val)*vheight)/100)/lamesize) as integer)
		)
	)
)

custAttributes.add voletMod the_attributes
addModifier onebox voletMod

oneBox.ouverture_volet.voletName = onebox.name



oneBox = $
oneBox.ouverture_volet.voletRLT.findArrayMod()
$.ouverture_volet.voletRLT.findArrayMod()
$


$.ouverture_volet.voletName
-- oneBox.ouverture_volet.oneArrayMod = $
 
-- onebox.Ouverture_Volet.v = $

-- voletMod.openVal = 10
-- voletMod.v = $
-- voletMod.vheight = 200
-- voletMod.lamesize = 5






