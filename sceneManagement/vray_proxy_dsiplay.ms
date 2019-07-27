for o in geometry where iskindof o vrayproxy do
(
	format "vrayproxy: %\n" o
	o.display = 0
)
