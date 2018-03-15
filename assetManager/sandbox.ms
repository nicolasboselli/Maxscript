-- asset management

-- get upper folder of current scene folder


num = 0
for f in folders do
(
	fAr = filterString  f "\\"
	try
	(
		numTmp = (fAr[fAr.count] as integer)
		if numTmp > num do  num = numTmp
	)
	catch()
)
num
			-- compare counted version with info file

-- on publish version
	-- test if  asset version folder still exists
		-- create asset folder
		-- test asset content (versions, wip folder)

-- make new version folder
test = @"J:\_svn\zz_ressources3D\teapot\assetInfo.txt"
streamTest = openFile test 
close streamTest

assetPath = @"\\ELVIS\_svn\zz_ressources3D"
testFile = assetPath + "\\test3.txt"
testFileStream = createFile test
-- close testFileStream

-- testFileStream = openFile  testFile mode: "w+"
format "youhou" to: testFileStream
close testFileStream

test = @"J:\_svn\zz_ressources3D\teapot\assetInfo.txt"
testFileStream = openFile  test mode: "r+"

endOfFile = false
while endOfFile == false do
(
	str = readLine testFileStream
	print str
	endOfFile = eof testFileStream
)
close testFileStream


test = stringstream "tata"
format "toto" to: test  -- print (testFileStream as stringstream)
print (test as string)

append test "toto"

-- maj:
	-- 	change	root to  use on differents device

-- contextual files
	-- write somewhere the root for asset folders (armadasScriptsIni.ini)
	-- create ini file with superclass and class types(in assets root)

-- PUBLISHER
	-- write asset info file in asset folder
	-- write version info file in version folder

	-- info:
		-- enter path
		-- enter name
		-- version
		-- status
		-- comment
		-- class
		-- superclass

	-- export selection as asset
		-- save as  version 

	-- save scene as asset
		-- save as version 0
		-- verification:
			-- working in wip folder
			-- count version on upper folder
			-- add version info file with version info, comment and status
			

	
-- SCANNER
	-- full python?
	-- look into the assets folder to collect all valid asset folder paths in one file(write where? assets root)
	-- generate html from local assets list

-- OPENER
	-- on open launch assets lists paths
	
	-- edit asset
		-- copy file in wip, rename with wip inside name and open
	-- import(merge)
		-- merge top scene + children
		-- write infos in top node user properties
	-- update asset
		-- check if update is possible
		-- delete asset selected
		-- import last version of asset
	
	-- actions
		-- inspect max file(getMAXFileObjectNames )
		-- find top node
	
	-- publish new version
	
	
-- TOOLS
	-- topscene name = file name + ctrl

	-- add texture in folder
		-- collect ressource with network path in associate textures folder
		
	-- vrmeshes in folder
	-- create thumbnail

	-- 

