maxFilePath 
getFilenameFile maxFileName

assetPref = @"M:\Biblio\VISIOLAB\2-Assets3D"
texturePref = @"M:\Biblio\VISIOLAB\1-Textures\Assets3d"

dirPath = (substituteString maxFilePath  assetPref texturePref) + (getFilenameFile maxFileName)
makeDir dirPath

getDirectories @"M:\Biblio\VISIOLAB\1-Textures\Assets3d\Pers-Films\Objets\Amenagement\Exterieur\Terrasses\Mobilier\"
getDirectories dirPath recurse: true



dirPath == @"M:\Biblio\VISIOLAB\1-Textures\Assets3d\Pers-Films\Objets\Amenagement\Exterieur\Terrasses\Mobilier\"
M:\Biblio\VISIOLAB\1-Textures\Assets3d\Pers-Films\Objets\Amenagement\Exterieur\Terrasses\Mobilier\
M:\Biblio\VISIOLAB\1-Textures\Assets3d\Pers-Films\Objets\Amenagement\Exterieur\Terrasses\Mobilier