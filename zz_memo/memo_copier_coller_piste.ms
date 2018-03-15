-- copier l'animation d'un controller sur un autre
-- declaration des constantes
aa = $box001.pos.track
bb = $box002.pos.track

-- collecte des numeros de clef
aak = aa.keys

-- collecte des valeurs d'animation au point clef collectés
anim = for i= 1 to aak.count collect at time aak[i].time aa.value

--nettoyage de la piste cible
deletekeys bb #allkeys

--collage de la piste source à la piste cible
animate on
for i = 1 to aak.count do  at time aak[i].time bb.value = anim[i]
	
-- transférer animation du controleur de position du free_elbow vers les controleur  de position en x des os.
---- taille os du biceps : position en x de $bone002 =  distance entre $free elbow et $point002
---- taille os avant bras : position en x de $bone 003 = distance entre $free elbow et $point003

-- recuperer l'animation du coude sur le free_elbow
---- position du free elbow = position de l'os de l'avant bras.