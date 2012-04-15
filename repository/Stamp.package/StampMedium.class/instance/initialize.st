initialize-release
initialize
	super initialize.
	encoder := ZnUTF8Encoder new.
	charsToEscape := { Character linefeed. $:. $\ }.