accessing
session
	^ self connectedFrame 
		ifNotNil: [ self connectedFrame session ]