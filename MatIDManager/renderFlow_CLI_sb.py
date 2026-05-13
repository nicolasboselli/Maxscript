import subprocess
import os
import pymxs

rt = pymxs.runtime

scene_path = rt.maxFilePath + rt.maxFileName
print(scene_path)

# 1. Charger le script de pré-rendu
#~ rt.preRenderScript = r"W:\scripts\mon_script_prerendu.ms


# 2. Soumettre le job
result = subprocess.run([
    r"C:\Program Files\Pulze\RenderFlow\rfcli.exe",
    "jobs","submit", #"-i",
    "--type=3dsmax.render",
    "--host=3dsmax",
    "--file={scene_path}", 
    #~ "--pid", str(os.getpid()),
    "--output=r""W:\CB Architecte\Toulon_0526\Perspective\Rendus\frame_.png""",
    "--priority=50"
], capture_output=True, text=True)


#~ rfcli.exe jobs submit --type=3dsmax.render --host=3dsmax --file=S:\project\myscene.max --resolution=3840x2160 --output=S:\project\output.exr --frame=1-100 --priority=50

"""
result = subprocess.run([
    r"C:\Program Files\Pulze\RenderFlow\rfcli.exe",
    "jobs","--help" 
], capture_output=True, text=True)
"""

print(result.stdout)
print(result.stderr)

# 3. Décharger le script de pré-rendu
#~ rt.preRenderScript = ""