
for o in geometry where matchpattern o.name pattern: "A_FruitRegimePimentBanane_Banane*_LO" do
(
	mdlName = substituteString o.name "LO" "MDL"
	mdl = getnodeByName mdlName
	format "lo: %, mdl: %, parent:% \n" o.name mdl.name o.parent.name
	mdl.parent = o.parent
)


