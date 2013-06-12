initialize-release
initialize
	super initialize.
	encoder := ZnUTF8Encoder new.
	charsToEscape := ByteString withAll: { Character linefeed. $:. $\ }.