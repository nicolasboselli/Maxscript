/*
multilines = (dotNetClass "System.IO.File").ReadAllLines @"M:\Biblio\VISIOLAB\8-Scripts\Production\Maxscript\MATERIALS_TOOLS\ral_classic.csv"
multiLSplited = #()

for i = 2 to multilines.count do
(
	splitL = filterString goodL ","
	append multiLSplited splitL
)

-- finditem multilines "*RAL*"
RalVal = 7021
goodL
for l in multilines do
(
	if MatchPattern l pattern: ("RAL "+ (RalVal as string) + "*") then
	(
		goodL = l
		format "l: %n" goodL
		exit
	)
)

splitL = filterString goodL ","

rgbVal = splitL[2]
hexVal = splitL[3]
*/


function RGBtoLinear oneColor =
(
	
	oldr = oneColor.r
	oldg = oneColor.g
	oldb = oneColor.b
	newR = 255 * ((oldr/255)^2.2)
	newG = 255 * ((oldg/255)^2.2)
	newB = 255 * ((oldb/255)^2.2)
	
	(color newR newG newB)
)



try(destroydialog RALvalueRLT)catch()
rollout RALvalueRLT "RAL Value"
(
	-- vars
	local multiLSplited  = #()
	local multiLSplitedToShow  = #()
	local ralNameArray = #()
	
	-- UI
	edittext RALsearch "search:"
-- 	spinner RALsp "RAL:" type: #integer
	listBox RALListLB
	
	edittext RALREF "" readonly: true
	edittext RGBVal "RGB:" readonly: true
	edittext HEXVal "Hex:" readonly: true
	
	colorpicker RALcolorCP "RAL:" fieldWidth:110
	
	button createVrayColorBT "create vray color" -- enabled: false
	group "help"
	(
		button helpBT "help" 
	)
	
	-- actions
	on RALvalueRLT open do
	(
		multilines = (dotNetClass "System.IO.File").ReadAllLines @"M:\Biblio\VISIOLAB\8-Scripts\Production\Maxscript\MATERIALS_TOOLS\ral_classic.csv"
		multiLSplited = #()

		for i = 2 to multilines.count do
		(
			splitL = filterString multilines[i] ","
			append multiLSplited splitL
		)
		
		multiLSplitedToShow = for l in multiLSplited collect l
		ralNameArray = for l in multiLSplitedToShow collect l[1]
		RALListLB.items = ralNameArray
		
		RALListLB.selection = 1
		RALREF.text = multiLSplitedToShow[1][1]
		HEXVal.text = multiLSplitedToShow[1][3]
		RGBVal.text = multiLSplitedToShow[1][2]
		
		RGBArray = filterString multiLSplitedToShow[1][2] "-"
		
		RALcolor = color (RGBArray[1] as integer) (RGBArray[2] as integer) (RGBArray[3] as integer)
		RALcolorCP.color = RGBtoLinear RALcolor
	)
	
	on RALListLB selected val do
	(
		RALREF.text = multiLSplitedToShow[val][1]
		HEXVal.text = multiLSplitedToShow[val][3]
		RGBVal.text = multiLSplitedToShow[val][2]
		
		RGBArray = filterString multiLSplitedToShow[val][2] "-"

		RALcolor = color (RGBArray[1] as integer) (RGBArray[2] as integer) (RGBArray[3] as integer)
-- 		format "RALcolor: %\n" RALcolor
		
		RALcolorCP.color = RGBtoLinear RALcolor
		
-- 		colorPickerDlg RALcolor "Pick A Better Color:" alpha:true pos:[100,100]
	)
	
	on RALsearch entered val do
	(
		format "multiLSplitedToShow: %\n" multiLSplitedToShow
		RALListLB.selection = 1
		RALREF.text = multiLSplitedToShow[1][1]
		HEXVal.text = multiLSplitedToShow[1][3]
		RGBVal.text = multiLSplitedToShow[1][2]
		
		RGBArray = filterString multiLSplitedToShow[1][2] "-"
		
		RALcolor = color (RGBArray[1] as integer) (RGBArray[2] as integer) (RGBArray[3] as integer)
		RALcolorCP.color = RGBtoLinear RALcolor
	)
	
	on RALsearch changed val do
	(
		multiLSplitedToShow= #()
		print (val + "*")
		for L in multiLSplited do
		(
			res = matchpattern L[1] pattern: ("*"+ val + "*")
			if res then
			(				
				append multiLSplitedToShow L
-- 				format "L: %\n" L
			)
		)
		
		ralNameArray = for l in multiLSplitedToShow collect l[1]
		RALListLB.items = ralNameArray
		
-- 		for l in multiLSplitedToShow do format "l:%\n" l
	)
	
	
	on createVrayColorBT pressed do
	(
		RALListLB.selection
		RGBArray = filterString multiLSplitedToShow[RALListLB.selection][2] "-"
		
		RALcolor = color (RGBArray[1] as integer) (RGBArray[2] as integer) (RGBArray[3] as integer)
		format "RALcolor: %\n" RALcolor
		
		 
		 vrRAL = VRayColor color: (RGBtoLinear RALcolor)
		--  showproperties vrRAL
		try((sme.getview 1).CreateNode  vrRAL (point2 100 100))catch()

	)
	
	on helpBT pressed do
	(
		try(closeRolloutFloater  theHelpFloater)catch()
		theHelpFloater = newRolloutFloater "RAL Value Tool Help" 950 800 lockWidth: false

		try(destroydialog test_bitmaps)catch()
		rollout test_bitmaps "RAL Value Tool Help"
		(
			bitmap the_bmp fileName: @"M:\Biblio\VISIOLAB\8-Scripts\Production\Maxscript\MATERIALS_TOOLS\load_ral.jpg" 
		)
		-- createDialog test_bitmaps -- style: #(#style_border, #style_titlebar, #style_toolwindow, #style_resizing, #style_minimizebox, #style_maximizebox, #style_sysmenu)
		addRollout test_bitmaps theHelpFloater
	)
)
CreateDialog RALvalueRLT