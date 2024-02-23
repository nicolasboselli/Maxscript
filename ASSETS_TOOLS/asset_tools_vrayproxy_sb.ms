
/*-- asset vrmesh creator
-- exploser tous les groupes 
-- wer toutes les meshes
-- exporter le vrmesh
-- exporter le materiaux
*/

sel = selection as Array
maxOps.CloneNodes sel cloneType: #copy  newNodes: &copySel
select copySel
 
meshFileName = maxFilePath  + (getFilenameFile maxFileName )
vrayProxies = vrayMeshExport meshFile:meshFileName autoCreateProxies: true exportMultiple: false createMultiMtl: true 

vrPoxyMat = materialLibrary  vrayProxies[1].material
saveTempMaterialLibrary vrPoxyMat (meshFileName + ".vrmesh.mat")

select vrayProxies
