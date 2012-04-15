accessing
concreteSubclassForType: command
	^ self allSubclasses
		detect: [ :subClass | subClass command = command ]
		ifNone: [ self error: 'Unrecognized command' ]