rollout DotNetTest ".Net UI on MXS Form"
 (
 	
 	dotnetcontrol mbutton "System.Windows.Forms.Button" height:60 width:80 pos:[5,5]
 	dotnetcontrol mbutton2 "System.Windows.Forms.Button" height:60 width:80 pos:[88,5]
 		
 	on dotnettest open do
 	(
 	mcolor = dotnetclass "System.drawing.color" 
 	malign = dotnetclass "System.Drawing.ContentAlignment"
 		
 	maxBackColor = colorMan.getColor #background
 	DotNetBackColor = mColor.FromArgb (maxBackColor[1] * 255.0f) (maxBackColor[2] * 255.0f) (maxBackColor[3] * 255.0f)
	/*
 	imageclass = dotNetclass "System.Drawing.image"		
 	-- load bitmaps 
 	IListimage1 = imageclass.fromfile (LRUIdir+"zfstart.bmp")
 	IListimage2 = imageclass.fromfile (LRUIdir+"zfstop.bmp")
 	--create an imagelist
 	imglist = dotnetobject "System.Windows.Forms.ImageList"
 	imglist.imagesize =  dotnetobject "System.Drawing.Size" 64 35
 	--add them to the image list
 	imglist.images.add ilistimage1
 	imglist.images.add ilistimage2
 	imglist.TransparentColor = mcolor.white			
	*/
 	mbutton.text = "Add Start"
 	mbutton.flatstyle = dotnetobject "System.Windows.Forms.FlatStyle" Flat
 	mButton.TextAlign = malign.BottomCenter
 	mbutton.imagealign = malign.topcenter
 	mbutton.FlatAppearance.MouseOverBackColor = mcolor.limegreen
 	mbutton.backcolor = mcolor.darkviolet
 	
 	mButton2.text = "Add Stop"
 	mbutton2.flatstyle = dotnetobject "System.Windows.Forms.FlatStyle" Flat
 	mbutton2.imagealign = malign.topcenter
 	mButton2.TextAlign = malign.bottomCenter
 	mbutton2.FlatAppearance.MouseOverBackColor = mcolor.coral
 	mbutton2.backcolor = DotNetBackColor
 		
 	mbutton.ImageIndex = 0
 	mbutton.ImageList = ImgList
 	mbutton2.imageindex = 1
 	mbutton2.ImageList = ImgList
 	)
 	
 	on mbutton click do 
 	(
 	print "start pressed"
 	)
 	
 	on mbutton2 click do 
 	(
 	print "stop pressed"
 	)
 
 )
 createdialog dotnettest 175 80 style:#(#style_toolwindow, #style_sysmenu) 