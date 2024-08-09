dirname = @"M:\Biblio\VISIOLAB\2-Assets3D\Elements_batiments\Ouvrants\Fenetres\"

sel = selection as Array
basename
for s in sel where isgrouphead s do
(
	basename = s.name
)

savenodes sel (dirname + basename)