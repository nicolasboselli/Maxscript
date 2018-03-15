sizze = 160

sel = selection as array

for s in sel do
(
	s.modifiers[#UVW_Mapping].length = sizze
	s.modifiers[#UVW_Mapping].width = sizze
	s.modifiers[#UVW_Mapping].height = sizze
)