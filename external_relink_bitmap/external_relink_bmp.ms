f = @"M:\Interieur\Cellules\Modelisation\Library\Objects\meuble_tv.max"
metas = getMAXFileAssetMetadata f
for asset in metas do (format "%\n" asset)

-- showproperties
metas[1].type
metas[1].filename
metas[1].resolvedFilename