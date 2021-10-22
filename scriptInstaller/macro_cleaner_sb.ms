-- macrosFolder = @"C:\Users\Visiolab\AppData\Local\Autodesk\3dsMax\2022 - 64bit\ENU\usermacros"

-- parse du dossier des scripts
allMacrosAr = getFiles ((GetDir #maxData) + "usermacros\\*")
for m in allMacrosAr do
(
	if MatchPattern (filenameFromPath m) pattern: "*Visiolab*" ignoreCase: false then
	(
		if (deleteFile m) then 	format "deleted: %\n" m
	)
)