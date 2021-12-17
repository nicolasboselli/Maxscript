

tuilesColors = #("tuiles_brune", "tuiles vieilli_bourgogne", "tuiles panache_automne")

-- random 1 3
for h in helpers where doesUserPropExist h "isChildrenTransferPoint" do
(
	tmpMat = scenematerials[tuilesColors[(random 1 3)]]
	
	format "h:%\n" h.name
	hcAr = for hc in h.children collect hc
	for o in hcAr do
	(
		for oc in o.children do appendifunique hcAr oc
	)
	
	for s in hcar where iskindof s AvizstudioToolsATiles do 
	(
		s.material = tmpMat
		format "s:%\n" s.name 
	)
)

-- scenematerials[tuilesColors[(random 1 3)]]