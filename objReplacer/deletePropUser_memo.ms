-- getUserPropBuffer $

fn deleteUserProp node prop = 
(
	if getUserProp node prop != undefined do
	(
		 buff = (getUserPropBuffer node) as stringStream 
		 newb = stringStream ""
		 while not eof buff do
		 (
			  str = readLine buff
			  if str != "" and not matchpattern str pattern:("*" + prop + "*=*") do format "%\n" str to:newb
		 )
		 setUserPropBuffer node (replace_LF_with_CRLF (newb as string))
	)
)

deleteUserProp $ "pivotFenetre"