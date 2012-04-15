instance creation
new
	^ SingleInstance ifNil: [ SingleInstance := super new ]