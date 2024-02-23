/*
maj: mettre une option ignore hidden

$.ishidden
*/

try(destroydialog vrayProxiesDisplayRLT)catch()
rollout vrayProxiesDisplayRLT "vray proxies display"
(
	group "display as:"
	(
		checkbox ignoreHiddenCB "ignore hidden objects" checked: true --enabled: false
		button BBoxBT "Bounding Box"
		button ProxyBT "Proxy"
		button MeshBT "Whole mesh"
	)
		
	on BBoxBT pressed do
	(
		for o in geometry where iskindof o vrayproxy do
		(
			if ignoreHiddenCB.state and o.ishidden then (format "ignore: %\n" o.name)
			else
			(
				format "vrayproxy: %\n" o
				o.display = 0
			)
		)
	)
	
	on ProxyBT pressed do
	(
		for o in geometry where iskindof o vrayproxy do
		(
			if ignoreHiddenCB.state and o.ishidden then (format "ignore: %\n" o.name)
			else
			(
				format "vrayproxy: %\n" o
				o.display = 3
			)
		)
	)
	
	on MeshBT pressed do
	(
		for o in geometry where iskindof o vrayproxy do
		(
			if ignoreHiddenCB.state and o.ishidden then (format "ignore: %\n" o.name)
			else
			(
				format "vrayproxy: %\n" o
				o.display = 4
			)
		)
	)
	
)
CreateDialog vrayProxiesDisplayRLT
