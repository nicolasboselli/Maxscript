-- A faire sur les personnages 

-- RIG

-- creer un  custom attribute pour controler la bascule du pieds du robot

-- ANIM
-- finir l'animation grossière de la séquence, jusqu'a ce que le robot soit assomé.


----------------------------------------------------------------------
----------------------------------------------------------------------

--SCRIPT
-- serie SmartRig

-- SmartRIG_the_twistor_up v0.1
--- def: à partir d'un bones selectionné et d'un controleur d'orientation sur une ik trois petit os orienté comme pau neale le montre.

-- SmartRIG_the_twistor_dw v0.1
--- def: à partir d'un bones selectionné et d'un controleur d'orientation sur une ik trois petit os orienté comme pau neale le montre.

-- SmartRIG_ik_stretch v0.1
---- def : reprendre le ik_stretch en remplaceant la contrainte au controleur spline par un link et en reliant les bones par une parentée et un scale

-- SmartRIG_stretch_spine v0.1
---- def : comme le strecht_spine2 mais avec un systeme d'orientation des os plus leger et un controle de la spline basé sur un skin

-- SmartRIG_stretch_spine_add_controler v0.1
---- def : ajoute un controleur suplémentaire sur une spline en rentrant dans le skin
---- amelioration : ne peut rajouter qu'un controleur de spline. reprendre les classement des knots pour ajouter des points indefiniment

-- SmartRIG_ik_strech_nbones v0.1
---- def : créer un ik stretch avec twist sur plus de trois bones

-- RIG

-- RIG_ik_stretch_var2
---- def: reprendre rigger_un_ik_stretch avec des contrainte script pour linker des controleur spline

-- RIG_twist_bone_var2
---- def: reprendre  creer twist bone en remplançnt le systelme des look at par des controleur orientation. mettre un controleur look at sur le controleur up.

-- RIG_stretch_spine_var2
---- def: à partir du stretch_spine2 remplacer les controleur de la spline par un skin. linker avec les controleur spline par des controller script

-- RIG_finger_var2
---- def: à partir de rigger un doigt remplacer le link aux controleur spline par  des controller script.

-- RIG_bones_tunes_var2



-- stretch_spine_relink_copy v0.1
---- def:
------ en cas de copie d'une ik spline les controleur script des knot des splines ne sont pas redirigées correctement.
------ appliquer ce script à la selection avant et aprés la copie à la selection règle le problème.
---- amélioration:
------ prévoir le cas de plusieurs splines
------ remplacer les controlleurs de la spline par un skin
------ remplacer les contraintes position et rotation par des contraintes scriptées.

-- Tunage de bones v.0.1
---- def: 
------ à partir d'une chaine bones, contrindre chaque bone à un helper en position et en rotation. les bones deviennent etirable. 
------ crée un spy_rot sur chaque bone pour en collecter la rotation sans erreurs 
---- amélioration : remplacer les contrainte position et rotation par des controleurs scripts

-- rigger_un_ik_stretch v0.1
---- amélioration : 
------- remplacer les contrainte position et rotation par des controleurs scripts

-- rigger_ikfk_stretch_with_free_elbow v0

-- creer twist bone v0.1
---- def: à partir d'une cjaine de bones, créer une chaine etirable et torsionnable entre deux helpers
---- amélioration : remplacer les contrainte position et rotation par des controleurs scripts

-- go_fast_controller! v0.1
---- def : remplace des controlleur spline lier en position et rotation contrainte par des controleurs lier par controller script
---- amélioration : mettre à jour les controleurs script en fonction des derniers développement du script  pos_rot_script_contraint

-- destroy_rig v0.1 (cf clean bones)
---- ameliorer le script de netoyage de bones pour conserver les bones d'origine

-- clean_bone_var4 v0.1
---- def; supprime toutes les contraintes appliquer au bones tout en conservant leur emplacement
---- amelioration : trouver l'équivalent du realugn (vecteur?) et du reset stretch en script.

-- creer_ctr_helper v0.1
---- def: crée un controlleur spline (cercle) sur un objet selectionner
---- amélioration: 
------remplacer les contraintes position et rotation par des controleurs scripts
------ préparer donner la posibilité de choisir entre plusieurs spline (voir recup_spline) 

-- recup_spline v0.1
---- def: recupère les knot d'une apline afin de pouvoir la recréer
---- amélioration: stocker les spline récupérée afin de pourvoir les réutilisée (sous forme de fichier externe?)

-- pos_rot_script_contraint.mcr v1
----def: lier un objet a un autre en position et rotation

-- orient_control v1
---- amelioration : afficher des panneaux d'alerte plutot que du script

-- multi_parent v1
---- def: lie une selection d'objets au dernier objet de la selection

-- link_chaine v0.1
---- def: crée un hiérachie sur une selection d'objet en suivant leur ordre de selection.

-- select_parent v1
---- amelioration : faire disparaitre l'ancien panneau d'alerte pour le remplacer par le nouveau

-- personnal_freezer v0
---- def : refaire le script pour freezer le mouvement afin qu'il fonctionne sur plus de deux controlleur sans effacer les clefs d'animation (le Pose_stajer regle au moins en partie la question)

-- rigger un doigt v0.1
---- def : créer des controller spline sur une selectionner de bones pour rigger un doigt

-- rigger_un_ik_stretch_with_free_elbow_general4 v0.1
---- def : créer un rig de bras ou de jambe avec un ik strech et un coude ajustable.
---- amélioration : l'animation du coude est aujourd'hui inutilisable bien que présente, elle altère le reste de l'animation du bras.

-- stretch_spine2
---- def : à partir d'une selection de bones, crée un ik_spline etirable.
---- amelioration; remplacer les controller de position et rotation par des controller script

-- ajout de controleur spline segment
---- def: ajoute un controlleur d'animation supplémentaire sur un segment selectionne d'un ik spine
---- amélioration: remplacer les controller de position et rotation par des controller script 


--ANIM

-- custom_scale_modifier_perm_animable v0.1
---- def : 
------ crée un custom attribute sur un objet qui permet de rendre plus accessible l'animation du scale. 
------ résiste à la fermeture de la session
------ si le modifier est détruit l'animation est conservé sur l'objet
---- amélioration : lorsqu'un nouveau modifier est créé il faudrait qu'il récupère les clefs d'animation de l'objet.

-- Multi_Constraint_in_the_air v0
---- def: 
------Script pour contrainte un objet à un autre à la volée (à partir du script de contrainte des mains de la fourmi au marteau : cust_attr_contrainte_a _plusieurs_objets_format.ms)
------ contrainte d'un objet à un autre à la volée (procedure) à partir d'un premier controleur non contraint
----synoptique ( a la premiere utilisation):
------ 1. creer le controlleur spline contraignant à la position du controleur d'origine, créer un controleur à la cible
------ 2 changer l'apparence du controleur spline
------ 3. transférer les clefs d'animaion de la source controleur au controleur d'origine(controlleur)
------ 4. effacer les clefs de la source
------ 5 créer un clef d'animation pour contraindre le controlleur spline à la cible et une clé d'animation juste avant pour que l'animation qui précède reste lié à l'origine
------ 6. créer un custom attribute à l'obejt contraint qui permette de rajouter des contraintes, de les activer et de les enlever 

---- synoptique +
------ 1. creer des controller de position et de rotation sur l'objet (script contrainte) à la position courante (ajout de helper ou de controleur spline à l'objet cible)
------ 2. permet de controler la contrainte à un cible par un modifier en controlant les piste de poids des controller
------ 3. creer des clefs d'animation sur les pistes de poids

-- Custom attribute contrainte objet v0
---- def:
------ à afficher sur l'objet contraint et sur les cibles 
------ prévoir de masquer les objets de contraintes non actif
------ en cas de delete d'un objet contrainte, supprimer les clefs de contraintes de l'objet source

-- Smart_anim_pose_lister v0
---- def: récupère tous les stackers d'animation de la scene pour les administrer, changer les noms, en créé de nouveaux, en supprimer

-- Smart_anim_pose_creator.ms v0.1
---- def : crée un point sur lequel on peut enregistrer une selection d'objet

-- Smart_anim_pose_editor.ms v0.1
---- def: interface qui permet de gérer la liste de node enregistré sur un stacker_node
---- amelioration: créer une interface qui gère la création des stackers dans la scène et l'accés à leur données. Utiliser les structures

-- Pose_Stacker_Creator v0.1
---- tout a l'air de fonctionner

-- Pose_Stacker_Editor v0.1
-- debug : verifier quand on a supprimer toutes les pose et qu'on rappuie sur delete que ça ne provoque pas une erreur.
---- la fonction copy fonctionne
---- la fonction paste à moitiè
---- la fonction delete est trés incomplete
---- les données sont conservées dans la scene mais à la collée le ref selectionner n'est pas celui qui correspond à l'enregistrement
-- amelioration : 
---- faire fonctionner le script sur des plage d'image
---- créer un superviseur d'editor
---- supprimer le crash au demarrage en definissant la variable qui pose problème. ou en créeant un macroscript qui appelle un script, ou en posant une condition if (semeble foireux), creer un menu superviseur, creer un pouton pick
---- creer une preview pose avec un toggle


--copy_paste_pose_iu2 v.0.1 (obsolete cf Pose_Stacker_Editor)
---- def: 
------ crée une interface pour le copi colle de position relatif à un objet de reference.
------ creer un outil pour copier les clefs d'un track d'un objet, les stockés et les coller sur un autre objets sur la plage d'image défini en bas. pouvoir paramétrer position/ rotation/ scale. 
---- Ameliorations : 
------ stockers les poses pour les retrouver à la session suivante (avec fonction Format sur des custom attribute ou des fichiers externes? avec des variables globales?)
------ s'en servir pour stocker des set de conttrainte a des objets?

--copy_paste_pose_modifier v.0.1 (obsolete cf Pose_Stacker_Editor)
---- def: fait la même chose que copy_paste_pose_iu2 mais sous la forme d'un modifier

-- memo_nodeTab_rollout.ms v0.1
---- def: créer un objet avec un modificateur qui stocke une selection d'objet. La gestion des selection se fait par une boite de dialogie. Données propres à la scène et persistantes.
---- amélioration:
------ fixer le nom des boite de dialogue (format?)
------ stocker les données sur l'objets créé plutot que sur le modificateur
------ placer un  bouton sur l'objet de stockage qui génére un modificateur, à instancier sur d'autre objet. format?
------ aller vers le controle de pose
----- debug: pourquoi ce bordel demande un plugin?
------ faire un script qui appelle un script, restester la fonstion. Pourquoi la fonstion en se lassant au demarrage ne fonctionne pas?

-- Create loc Key v.0.1
----def:
------ crée des clefs sur un objet  copies des clefs de rotation et de position précédentes

-- +- 360 v0
---- def: sur une ou plusieurs clés de rotation sélectionnées, ajouter ou soutraire 360° en x y ou z.

-- multi auto key v0
---- def : appliquer la meme transformation a plusieurs clefs selectionnees.

---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

-- CONSIGNE : 
-- ne jamais scaler aucun element d'un rig ni faire ne symetrie dessus
-- ne jamais lier un hlper de fin de rig à un controller spline avec les contrainte position et rotation de max. Utiliser le lien de parenté ou un controller script. Cela fait freezer les selection de clefs d'animation.

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

-- PROBLEMATIQUE
-- comment conserver des données sur une scène aprés la fermeture de la session (array, valeur, selection...). Par l'écriture sur des fichiers externes? par l'écriture dans des custom attributes? par les variables globales? par les attributes dans les customattributes?
---- pour le moment je m'oriente vers les custom attribute qui permettent de stocker et de rappeler des données dans une scène. Il y a aussi la solution des setappdata mais ça ne fonctionne qu'avec les string
---- pour le pose_staker j'ai utilser les custom attributes
-- de manière générale privilégier des controller script au controller max. voir comment les remplacer dans les scripts existant, notament dans les création par script de liaison entre les helpers de fin de rig et les controleurs d'animation.
-- problème de nomenclature, confusion entre controller et controleur et entre les diférents usages des spline.
-- aller voir du côté des matrices s'il y a quelque chose à faire
-- comment faire pour lancer un script par un macroscript. Voir dans les soulburn script. cela pour eviter le crach du pose_staker_editor
-- les modifier et la demande de plugin pour conserver des variables
-- je doit trouver un moyen de créer des rig plus rapides. Remplacer les script de vertex de la spline par un skin. linker les controleur spline aux helpers avec des contraintes scripter (plus rapide à la selection des controleurs et à la selection des clefs)
-- tester si le rig est plus rapide lorsque toutes les contraintes positions et rotations sont remplacées par des contraintes scriptées.
-- creer un contrainte lookat scriptées avec les vecteurs.

