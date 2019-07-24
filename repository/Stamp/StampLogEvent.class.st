"
I am StampLogEvent, the base class of a log events emitted by elements of the Stamp framework.

I add a timestamp and a simple id attribute. The id can wrap around and should only be used to distinguish between events that have the same timestamp.

StampLogEvents are distributed as Announcement through a singleton Announcer that I maintain.

I have a small convenience API to log to the Transcript or open a simple GUI on the emitted log events.
"
Class {
	#name : #StampLogEvent,
	#superclass : #Announcement,
	#instVars : [
		'timestamp',
		'id'
	],
	#classVars : [
		'IdCounter',
		'LogEventAnnouncer'
	],
	#category : 'Stamp-Logging'
}

{ #category : #accessing }
StampLogEvent class >> announcer [
	^ LogEventAnnouncer ifNil: [ LogEventAnnouncer := Announcer new ]
]

{ #category : #'class initialization' }
StampLogEvent class >> initialize [
	IdCounter := 0.
	Smalltalk addToStartUpList: self
]

{ #category : #convenience }
StampLogEvent class >> logToTranscript [
	<doc: ' Start logging messages into transcript'>
	self stopLoggingToTranscript.
	^ self announcer when: self send: #crShow: to: Transcript
]

{ #category : #accessing }
StampLogEvent class >> nextId [
	"This should be thread safe because SmallInteger 
	arithmetic primitives cannot be interrupted"
	
	^ IdCounter := IdCounter + 1
]

{ #category : #convenience }
StampLogEvent class >> open [
	^ self announcer open
]

{ #category : #'system startup' }
StampLogEvent class >> startUp [
	"Reset the id counter"
	
	IdCounter := 0
]

{ #category : #convenience }
StampLogEvent class >> stopLoggingToTranscript [
	<doc: ' Stops logging messages into transcript'>
	self announcer unsubscribe: Transcript
]

{ #category : #accessing }
StampLogEvent >> announcer [
	^ self class announcer
]

{ #category : #actions }
StampLogEvent >> emit [
	self announcer announce: self
]

{ #category : #accessing }
StampLogEvent >> id [
	^ id
]

{ #category : #initialize }
StampLogEvent >> initialize [
	super initialize.
	timestamp := DateAndTime  now.
	id := self nextId
]

{ #category : #accessing }
StampLogEvent >> nextId [
	^ self class nextId
]

{ #category : #printing }
StampLogEvent >> printContentsOn: stream [
	"Subclasses should implement this to add output"
]

{ #category : #printing }
StampLogEvent >> printOn: stream [
	timestamp printYMDOn: stream.
	stream space.
	timestamp printHMSOn: stream. 
	stream space.
	id \\ 1000 printOn: stream base: 10 length: 3 padded: true.
	stream space.
	self printContentsOn: stream
]

{ #category : #beacon }
StampLogEvent >> printOneLineContentsOn: stream [
	self printContentsOn: stream
]

{ #category : #beacon }
StampLogEvent >> printOneLineOn: stream [
	self printOn: stream
]

{ #category : #accessing }
StampLogEvent >> timestamp [
	^ timestamp
]
