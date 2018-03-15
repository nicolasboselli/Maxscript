test = "" as stringstream 

format "2+2" to: test

execute (test as string)

getDirectories 

getfiles "C:/Users/nicolas/Desktop/maxscript/process_fenetre/*.ms"

getOpenFileName filename: "C:/Users/nicolas/Desktop/maxscript/process_fenetre/test.ms"

test = openFile "C:Users/nicolas/Desktop/maxscript/process_fenetre/test.ms"

openFile (getdir #maxroot + "/Scripts/tuiles/tuiles_starter3.ms")

openFile ((getdir #maxroot) + "Scripts/tuiles/tuiles_starter3.ms")

execute test

getFilenamePath 