
libArchiPath = @"M:\Textures\VisioLab - Architecture_V2025.mat"
doesFileExist libArchiPath
libVisioPath = @"M:\Biblio\VISIOLAB\3-Materials\VISIOLAB_MATLIB.mat"
doesFileExist libVisioPath
libTomPPath = @"M:\Biblio\VISIOLAB\3-Materials\LIB TOM.P.mat"
doesFileExist libTomPPath


libArchi = loadTempMaterialLibrary libArchiPath
libVisio = loadTempMaterialLibrary libVisioPath
libTomP = loadTempMaterialLibrary libTomPPath

-- libArchi[]

/* 
matNamesList = #( "SOL-EXT_HERBE_Fleurie_300_", \
	"VERRE_VITRAGE", \
	"ENDUIT_200_GEN_De loin", \
	"dalle_sur_plot_grise", \
	"Asphalte_TOM", \
	"Beton Balayé"
)


for i = 1 to matNamesList.count do 
(
	meditMaterials[i] = libVisio[matNamesList[i]]
) */



meditMaterials[1] = libArchi["Beton Balayé"]
meditMaterials[2] = libArchi["dalle_sur_plot_grise"]

meditMaterials[3] = libVisio["ENDUIT_200_GEN_De loin"]
meditMaterials[4] = libVisio["SOL-EXT_HERBE_Fleurie_300_"]
meditMaterials[5] = libVisio["VERRE_VITRAGE"]

meditMaterials[6] = libTomP["Asphalte_TOM"] 

meditMaterials[7] = libArchi["Evergreen"]

meditMaterials[8] = VRayMtl name: "beton_blanc" Diffuse: (color 225 225 225)

meditMaterials[9] = libArchi["Gravier #1"]

meditMaterials[10] = libVisio["METAL_TOITURE_ZINC_001"]

meditMaterials[11] = libVisio["BETON_bordure-ciment_150_"]


meditMaterials[12] = libTomP["BRIQUE_PLAQUETTE_200_28x5_rouge_02"] 

meditMaterials[13] = libVisio["BOIS_Bardage_Brut_200_A"]

-- "BRIQUE_PLAQUETTE_200_28x5_rouge_02"


-- beton matrice
-- tuile
-- bois