SymPaup = custattributes.getDef $.modifiers[1] 1
-- attributes SymPaup
attributes SymPaup -- attribid:#(0x75b43472, 0x219ecd5e)
Redefine:SymPaup
(

fn CopyUVSurface SourceNode:TargetNode: = (
	TargetNode[3][1][2].U = SourceNode[3][1][2].U
	TargetNode[3][1][2].V = SourceNode[3][1][2].V
	
	RotMulti = [-1,-1,1]
	for i = 1 to 3 do (
		TargetNode[3][2][2][i].value = SourceNode[3][2][2][i].value * RotMulti[i]
	)
)

Fn SymmetryEyelid CurrentBN: DGbool: = (
	
	ListPattern =  #(					  \
		"Eyelid_CornerOutMarker_RIG"	, \
		"Eyelid_OutUpMarker_RIG"		, \
		"Eyelid_MidUpMarker_RIG"		, \
		"Eyelid_CornerInMarker_RIG"		, \
		"Eyelid_MidMarker_RIG"			, \
		"Eyelid_InMarker_RIG"			, \
		"Eyelid_InUpMarker_RIG"			, \
		"Eyelid_OutMarker_RIG"			, \
		"Eyelid_OutDownMarker_RIG"		, \
		"Eyelid_MidDownMarker_RIG"		, \
		"Eyelid_InDownMarker_RIG"		  \
	)
	
	if DGbool == true then (
		Source	= "_D_"
		Target	= "_G_"
	) else (
		Source	= "_G_"
		Target	= "_D_"
	)
	
	for patt in ListPattern do (
		try
		(
		CopyUVSurface 	SourceNode:(getnodebyname (CurrentBN + Source + patt)) 	TargetNode:(getnodebyname (CurrentBN + Target + patt))
		)catch(format "ERROR on UV: %\n" patt)
						
	)

)
-- parameters ParamSym rollout: Rollout_SymPaup (
-- 	
-- 	ParamSAR type: #boolean ui:(btnDG )
-- 	
-- )


rollout Rollout_SymPaup "Sym Paup" width:162 height:84
(
	button btnDG "D  -->   G" pos:[13,13] width:134 height:23 align:#left
	button btnGD "G  -->   D" pos:[14,46] width:134 height:23 align:#left
	 
	on btnDG pressed do ( 
		SymmetryEyelid CurrentBN:"P_BaseName" DGbool: true 
		print "Symmetry Paupiere Droite sur Gauche Ok"
	)
	on btnGD pressed do ( 
		SymmetryEyelid CurrentBN:"P_BaseName" DGbool: false 
		print "Symmetry Paupiere Gauche sur Droite Ok"
	)
)


)
