instance creation
readFrom: stampMedium
	| command |
	command := stampMedium readLine.
	^ command isEmpty
		ifTrue: [ 
			StampEmptyFrame new ]
		ifFalse: [
			(self concreteSubclassForType: command) new
				readFrom: stampMedium;
				yourself ]