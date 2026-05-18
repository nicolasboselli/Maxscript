# RailClone Placer

Version: 0.2.0

Outil MaxScript pour merger un fichier `.max` contenant un seul RailClone, puis assigner la ou les splines selectionnees au RailClone merge.

## Utilisation

1. Lance `railclone_placer.ms` dans 3ds Max.
2. Clique `Add .max...` pour ajouter des fichiers RailClone depuis n'importe quel chemin reseau ou local.
3. Selectionne une ou plusieurs splines dans la scene.
4. Choisis un item dans la liste.
5. Active `Delete spline modifiers before assign` si les splines doivent etre nettoyees avant l'assignation.
6. Clique `Merge + assign to selected splines`.

Le script merge une nouvelle instance du fichier pour chaque spline selectionnee. Si trois splines sont selectionnees, trois RailClone sont crees.

L'option `Delete spline modifiers before assign` supprime les modifiers de chaque spline selectionnee avant de l'affecter au RailClone. Ce choix est sauvegarde.

## Remplacer des RailClone existants

1. Choisis le nouveau RailClone dans la liste.
2. Selectionne un ou plusieurs RailClone deja presents dans la scene.
3. Clique `Replace selected RailClones`.

Le script recupere la spline `banode[1]` de chaque ancien RailClone, merge le nouveau fichier, assigne cette spline au nouveau RailClone, puis supprime l'ancien RailClone si l'assignation a reussi. Le nouveau RailClone reprend le nom, la layer et le parent de l'ancien.

## Stockage de la liste

La liste est sauvegardee par utilisateur dans :

```maxscript
(GetDir #maxData) + "NicoScriptTools\\RAICLONE_PLACER\\railclone_placer.ini"
```

Le dossier du script peut donc rester partage sans imposer la meme liste a tous les postes.

Si une ancienne preference existe dans `VisiolabTools\\RAICLONE_PLACER`, elle est copiee automatiquement vers le nouveau dossier `NicoScriptTools\\RAICLONE_PLACER` au premier lancement.

## Hypothese importante

Chaque fichier `.max` ajoute a la liste doit contenir un seul objet RailClone utile. Le script detecte le RailClone cree par le merge et tente d'affecter la spline selectionnee a son premier input compatible.

Si l'assignation echoue sur une version de RailClone specifique, regarde le Listener MaxScript : le script log les methodes/proprietes essayees pour aider a adapter le nom exact de l'API exposee par cette version.
