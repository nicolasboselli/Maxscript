import subprocess
import os
import pymxs

rt = pymxs.runtime
scene_path = rt.maxFilePath + rt.maxFileName
print (scene_path)
outputPath = r"W:\CB Architecte\Toulon_0526\Perspective\Rendus"

# Contenu du fichier bat
bat_content = f"@echo off
"C:\\Program Files\\Pulze\\RenderFlow\\rfcli.exe" jobs submit --type=3dsmax.scene_manager.render --host=3dsmax --file="{scene_path}" --resolution=3840x2160 --output="{outputPath}" --frame=0 --priority=50
pause
"

# Écriture du fichier bat
bat_path = r"C:\temp\renderflow_submit.bat"
with open(bat_path, "w") as f:
    f.write(bat_content)

# Lancement du bat dans un terminal visible
subprocess.Popen(["cmd.exe", "/c", "start", bat_path])