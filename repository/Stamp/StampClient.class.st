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
	#category : #'Stamp-Client'
}

{ #category : #'initialize-release' }
StampClient >> clearInbox [
	<doc: 'Cleans up the inbox, by simply removing all the received messages'>
	inbox removeAll
]

{ #category : #'initialize-release' }
StampClient >> close [
	<doc: 'It disconnect the client by informing the remote manager. It also closes the companion medium'>
	medium ifNotNil: [ 
		[ [ self disconnect ] on: ConnectionClosed, ConnectionTimedOut do: [ ] ]
			ensure: [ self closeMedium ].
		connectFrame := connectedFrame := nil ]
]

{ #category : #'initialize-release' }
StampClient >> closeIgnoringErrors [
	<doc: 'It informs the disconnection to the manager. It also closes the companion medium; It ignores all kind of error'>
	[ self close ] on: Error do: [  ]
]

{ #category : #private }
StampClient >> closeMedium [
	<doc: 'It  closes the companion medium. It ignores all kind of error'>
	[ medium close ]
		on: Error
		do: [  ].
	medium := nil
]

{ #category : #accessing }
StampClient >> connectFrame [
	<doc:'It access the connectFrame. It implements a lazy initialization. It configures the creation of the connectFrame by using the, previously setted, properties: login, passcode, heartbeat and virtualHost'>
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
	<doc: 'Option-Property. It gets the option debug. The default value is False'>
	^ self optionAt: #debug ifAbsent: [ false ]
]

{ #category : #options }
StampClient >> debug: boolean [
	<doc: 'Option-Property. It sets the option debug. Boolean expected'>
	self optionAt: #debug put: boolean
]

{ #category : #private }
StampClient >> disconnect [
	<doc: 'It disconnect the client by informing the remote manager.'>
	self writeWithReceipt: StampDisconnectFrame new
]

{ #category : #private }
StampClient >> failedToReadInTimeout [
	^ ConnectionTimedOut signal: 'Could not read matching message before timeout'
]

{ #category : #options }
StampClient >> heartbeat [
	<doc: 'Option-Property. It returns the hearbeat rate.60*1000 "milliseconds" by default '>
	^ self optionAt: #heartbeat ifAbsent: [ 60 * 1000	 "milliseconds" ]
]

{ #category : #options }
StampClient >> heartbeat: milliseconds [
	<doc: 'Option-Property. It sets the option heartbeat. Value expected in milliseconds.  The value of the heartbeat should be at least 4 times the timeout property'>
	self timeout * 1000 * 4 < milliseconds
		ifFalse: [ self error: 'heartbeat must be larger than 4 times the timeout' ].
	self optionAt: #heartbeat put: milliseconds
]

{ #category : #options }
StampClient >> host [
	<doc: 'Option-Property. Gets the host property. By default, is localhost'>
	^ self optionAt: #host ifAbsent: [ 'localhost' ]
]

{ #category : #options }
StampClient >> host: hostName [
	<doc: 'Option-Property. Sets the host property. (Name/IP expected) '>
	self optionAt: #host put: hostName
]

{ #category : #'initialize-release' }
StampClient >> initialize [
	super initialize.
	inbox := OrderedCollection new
]

{ #category : #testing }
StampClient >> isConnected [
	<doc:'Informs if the client is connected.'>
	medium ifNil: [ ^ false ].
	^ self medium isConnected 
		and: [ self connectedFrame notNil ]
]

{ #category : #options }
StampClient >> login [
	<doc: 'Option-Property. Gets the user name for login the remote queue manager. The default value is nil'>
	^ self optionAt: #login ifAbsent: [ nil ]
]

{ #category : #options }
StampClient >> login: string [
	<doc:
		'Option-Property. Sets the user name for login the remote queue manager'>
	self optionAt: #login put: string
]

{ #category : #accessing }
StampClient >> medium [
	<doc:
		'Access the medium object. It Lazily created it if is not yet created. This initialization creates a socket stream, that requires the host and port of the manager'>
	^ medium ifNil: [ medium := StampMedium on: self socketStream ]
]

{ #category : #convenience }
StampClient >> newSendFrameTo: destination [
	<doc: 'Creates a default SendFrame for communicating a message to the given destination (queue name) ' >
	^ StampSendFrame new
		destination: destination;
		yourself
]

{ #category : #convenience }
StampClient >> newSubscriptionTo: destination [
	<doc: 'Creates a default SubscriptionFrame for subscribing to the given destination (queue name)' >
	^ StampSubscription new
		id: self nextId;
		destination: destination;
		yourself
]

{ #category : #convenience }
StampClient >> newTransaction [
	<doc: 'Creates a default TransactionFrame '>
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
	<doc: 'It connects the queue manager. It ensures that the client is not connected (closing the ongoing connection if there is any). '>
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
	<doc:
		'Option-Property. Gets the password for login the remote queue manager. The default value is nil'>
	^ self optionAt: #passcode ifAbsent: [ nil ]
]

{ #category : #options }
StampClient >> passcode: string [
	<doc:
		'Option-Property. Sets the password for login the remote queue manager. '>
	self optionAt: #passcode put: string
]

{ #category : #options }
StampClient >> port [
<doc: 'Option-Property. Gets the port for connecting the remote queue manager. The default value is StampConstants defaultPort '>
	^ self optionAt: #port ifAbsent: [ StampConstants defaultPort ]
]

{ #category : #options }
StampClient >> port: integer [
	<doc: 'Option-Property. Sets the port for connecting the remote queue manager. T'>
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
	<doc: 'It reads the next frame, and returns it regardless the kind'>
	^ self readSuchThat: [ :frame | true ]
]

{ #category : #reading }
StampClient >> readFromInboxSuchThat: block [
	<doc:
		'It reads from the inbox, any frame that responds positively to the given block'>
	| frame |
	frame := inbox detect: block ifNone: [ ^ nil ].
	inbox remove: frame.
	^ frame
]

{ #category : #reading }
StampClient >> readMessage [
	<doc: 'It reads the next frame that responds to the command command #MESSAGE.'>
	^ self readSuchThat: [ :frame | frame command = #MESSAGE ]
]

{ #category : #reading }
StampClient >> readNextFrame [
	<doc:
		'It reads the next frame from the actual medium. In case of ERROR frame, it signals an error.'>
	| frame |
	frame := StampFrame readFrom: self medium.
	self touch.
	^ frame command = #ERROR
		ifTrue: [ StampError signalFor: frame ]
		ifFalse: [ frame ]
]

{ #category : #reading }
StampClient >> readSuchThat: block [
	<doc:
		'
		This method checks first in the inbox for any frame that responds to the given block. 
		If none frame is found in the inbox, it follows up by reading from the manager next frames up to find a frame that responds positively to the given block. 
		All the frames that are not accepted by the block are sequentially added to the inbox, for further usage. 
		This call may fail by Timeout.
		'>
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
	<doc:'Enter a loop reading messages, ignoring ConnectionTimedOut. Block is evaluated for each incoming message. When the loop ends, the receiver is #close-ed. ConnectionClosed can be signalled to exit the loop'>
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
	<doc:
		'It writes a SendFrame to the given destination with the given string (text) message '>
	| sendFrame |
	sendFrame := self newSendFrameTo: destination.
	sendFrame text: string.
	self write: sendFrame
]

{ #category : #accessing }
StampClient >> session [
	<doc:
		'Gets the session id from the connectedFrame. It returns nil on a non-connected client'>
	^ self connectedFrame ifNotNil: [ self connectedFrame session ]
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
	<doc: 'It writes a SubscriptionFrame to subscribe to the given destination (queue name)' >
	subscription := self newSubscriptionTo: destination.
	self write: subscription subscribeFrame.
	^ subscription
]

{ #category : #options }
StampClient >> timeout [
	<doc:
		'Option-Property. Gets the timeout for the communication with the remote queue manager. The default value is 1 second'>
	^ self optionAt: #timeout ifAbsent: [ 1	"second" ]
]

{ #category : #options }
StampClient >> timeout: seconds [
	<doc:
		'Option-Property. Sets the timeout for the communication with the remote queue manager. The expected value is in seconds'>
	self optionAt: #timeout put: seconds
]

{ #category : #private }
StampClient >> touch [
	lastActivity := Time millisecondClockValue 
]

{ #category : #options }
StampClient >> virtualHost [
	<doc:
		'Option-Property. Gets the virtualhost for stablishing connectionwith the remote queue manager. The default value is / '>
	^ self optionAt: #virtualHost ifAbsent: [ '/' ]
]

{ #category : #options }
StampClient >> virtualHost: hostName [
	<doc:
		'Option-Property Sets the virtualhost for stablishing connectionwith the remote queue manager. This value will be concatenated to the host during the connection phase. '>
	self optionAt: #virtualHost put: hostName
]

{ #category : #private }
StampClient >> wasInactiveForTooLong [
	^ (Time millisecondsSince: lastActivity) > (heartbeat - (self timeout * 1000 * 2))
]

{ #category : #writing }
StampClient >> write: frame [
	<doc: 'Writes a given frame and flushes the connection' >
	self writeNoFlush: frame.
	self medium flush
]

{ #category : #writing }
StampClient >> writeHeartbeat [
	<doc: 'Writes an empty frame as a heartbeat' >
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
	<doc: 'Writes a given frame without flushing. After writting, it emits a StampFrameWrittenEvent announcement' >
	frame writeOn: self medium.
	self touch.
	StampFrameWrittenEvent new frame: frame; emit

]

{ #category : #writing }
StampClient >> writeWithReceipt: outgoingFrame [
	| receiptId |
	<doc: 'Writes a given frame and flushes the connection. It waits for a receipts of the message ' >
	receiptId := self nextId.
	outgoingFrame receipt: receiptId.
	self write: outgoingFrame.
	self readSuchThat: [ :frame | 
		frame command = #RECEIPT and: [ frame receiptId = receiptId ] ]
]
