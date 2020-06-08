fn unHideLayerHierarchy oneLayer =
(
	local lar = #(oneLayer)

	for l in lar do
	(
		dad = l.getparent()
		if iskindof dad MixinInterface then append lar dad
	)

	for l in lar do l.on = true
)
