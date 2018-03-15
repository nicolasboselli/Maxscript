createfile "toto.ms"
openfile "free"
getopenfilename caption: "toto.ms"
filename: "C:\Users\nicolas\Documents\3dsmax\scenes\toto.ms"
selection.count

edit "toto.ms"

debug = newScript()
obj = $
format "name is % \n"  obj to:debug

out_file = createfile "toto2.ms"
format "2+2 \n"   to:out_file
close out_file
yo = openfile "toto2.ms"
execute yo

debug = newScript()
format "name is ugluhyuo ihmoium imimplkj oi  \n"   to:debug

