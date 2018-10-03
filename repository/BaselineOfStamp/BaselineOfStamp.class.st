Class {
	#name : #BaselineOfStamp,
	#superclass : #BaselineOf,
	#category : 'BaselineOfStamp'
}

{ #category : #baselines }
BaselineOfStamp >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec 
			package: 'Stamp' ]

]
