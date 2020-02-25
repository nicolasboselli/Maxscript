-- collecter les layer et leur etat ishidden
-- isHiddenAr = #()
lCount = LayerManager.count
for i = 0 to (lCount - 1)  do
(
	l = LayerManager.getLayer i
	if not l.ishidden then
	(
		local oneVisSel
		
		format "%: % is hidden: %\n" i l.name l.ishidden
		l.current = true
				
		format "###############collapse start\n"
		l.nodes &oneVisSel
		collapseMultiMatonVisibleObjects oneVisSel
		format "###############collapse done\n\n"
		
		format "############### explose by material start\n"
		l.nodes &oneVisSel
		explodeVisibleObjectsByMultiMat oneVisSel
		format "############### explose by material done\n\n"
		
		format "############### attach start\n"
		l.nodes &oneVisSel
		if oneVisSel.count > 0 then	attachVisiblesObjectsByMonoMat oneVisSel maxSel: 5000
		format "############### attach done\n\n"
	)
	else
	(
		format "ignore %: % is hidden: %\n" i l.name l.ishidden
	)
)

-- cacher les layers un par un et appliquer le traitemenet
-- en cas de blocage à l'attachement revenir à la config de layer d'origine