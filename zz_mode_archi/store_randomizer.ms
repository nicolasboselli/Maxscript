$.modifiers[#Morpher][1].value = 100

s = $ as array
ouverture = #(0, 0, 50, 50, 100)


for o in s do
(
	o.modifiers[#Morpher][1].value = ouverture[random 1 5]
)

