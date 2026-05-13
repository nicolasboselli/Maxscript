import subprocess
import os
import pymxs

rt = pymxs.runtime
scene_path = rt.maxFilePath + rt.maxFileName
outputPath = r"W:\CB Architecte\Toulon_0526\Perspective\Rendus"

commande = [
    r"C:\Program Files\Pulze\RenderFlow\rfcli.exe", 
    "jobs", 
    "submit", 
	"--i",
    "--type=3dsmax.scene_manager.render", 
    "--host=3dsmax", 
    f"--file={scene_path}",        # f-string : insère la variable
    "--resolution=3840x2160", 
    f"--output={outputPath}",      # f-string : insère la variable
    "--frame=0", 
    "--priority=50"
]

try:
    resultat = subprocess.run(commande, capture_output=True, text=True, check=True)
    print("Commande envoyée avec succès !")
    print("stdout:" + resultat.stdout)
except subprocess.CalledProcessError as e:
    print(f"Erreur lors de la soumission du job : {e.stderr}")
except FileNotFoundError:
    print("Erreur : rfcli.exe introuvable.")