import subprocess
import os
import pymxs

rt = pymxs.runtime



#~ scene_path = "--file="+ rt.maxFilePath + rt.maxFileName
scene_path = "--file="+ r"W:\Demathieu\Concours_Marseille_0126\Perspective\Perspective\Scenes 3d\Vue_Gen\Concours_Marseille_Gen_08.max"

#~ outputPath = "--output=" + r"W:\CB Architecte\Toulon_0526\Perspective\Rendus"
outputPath = "--output=" + r"W:\Cogedim\Sartrouville_0426\Perspective\Rendus"

commande = [
     r"C:\Program Files\Pulze\RenderFlow\rfcli.exe", 
    "jobs", 
    "submit",
	"--i",
	"--type=3dsmax.render",
	"--host=3dsmax",
	scene_path,
	outputPath,
	#~ "--frame= 0", 
	#~ "--priority=75",
	#~ "--pid=12345"
]

#~ rfcli.exe jobs submit -i --type=3dsmax.render --host=3dsmax --file="scene.max" --pid=12345

try:
    # Exécution de la commande
    resultat = subprocess.run(commande, capture_output=True, text=True, check=True)
    
    # Affichage du retour de la console (si le logiciel renvoie un ID de job par exemple)
    print("Commande envoyée avec succès !")
    print("stsout:" + resultat.stdout)

except subprocess.CalledProcessError as e:
    # En cas d'erreur (mauvais chemin, logiciel absent, etc.)
    print(f"Erreur lors de la soumission du job : {e.stderr}")
except FileNotFoundError:
    print("Erreur : l'exécutable 'rfcli.exe' est introuvable. Vérifiez votre variable d'environnement PATH.")