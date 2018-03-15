matAr = getclassinstances vrayMtl target: scenematerials

for i = 1 to matAr.count do
(
	format "%, %\n" i matAr[i].name
	matAr[i].effectsChannel = i
)

-- ajouter la couche vrayMtlID
	-- setter sur filtering et color