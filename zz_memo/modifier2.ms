def = attributes test_test

(
	parameters main rollout:test (
		)
	
	rollout test "test" 
	( 
edittext prefix_txt "Name prefix:" fieldWidth:100 labelOnTop:true
on prefix_txt entered txt do
(
if txt != "" do
(
new_obj = box pos:(random [-100,-100,-100] [100,100,100])
new_obj.name = (uniquename txt)
prefix_txt.text = ""
)
)
slider sld1 "Slider" 
	)
)

modPanel.addModToSelection (emptymodifier ()) ui:on
custAttributes.add $.modifiers[#'Attribute Holder'] def