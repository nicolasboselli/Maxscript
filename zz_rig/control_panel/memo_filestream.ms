strBuffer = StringStream "gfdgfd"	

chapBmp = openBitmap  "J:/_svn/Chaperon rouge/00 - max/le_chaperon/chaperon.jpg"

createFile  "J:\_svn\Chaperon rouge\00 - max\le_chaperon/blup.ms" 
fileBuffer =  openFile  "J:\_svn\Chaperon rouge\00 - max\le_chaperon/blup.ms" mode: "w+"

format "print \"ploufe\" \n" to: strBuffer

print strBuffer

format (strBuffer as string) to: fileBuffer

youpi =  stringstream ""
format "  une  \"%\" " chapBmp.filename to: youpi
close fileBuffer

fileBuffer2 = undefined

fileBuffer2 =  openFile  "J:\_svn\Chaperon rouge\00 - max\le_chaperon/blup.ms" 
fileBuffer2

getFilenameFile  fileBuffer2
edit "J:\_svn\Chaperon rouge\00 - max\le_chaperon/blup.ms" 

getSourceFileName ()

test = newScript()
debug = FileToStringSteamFN fileBuffer2
print (debug as string) to: test

-- fonction qui transforme un filestream en stringstream
fn FileToStringSteamFN fs =
(
	cond = true

	strBuf = StringStream ""

	while (cond == true) do
	(
		
		try 
		(
			format ((readLine fs) + "\n") to: strBuf
		)
		
		catch 
		(
			cond = false
		)
		
	)

	return strBuf
)

fn ViewFileStreamFN fs =
(
	test = newScript()
	debug = FileToStringSteamFN fs
	print (debug as string) to: test
)

FileToStringSteamFN fileBuffer2

