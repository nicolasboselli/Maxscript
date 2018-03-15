plugin modifier myMod

name:"Supa Mod"

classID:#(685325,452281)

extends:Bend replaceUI:true version:1

( 

parameters main rollout:params

(

bendamt type:#float animatable:true ui:bendamt default:0.0

on bendamt set val do delegate.angle = val

)

rollout params "SupaMod Parameters"

(

spinner bendamt "Bendiness: "

)

)

---------------------------------------------------------------------------

def = attributes boton

(
	parameters main rollout:free_elbow ()
	
	rollout free_elbow "free elbow!" width:162 height:300 
	( 
		checkButton ckb1 "liberer le coude!"pos:[32,56] width:105 height:54
		 
		on ckb1 changed state do 

			if state == on then 
			(
				yo = openfile rd_name
				execute yo 

				ya = openfile "free_elbow_on.ms"
				execute ya
			)
			
			else
			(
				yo = openfile rd_name
				execute yo 
	
				ya = openfile "free_elbow_off.ms"
				execute ya
			)	
	)
)
select cercle[1]
modPanel.addModToSelection (emptymodifier ()) ui:on
custAttributes.add $.modifiers[#'Attribute Holder'] def






modPanel.addModToSelection (mymod ()) ui:on