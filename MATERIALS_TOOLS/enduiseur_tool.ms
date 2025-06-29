/*
-- crée le shader d'enduit par MAXScript
-- collecte le sous materiau d'un multi sub avec un Picker
-- permet de changer la couleur de l'nduit avec un color picker

*/

macroScript Box category:"Objects" tooltip:"Box"
icon:#("standard", 1) -- use first icon in standard
(
	on isChecked do  StartObjectCreation Box
)
