/* Ok, c'est une excellente id�e de script ! C'est un cas d'utilisation tr�s pratique. Voici un script MaxScript qui r�alise exactement ce que vous avez d�crit.

Fonctionnement d�taill� du script :

Il cr�e une petite fen�tre (un rollout dans un dialog) avec un bouton.

Quand vous cliquez sur le bouton, il passe en mode "s�lection de face". Le texte du bouton change pour indiquer que vous pouvez annuler en cliquant � nouveau ou avec un clic droit.

Vous cliquez ensuite sur une face d'un objet dans la vue.

Le script identifie l'objet et l'index de la face cliqu�e.

Il r�cup�re le mat�riau de base de l'objet.

Si l'objet utilise un mat�riau Multi/Sub-Object, il d�termine l'ID de mat�riau de la face cliqu�e et trouve le sous-mat�riau correspondant.

Si l'objet a un mat�riau standard (non Multi/Sub), il utilise simplement ce mat�riau.

S'il n'y a pas de mat�riau, il vous en informe.

Si un mat�riau pertinent est trouv�, il ouvre (ou s'assure qu'il est ouvert) l'�diteur de mat�riaux Slate (SME) et affiche ce mat�riau sp�cifique dans la vue active du SME.

Le Code MaxScript :

-- ==================================================
-- Script: Face Material Editor Opener
-- Author: [Votre Nom / AI Assistant]
-- Version: 1.0
-- Date: 2024-MM-DD
--
-- Description:
-- Creates a tool to pick a face on an object and
-- display its assigned material in the Slate Material Editor.
-- ==================================================
 */
try(destroyDialog faceMatPickRollout)catch() -- Ferme une instance pr�c�dente si elle existe

rollout faceMatPickRollout "Face Material Picker"
(
    -- // UI Elements \\ --
    button btn_pickFace "1. Pick Face to Edit Material" width:190 height:30 tooltip:"Click then pick a face in the viewport"
    label lbl_status "Status: Waiting..." align:#left

    -- // Variables Locales \\ --
    local isPickingMode = false -- Flag pour savoir si on est en mode s�lection

    -- // Fonctions \\ --

    -- Fonction pour traiter la face s�lectionn�e
    fn processPickedFace theNode faceIndex =
    (
        lbl_status.text = "Status: Processing..."
        forceCompleteRedraw() -- Force un rafra�chissement pour voir le statut

        local baseMat = theNode.material
        local targetMat = undefined -- Le mat�riau final � afficher

        if baseMat != undefined then
        (
            -- V�rifie si c'est un mat�riau Multi/Sub-Object
            if isKindOf baseMat MultiMaterial then
            (
                -- R�cup�re l'ID de mat�riau assign� � cette face sp�cifique
                local faceMatID = getFaceMatID theNode faceIndex
                format "Node: '%', Face Index: %, Face MatID: %\n" theNode.name faceIndex faceMatID

                -- V�rifie si l'ID est valide et dans les limites des sous-mat�riaux
                if faceMatID > 0 and faceMatID <= baseMat.materialList.count then
                (
                    targetMat = baseMat.materialList[faceMatID] -- R�cup�re le sous-mat�riau
                    if targetMat == undefined then
                    (
                         format "  -> Mat ID slot % is empty.\n" faceMatID
                         lbl_status.text = ("Status: Slot " + faceMatID as string + " is empty.")
                    )
                    else
                    (
                        format "  -> Found Sub-Material: %\n" targetMat.name
                    )
                )
                else
                (
                     format "  -> Warning: Invalid Material ID % assigned to face %.\n" faceMatID faceIndex
                     lbl_status.text = ("Status: Invalid Mat ID (" + faceMatID as string + ")")
                )
            )
            else -- Ce n'est pas un Multi/Sub, utilise le mat�riau de base
            (
                targetMat = baseMat
                format "Node: '%', Face Index: %. Using base material: %\n" theNode.name faceIndex baseMat.name
            )
        )
        else -- L'objet n'a pas de mat�riau du tout
        (
            format "Node: '%' has no material assigned.\n" theNode.name
            lbl_status.text = "Status: Object has no material."
        )

        -- Ouvre le mat�riau dans le Slate Material Editor (SME)
        if targetMat != undefined then
        (
            try
            (
                sme.Open() -- S'assure que le SME est ouvert
                local activeView = sme.GetView (sme.activeView) -- R�cup�re la vue active du SME
                if activeView != undefined then
                (
                    activeView.SetNodes #(targetMat) false -- Affiche le mat�riau (le 'false' �vite de s�lectionner le node)
                    activeView.ZoomExtents() -- Zoom sur le mat�riau
                    lbl_status.text = ("Status: Material '" + targetMat.name + "' in SME.")
                    format "  -> Material '% ' displayed in SME View %.\n" targetMat.name (sme.activeView)
                )
                else
                (
                     messagebox "Could not get active Slate Material Editor view." title:"Error"
                     lbl_status.text = "Status: Error with SME view."
                )
            )
            catch
            (
                 messagebox ("Error accessing Slate Material Editor:\n" + (getCurrentException())) title:"SME Error"
                 lbl_status.text = "Status: Error accessing SME."
            )
        )
        else if baseMat != undefined then-- Si on avait un mat�riau de base mais pas de sous-mat�riau cible
        (
            -- Le statut a d�j� �t� mis � jour ("Slot empty" ou "Invalid Mat ID")
            --ok -- just do nothing more
        )

        -- R�initialise le mode picking
        isPickingMode = false
        btn_pickFace.text = "1. Pick Face to Edit Material"
        toolMode.exitTool() -- Quitte le mode de s�lection (important!)
        enableSceneRedraw()
        forceCompleteRedraw()
    )

    -- Fonction callback appel�e quand l'utilisateur clique dans la vue
    fn facePickCallback msg param =
    (
        -- msg contient des informations sur l'�v�nement souris
        -- param contient des informations contextuelles (difficile � utiliser ici)

        -- On r�agit seulement au clic gauche
        if msg == #leftClick then
        (
            local hitPos = mouse.screenpos -- Position 2D du clic souris
            local theRay = mapScreenToWorldRay hitPos -- Cr�e un rayon 3D depuis la cam�ra

            -- Intersecte le rayon avec TOUTE la g�om�trie visible de la sc�ne
            -- intersectRayScene retourne un array de hits [ [node1, faceIndex1, distance1], [node2, faceIndex2, distance2], ... ]
            -- tri� par distance (le plus proche en premier)
            local hits = intersectRayScene theRay

            local foundHit = false
            if hits.count > 0 then
            (
                 -- On prend le premier hit sur un objet g�om�trique non gel� et visible
                 for h in hits where not foundHit do
                 (
                     local hitNode = h[1]
                     local hitFaceIndex = h[2]
                     if isKindOf hitNode GeometryClass and not hitNode.isFrozen and not hitNode.isHidden then
                     (
                         format "Picked Node: %, Face: %\n" hitNode.name hitFaceIndex
                         processPickedFace hitNode hitFaceIndex -- Traite la face trouv�e
                         foundHit = true -- Sort de la boucle
                     )
                 )
            )

            if not foundHit then
            (
                 lbl_status.text = "Status: Clicked empty space or non-geometry."
                 format "No valid geometry hit at click position.\n"
            )

             -- Dans tous les cas (hit ou pas), on sort du mode pick apr�s un clic gauche
             -- SAUF si on veut permettre plusieurs essais. Pour l'instant, on sort.
             isPickingMode = false
             btn_pickFace.text = "1. Pick Face to Edit Material"
             toolMode.exitTool() -- Quitte le mode de s�lection
             enableSceneRedraw()
             forceCompleteRedraw()
             return #stop -- Stoppe le traitement de l'�v�nement souris par mouseTrack
        )
        else if msg == #rightClick or msg == #abort then -- Clic droit ou Echap pour annuler
        (
             lbl_status.text = "Status: Picking cancelled."
             format "Picking cancelled by user.\n"
             isPickingMode = false
             btn_pickFace.text = "1. Pick Face to Edit Material"
             toolMode.exitTool()
             enableSceneRedraw()
             forceCompleteRedraw()
             return #stop
        )

        #continue -- Continue le suivi pour d'autres messages si non stopp�
    )
	
	fn pickTest msg ir obj faceNum shift ctrl alt =
	(
		format "msg: % ir: % obj: % faceNum: % shift: % ctrl: % alt: %\n" msg ir obj faceNum shift ctrl alt
	)
	
    -- // Event Handlers (UI) \\ --
    on btn_pickFace pressed do
    (

--         else -- Sinon, on entre en mode pick
        (
            isPickingMode = true
            btn_pickFace.text = "PICKING... (Click face or Right-Click to cancel)"
            lbl_status.text = "Status: Click on a face in the viewport..."
            disableSceneRedraw() -- Optionnel: peut rendre la s�lection plus r�active

            -- Lance le mode de suivi de la souris pour capturer le clic
--             mouseTrack processCallback:facePickCallback
			mouseTrack trackCallback: pickTest
        )
    )

    on faceMatPickRollout close do
    (
        --if isPickingMode then toolMode.exitTool() -- S'assure de quitter le mode si on ferme la fen�tre
    )

) -- Fin du Rollout

-- Cr�e et affiche la fen�tre
createDialog faceMatPickRollout 210 80 -- Largeur, Hauteur

