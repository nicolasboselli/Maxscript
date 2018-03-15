
$poignet.pos = $bone003.pos
$coude.pos = $bone002.pos
$condition2.pos.y = -50


aa = distance $epaule $coude
bb = distance $poignet $coude
$condition2.pos.y = 50

--comment recupérer le nom (intitulé) d'un controller?
-- comment affecter la valeur d'un controleur à un autre sous forme de point clé?
  -- 1 activer le controller source (script)
     $.position.controller.x_position.controller.setActive 1
  -- 2 stocker la valeur du controller source sous forme de constante
     pos_source = $.pos.x
  -- 2.5 récupérer le numero de la frame où l'on veut créer la clé.
  
 -- 2.6 stocker le numero  sous forme de constante
    frame_frame =
  -- 3.1 activer le controller cible
    $.position.controller.x_position.controller.setActive 2
  -- 3.2 mettre le poids du controller 1 à zero
  $.pos.controller.X_Position.controller.weight[0] = 0
  -- 3.3 mettre le poids du controller 2 à 100
  $.pos.controller.X_Position.controller.weight[2] = 1
  -- 4 créer un point clé sur le controller cible à la frame stockée en y appliquant la valeur stockée
     animate on (at frame_frame  $.pos.x = pos_source)
  
-- comment créer une clé avec une valeur précise?
animate on ( at time 20 $.pos.x = 20)
-- comment récupérer un numéro  de frame à un moment donné?
-- comment activer un controller?
$.position.controller.x_position.controller.setActive 1

--créer une boite de dialogue
rollout tets "Untitled" width:162 height:300 ()
createdialog tets

--créer un modifier vide
test = emptymodifier ()
addmodifier $ test

--choisir un node, pickbutton?

--conserver un lien à un node même si le nom de l'object change?



