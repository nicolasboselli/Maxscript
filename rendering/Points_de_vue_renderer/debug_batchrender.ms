batch = batchRenderMgr.CreateView undefined
batch.name = "toto"
batch.camera = $cam01
filename = @"C:\Users\Visiolab\Desktop\test_batch_render\toto.jpg"  

makedir (getFilenamePath  filename)
batch.sceneStateName = "vue01"
batch.outputFilename = filename
format "new batch render: %\n" filename



c =  $cam01
oneName = "vue01"
outputPathMaq = @"C:\Users\Visiolab\Desktop\test_batch_render"

-- batchRenderMgr.FindView "view01"
batch = batchRenderMgr.GetView 1

batch = batchRenderMgr.CreateView c
-- oneBatchName = c.name + "_" + oneName
-- batch.name = oneBatchName
-- batch.camera = c

-- batch.sceneStateName = oneName

-- filename = outputPathMaq + "\\" + oneBatchName + "\\"+ oneBatchName + "_.jpg"
-- makedir (getFilenamePath  filename)
-- batch.outputFilename = filename
batch.outputFilename = "C:\\Users\\Visiolab\\Desktop\\toto.jpg"


