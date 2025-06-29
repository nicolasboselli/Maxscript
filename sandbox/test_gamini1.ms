/* Ok, c'est une excellente idée de script ! C'est un cas d'utilisation très pratique. Voici un script MaxScript qui réalise exactement ce que vous avez décrit.

Fonctionnement détaillé du script :

Il crée une petite fenêtre (un rollout dans un dialog) avec un bouton.

Quand vous cliquez sur le bouton, il passe en mode "sélection de face". Le texte du bouton change pour indiquer que vous pouvez annuler en cliquant à nouveau ou avec un clic droit.

Vous cliquez ensuite sur une face d'un objet dans la vue.

Le script identifie l'objet et l'index de la face cliquée.

Il récupère le matériau de base de l'objet.

Si l'objet utilise un matériau Multi/Sub-Object, il détermine l'ID de matériau de la face cliquée et trouve le sous-matériau correspondant.

Si l'objet a un matériau standard (non Multi/Sub), il utilise simplement ce matériau.

S'il n'y a pas de matériau, il vous en informe.

Si un matériau pertinent est trouvé, il ouvre (ou s'assure qu'il est ouvert) l'éditeur de matériaux Slate (SME) et affiche ce matériau spécifique dans la vue active du SME.

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
try(destroyDialog faceMatPickRollout)catch() -- Ferme une instance précédente si elle existe

rollout faceMatPickRollout "Face Material Picker"
(
    -- // UI Elements \\ --
    button btn_pickFace "1. Pick Face to Edit Material" width:190 height:30 tooltip:"Click then pick a face in the viewport"
    label lbl_status "Status: Waiting..." align:#left

    -- // Variables Locales \\ --
    local isPickingMode = false -- Flag pour savoir si on est en mode sélection

    -- // Fonctions \\ --

    -- Fonction pour traiter la face sélectionnée
    fn processPickedFace theNode faceIndex =
    (
        lbl_status.text = "Status: Processing..."
        forceCompleteRedraw() -- Force un rafraîchissement pour voir le statut

        local baseMat = theNode.material
        local targetMat = undefined -- Le matériau final à afficher

        if baseMat != undefined then
        (
            -- Vérifie si c'est un matériau Multi/Sub-Object
            if isKindOf baseMat MultiMaterial then
            (
                -- Récupère l'ID de matériau assigné à cette face spécifique
                local faceMatID = getFaceMatID theNode faceIndex
                format "Node: '%', Face Index: %, Face MatID: %\n" theNode.name faceIndex faceMatID

                -- Vérifie si l'ID est valide et dans les limites des sous-matériaux
                if faceMatID > 0 and faceMatID <= baseMat.materialList.count then
                (
                    targetMat = baseMat.materialList[faceMatID] -- Récupère le sous-matériau
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
            else -- Ce n'est pas un Multi/Sub, utilise le matériau de base
            (
                targetMat = baseMat
                format "Node: '%', Face Index: %. Using base material: %\n" theNode.name faceIndex baseMat.name
            )
        )
        else -- L'objet n'a pas de matériau du tout
        (
            format "Node: '%' has no material assigned.\n" theNode.name
            lbl_status.text = "Status: Object has no material."
        )

        -- Ouvre le matériau dans le Slate Material Editor (SME)
        if targetMat != undefined then
        (
            try
            (
                sme.Open() -- S'assure que le SME est ouvert
                local activeView = sme.GetView (sme.activeView) -- Récupère la vue active du SME
                if activeView != undefined then
                (
                    activeView.SetNodes #(targetMat) false -- Affiche le matériau (le 'false' évite de sélectionner le node)
                    activeView.ZoomExtents() -- Zoom sur le matériau
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
        else if baseMat != undefined then-- Si on avait un matériau de base mais pas de sous-matériau cible
        (
            -- Le statut a déjà été mis à jour ("Slot empty" ou "Invalid Mat ID")
            --ok -- just do nothing more
        )

        -- Réinitialise le mode picking
        isPickingMode = false
        btn_pickFace.text = "1. Pick Face to Edit Material"
        toolMode.exitTool() -- Quitte le mode de sélection (important!)
        enableSceneRedraw()
        forceCompleteRedraw()
    )

    -- Fonction callback appelée quand l'utilisateur clique dans la vue
    fn facePickCallback msg param =
    (
        -- msg contient des informations sur l'événement souris
        -- param contient des informations contextuelles (difficile à utiliser ici)

        -- On réagit seulement au clic gauche
        if msg == #leftClick then
        (
            local hitPos = mouse.screenpos -- Position 2D du clic souris
            local theRay = mapScreenToWorldRay hitPos -- Crée un rayon 3D depuis la caméra

            -- Intersecte le rayon avec TOUTE la géométrie visible de la scène
            -- intersectRayScene retourne un array de hits [ [node1, faceIndex1, distance1], [node2, faceIndex2, distance2], ... ]
            -- trié par distance (le plus proche en premier)
            local hits = intersectRayScene theRay

            local foundHit = false
            if hits.count > 0 then
            (
                 -- On prend le premier hit sur un objet géométrique non gelé et visible
                 for h in hits where not foundHit do
                 (
                     local hitNode = h[1]
                     local hitFaceIndex = h[2]
                     if isKindOf hitNode GeometryClass and not hitNode.isFrozen and not hitNode.isHidden then
                     (
                         format "Picked Node: %, Face: %\n" hitNode.name hitFaceIndex
                         processPickedFace hitNode hitFaceIndex -- Traite la face trouvée
                         foundHit = true -- Sort de la boucle
                     )
                 )
            )

            if not foundHit then
            (
                 lbl_status.text = "Status: Clicked empty space or non-geometry."
                 format "No valid geometry hit at click position.\n"
            )

             -- Dans tous les cas (hit ou pas), on sort du mode pick après un clic gauche
             -- SAUF si on veut permettre plusieurs essais. Pour l'instant, on sort.
             isPickingMode = false
             btn_pickFace.text = "1. Pick Face to Edit Material"
             toolMode.exitTool() -- Quitte le mode de sélection
             enableSceneRedraw()
             forceCompleteRedraw()
             return #stop -- Stoppe le traitement de l'événement souris par mouseTrack
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

        #continue -- Continue le suivi pour d'autres messages si non stoppé
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
            disableSceneRedraw() -- Optionnel: peut rendre la sélection plus réactive

            -- Lance le mode de suivi de la souris pour capturer le clic
--             mouseTrack processCallback:facePickCallback
			mouseTrack trackCallback: pickTest
        )
    )

    on faceMatPickRollout close do
    (
        --if isPickingMode then toolMode.exitTool() -- S'assure de quitter le mode si on ferme la fenêtre
    )

) -- Fin du Rollout

-- Crée et affiche la fenêtre
createDialog faceMatPickRollout 210 80 -- Largeur, Hauteur

