

rollout test_bitmaps "Testing Bitmap" 
(
-- 	planPath = "W:\Marignan\Montpellier_1024\Perspective\Perspective\Textures\plans_jpg\Pieces graphique PC Maurice CHAUVET-3.jpg"
	local planPath = @"W:\Marignan\Montpellier_1024\Perspective\Perspective\Textures\plans_jpg\Pieces graphique PC Maurice CHAUVET-2.jpg"
	bitmap the_bmp fileName: planPath
-- 	bitmap BitmapImage bitmap:(bitmap 50 50 color:blue)
)
createDialog test_bitmaps


planPath = @"W:\Marignan\Montpellier_1024\Perspective\Perspective\Textures\plans_jpg\Pieces graphique PC Maurice CHAUVET-3.jpg"
-- doesFileExist planPath




bmptmp = openBitMap planPath 
bmptmp.height
bmptmp.width
display bmptmp

selectBitMap ()