try (destroydialog clientRenderOutputRLT)catch()
rollout clientRenderOutputRLT "clients render output"
(
	group "Clients"
	(
		listbox clientsLB "clients:"
		button addClientBT "add" across:2
		button delClientBT "del"
	)
	group "Image Type"
	(
		listbox imageTypeLB "type:"
		button addTypeBT "add" across:2
		button delTypeBT "del"
	)
	edittext sizeET "size:" readonly: true
	button applyBT "apply"
)
createdialog clientRenderOutputRLT