sel = geometry as array
for s in sel where matchpattern s.name pattern: "A_BalaiA_Algue?_MDL*" do
(
	tmpname = substituteString s.name "_MDL" ""
	tmpname = tmpname + "_MDL"
	print tmpname
	s.name = tmpname
)

algue = $
InstanceMgr.GetInstances algue &instances
select instances