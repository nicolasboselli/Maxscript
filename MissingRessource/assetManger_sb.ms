-- asset manager
num = AssetManager.GetNumAssetUsers() 
num = AssetManager.GetNumAssets() 
GetNumAssets
-- val as integer 

for i = 1 to num do
(
	oneAsset  = AssetManager.GetAssetByIndex i
	format "% type: % id: %\n " i (oneAsset.GetType()) (oneAsset.GetAssetId())
)

AUIO = AssetManager.GetAssetByIndex 137
AID =AUIO.getAssetID()

AssetManager.ReleaseReference AID

AssetManager.AddReference AID
-- GetAssetId 
-- GetType() 

asset = AssetManager.GetAssetByIndex 137L
asset.getfilename()
asset
asset.GetFullFilePath()

showinterface AssetManager

-- meta data
getMAXFileAssetMetadata (getFilenameFile theMaxFile)

-- asset tracking
ATSOps.NumFiles() 
ATSOps.GetFiles  ()
ATSOps.NumFilesSelected()
ATSOps.NumProviders()

ATSCustomDepsOps.LaunchDialog() 

test = "toto"
classof $
&test
$* as array
-- class instance
vrayPoxyList = getclassinstances VRayProxy  -- target: ($* as array)

for v in vrayPoxyList do format "%\n" v.filename
