enum = #("P_Batricia_G_Calf_BIP", "P_Batricia_G_Thigh_BIP", "P_Batricia_D_Thigh_BIP", "P_Batricia_D_Calf_BIP", "P_Batricia_D_UpperArm_BIP","P_Batricia_D_Forearm_BIP", \
"P_Batricia_G_UpperArm_BIP", "P_Batricia_G_Forearm_BIP", "P_Batricia_Spine_BIP", "P_Batricia_G_Main_Auriculaire_03_CTRL","P_Batricia_G_Main_Auriculaire_01_CTRL", \
"P_Batricia_D_Main_Auriculaire_01_CTRL", "P_Batricia_D_Main_Auriculaire_03_CTRL", "P_Batricia_Pelvis_BIP", "P_Batricia_D_Paume_CTRL", "P_Batricia_G_Paume_CTRL")

for e in enum do
(
	res = getnodebyname (e + "_LAYOUT")
	selectmore res
)