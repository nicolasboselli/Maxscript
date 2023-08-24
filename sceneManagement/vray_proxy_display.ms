
try(destroydialog vrayProxiesDisplayRLT)catch()
rollout vrayProxiesDisplayRLT "vray proxies display"
(
	group "display as:"
	(
		button BBoxBT "Bounding Box"
		button ProxyBT "Proxy"
		button MeshBT "Whole mesh"
	)
	
	
	on BBoxBT pressed do
	(
		for o in geometry where iskindof o vrayproxy do
		(
			format "vrayproxy: %\n" o
			o.display = 0
		)
	)
	
	on ProxyBT pressed do
	(
		for o in geometry where iskindof o vrayproxy do
		(
			format "vrayproxy: %\n" o
			o.display = 3
		)
	)
	
	on MeshBT pressed do
	(
		for o in geometry where iskindof o vrayproxy do
		(
			format "vrayproxy: %\n" o
			o.display = 4
		)
	)
	
)
CreateDialog vrayProxiesDisplayRLT