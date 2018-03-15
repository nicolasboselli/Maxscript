fn preSaveClean =
(
	format "presave script done!\n"
)

callbacks.addScript #filePreSave "preSaveClean()" id:#cleanSave

-- callbacks.removeScripts id:#cleanSave

-- callbacks.show #filePreSave id:#cleanSave