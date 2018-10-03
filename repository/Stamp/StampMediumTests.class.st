"
I am StampMediumTests.

"
Class {
	#name : #StampMediumTests,
	#superclass : #TestCase,
	#category : 'Stamp-Tests'
}

{ #category : #testing }
StampMediumTests >> testReadLine [
	self assert: (StampMedium on: 'foo' asByteArray readStream) readLine = 'foo'.
	self assert: (StampMedium on: #[ ] readStream) readLine isEmpty.
	self assert: (StampMedium on: #[ 10 ] readStream) readLine isEmpty
]
