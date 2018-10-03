"
I am StampClient.
I connect to a STOMP 1.2 server as a client to send and/or receive messages.

"
Class {
	#name : #StampClient,
	#superclass : #Object,
	#instVars : [
		'options',
		'medium',
		'connectFrame',
		'connectedFrame',
		'idGenerator',
		'heartbeat',
		'lastActivity',
		'inbox'
	],
	#category : 'Stamp-Client'
}

{ #category : #'initialize-release' }
StampClient >> clearInbox [
	inbox removeAll
]

{ #category : #'initialize-release' }
StampClient >> close [
	medium ifNotNil: [ 
		[ [ self disconnect ] on: ConnectionClosed, ConnectionTimedOut do: [ ] ]
			ensure: [ self closeMedium ].
		connectFrame := connectedFrame := nil ]
]

{ #category : #'initialize-release' }
StampClient >> closeIgnoringErrors [
	[ self close ] on: Error do: [  ]
]

{ #category : #private }
StampClient >> closeMedium [
	[ medium close ] on: Error do: [ ].
	medium := nil
]

{ #category : #accessing }
StampClient >> connectFrame [
	^ connectFrame ifNil: [
		connectFrame := StampConnectFrame new.
		connectFrame host: self virtualHost.
		self login ifNotNil: [ :value | connectFrame login: value ].
		self passcode ifNotNil: [ :value | connectFrame passcode: value ].
		self heartbeat ifNotNil: [ :value | connectFrame heartbeat: (Array with: value with: value) ].
		connectFrame ]
]

{ #category : #accessing }
StampClient >> connectedFrame [
	^ connectedFrame
]

{ #category : #options }
StampClient >> debug [
	^ self optionAt: #debug ifAbsent: [ false ]
]

{ #category : #options }
StampClient >> debug: boolean [
	self optionAt: #debug put: boolean
]

{ #category : #private }
StampClient >> disconnect [
	self writeWithReceipt: StampDisconnectFrame new
]

{ #category : #private }
StampClient >> failedToReadInTimeout [
	^ ConnectionTimedOut signal: 'Could not read matching message before timeout'
]

{ #category : #options }
StampClient >> heartbeat [
	^ self optionAt: #heartbeat ifAbsent: [ 60*1000 "milliseconds" ]
]

{ #category : #options }
StampClient >> heartbeat: milliseconds [
	self timeout * 1000 * 4 < milliseconds
		ifFalse: [ self error: 'heartbeat must be larger than 4 times the timeout' ].
	self optionAt: #heartbeat put: milliseconds
]

{ #category : #options }
StampClient >> host [
	^ self optionAt: #host ifAbsent: [ 'localhost' ]
]

{ #category : #options }
StampClient >> host: hostName [
	self optionAt: #host put: hostName
]

{ #category : #'initialize-release' }
StampClient >> initialize [
	super initialize.
	inbox := OrderedCollection new
]

{ #category : #testing }
StampClient >> isConnected [
	medium ifNil: [ ^ false ].
	^ self medium isConnected 
		and: [ self connectedFrame notNil ]
]

{ #category : #options }
StampClient >> login [
	^ self optionAt: #login ifAbsent: [ nil ]
]

{ #category : #options }
StampClient >> login: string [
	self optionAt: #login put: string
]

{ #category : #accessing }
StampClient >> medium [
	^ medium ifNil: [ 
		medium := StampMedium on: self socketStream ]
]

{ #category : #convenience }
StampClient >> newSendFrameTo: destination [
	^ StampSendFrame new
		destination: destination;
		yourself
]

{ #category : #convenience }
StampClient >> newSubscriptionTo: destination [
	^ StampSubscription new
		id: self nextId;
		destination: destination;
		yourself
]

{ #category : #convenience }
StampClient >> newTransaction [
	^ StampTransaction new
		id: self nextId;
		yourself
]

{ #category : #accessing }
StampClient >> nextId [
	idGenerator ifNil: [ idGenerator := 0 ]. 
	idGenerator := idGenerator + 1.
	^ 'stamp-client-id-', idGenerator asString
]

{ #category : #'initialize-release' }
StampClient >> open [
	self close.
	self write: self connectFrame.
	connectedFrame  := self readSuchThat: [ :frame | frame command = #CONNECTED ].
	self setActualHeartbeat.
	connectFrame acceptVersion = connectedFrame version
		ifFalse: [ self error: 'Incompatible STOMP version' ].
	^ self isConnected
]

{ #category : #accessing }
StampClient >> optionAt: key ifAbsent: block [
	"Return my option/settings stored under key.
	Execute block if I have no such option/setting.
	This is a generic interface, see my options protocol for specific usages."

	options ifNil: [ ^ block value ].
	^ options at: key ifAbsent: block
]

{ #category : #accessing }
StampClient >> optionAt: key put: value [
	"Set my option/setting identified by key to be value.
	This is a generic interface, see my options protocol for specific usages."
	
	options ifNil: [ options := Dictionary new ].
	options at: key put: value
]

{ #category : #options }
StampClient >> passcode [
	^ self optionAt: #passcode ifAbsent: [ nil ]
]

{ #category : #options }
StampClient >> passcode: string [
	self optionAt: #passcode put: string
]

{ #category : #options }
StampClient >> port [
	^ self optionAt: #port ifAbsent: [ StampConstants defaultPort ]
]

{ #category : #options }
StampClient >> port: integer [
	self optionAt: #port put: integer
]

{ #category : #printing }
StampClient >> printOn: stream [
	super printOn: stream.
	stream nextPut: $(.
	stream << self host; nextPut: $:; print: self port; space; << self virtualHost.
	stream space; << (self isConnected ifTrue: [ 'connected' ] ifFalse: [ 'not connected' ]).
	stream nextPut: $)
]

{ #category : #reading }
StampClient >> read [
	^ self readSuchThat: [ :frame | true ]
]

{ #category : #reading }
StampClient >> readFromInboxSuchThat: block [
	| frame |
	frame := inbox detect: block ifNone: [ ^ nil ].
	inbox remove: frame.
	^ frame

]

{ #category : #reading }
StampClient >> readMessage [
	^ self readSuchThat: [ :frame | frame command = #MESSAGE ]
]

{ #category : #reading }
StampClient >> readNextFrame [
	| frame |
	frame := StampFrame readFrom: self medium.
	self touch.
	^ frame command = #ERROR
		ifTrue: [ StampError signalFor: frame ]
		ifFalse: [ frame ]
]

{ #category : #reading }
StampClient >> readSuchThat: block [
	| frame started |
	self writeHeartbeatIfNeeded.
	(self readFromInboxSuchThat: block) ifNotNil: [ :found | ^ found ].
	started := Time millisecondClockValue.
	[
		frame := self readNextFrame.
		StampFrameReadEvent new frame: frame; emit.
		frame command isEmpty
			ifFalse: [ 
				(block value: frame)
					ifTrue: [ ^ frame ]
					ifFalse: [ inbox add: frame ] ].
		(Time millisecondsSince: started) / 1000 > self timeout
			ifTrue: [ ^ self failedToReadInTimeout ] ] repeat
]

{ #category : #reading }
StampClient >> runWith: block [
	"Enter a loop reading messages, ignoring ConnectionTimedOut.
	Block is evaluated for each incoming message.
	When the loop ends, the receiver is #close-ed.
	ConnectionClosed can be signalled to exit the loop"
	
	[ [ [ 
		[ block value: self readMessage ]
			on: ConnectionTimedOut  
			do: [ "Ignore & continue" ] 
	] repeat
	] ensure: [ self close ]
	] on: ConnectionClosed do: [ "Ignore" ]
]

{ #category : #convenience }
StampClient >> sendText: string to: destination [
	| sendFrame |
	sendFrame := self newSendFrameTo: destination.
	sendFrame text: string.
	self write: sendFrame
]

{ #category : #accessing }
StampClient >> session [
	^ self connectedFrame 
		ifNotNil: [ self connectedFrame session ]
]

{ #category : #private }
StampClient >> setActualHeartbeat [
	| clientHeartbeat serverHeartbeat |
	clientHeartbeat := connectFrame heartbeat.
	serverHeartbeat := connectedFrame heartbeat.
	heartbeat := clientHeartbeat first max: serverHeartbeat second.
	"0 means client doesn't want it or server cannot deliver it"
	heartbeat isZero ifTrue: [ heartbeat := nil ].
	^ heartbeat 
]

{ #category : #private }
StampClient >> socketStream [
	| socketStream |
	socketStream := ZdcSocketStream 
		openConnectionToHostNamed: self host 
		port: self port.
	socketStream 
		binary; 
		timeout: self timeout;
		autoFlush: false.
	^ socketStream
]

{ #category : #convenience }
StampClient >> subscribeTo: destination [
	| subscription |
	subscription := self newSubscriptionTo: destination.
	self write: subscription subscribeFrame.
	^ subscription
]

{ #category : #options }
StampClient >> timeout [
	^ self optionAt: #timeout ifAbsent: [ 1 "second" ]
]

{ #category : #options }
StampClient >> timeout: seconds [
	self optionAt: #timeout put: seconds
]

{ #category : #private }
StampClient >> touch [
	lastActivity := Time millisecondClockValue 
]

{ #category : #options }
StampClient >> virtualHost [
	^ self optionAt: #virtualHost ifAbsent: [ '/' ]
]

{ #category : #options }
StampClient >> virtualHost: hostName [
	self optionAt: #virtualHost put: hostName
]

{ #category : #private }
StampClient >> wasInactiveForTooLong [
	^ (Time millisecondsSince: lastActivity) > (heartbeat - (self timeout * 1000 * 2))
]

{ #category : #writing }
StampClient >> write: frame [
	self writeNoFlush: frame.
	self medium flush
]

{ #category : #writing }
StampClient >> writeHeartbeat [
	self write: StampEmptyFrame new
]

{ #category : #private }
StampClient >> writeHeartbeatIfNeeded [
	heartbeat ifNil: [ ^ nil ].
	self wasInactiveForTooLong
		ifTrue: [ self writeHeartbeat ]
]

{ #category : #writing }
StampClient >> writeNoFlush: frame [
	frame writeOn: self medium.
	self touch.
	StampFrameWrittenEvent new frame: frame; emit

]

{ #category : #writing }
StampClient >> writeWithReceipt: outgoingFrame [
	| receiptId |
	receiptId := self nextId.
	outgoingFrame receipt: receiptId.
	self write: outgoingFrame.
	self readSuchThat: [ :frame | 
		frame command = #RECEIPT and: [ frame receiptId = receiptId ] ]
]
