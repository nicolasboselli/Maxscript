clearselection()

for s in $* do
(
	if s.material == meditmaterials[activeMeditSlot] then
	(
		selectmore s
	)
	else
	(
		s.ishidden = true
	)
)