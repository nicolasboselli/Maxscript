

--appeler un controller de poids. ne peut être appeler qu'une fois qu'on l'a défini comme controleur bézier ou autre
 $box001.pos.controller.weight[1].controller
 
 --appeler controller de position: suivre l'arbre de hiérarchie en remplaçant les espaces par des underscore. si on renomme les controlleur les appeler par leurs nouveaux noms.
 $box001.pos.controller.pos_xyz_A.controller.x_position.controller
 
 --appeler une valeur: rajouter ".value" dérrière le controller
   $box001.pos.controller.pos_xyz_A.controller.x_position.controller.value
   

   --en fait  pos.x  désigne la position de l'objet en x et pos.controller.x_position.controller ça désigne le controleur de position x.
