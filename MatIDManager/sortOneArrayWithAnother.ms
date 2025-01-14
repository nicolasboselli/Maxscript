idsArInit = #(0,2,4,6,8,10,45,50,55)
labelsArInit = #("none", "Vitres", "Menuiserie" , "Cloture", "GC", "Haies", "Habillage", "Herbe", "Arbres")

-- sort id by labels order
-- fonction de classement par nom
fn sortByName label1 label2 =
(	
	if (toupper label1) > (toupper label2) then  1
 	else if (toupper label1) < (toupper label2) then  - 1
 	else  0 
)


fn sortBothArray labelsArInit idsArInit =
(
	-- création de l'array de travail des labels
	labelsAr = for o in labelsArInit collect o
	sort labelsAr

	-- création de l'array de travail des ids
	idsAr = #()
	-- classement des ids par label
	for i = 1 to labelsAr.count do
	(
		newPlace = finditem labelsAr labelsArInit[i]
		idsAr[newPlace] = idsArInit[i]
	)
)
sortBothArray labelsArInit idsArInit


-- sort label par ordre d'id
idsAr = for o in idsArInit collect o
sort idsAr

-- création de l'array de travail des ids
labelsAr = #()
-- classement des lables par ids
for i = 1 to idsAr.count do
(
	newPlace = finditem idsAr idsArInit[i]
	labelsAr[newPlace] = labelsArInit[i]
)	

idsAr
labelsAr