"
I am StampBenchmark.

Text messages (UTF-8):

[ StampBenchmark new writeCount: 1000 ofSize: 1024 ] timeToRun.

[ StampBenchmark new readCount: 1000 ] timeToRun.

[ StampBenchmark new writeNoReceiptCount: 1000 ofSize: 1024 ] timeToRun.

[ StampBenchmark new readNoAckCount: 1000 ] timeToRun.

Binary messages:

[ StampBenchmark new binary; writeCount: 1000 ofSize: 1024 ] timeToRun.

[ StampBenchmark new binary; readCount: 1000 ] timeToRun.

[ StampBenchmark new binary; writeNoReceiptCount: 1000 ofSize: 1024 ] timeToRun.

[ StampBenchmark new binary; readNoAckCount: 1000 ] timeToRun.

"
Class {
	#name : #StampBenchmark,
	#superclass : #Object,
	#instVars : [
		'binary',
		'message'
	],
	#category : 'Stamp-Tests'
}

{ #category : #'initialize-release' }
StampBenchmark >> binary [
	binary := true
]

{ #category : #accessing }
StampBenchmark >> client [
	| client |
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
	"client debug: true."
	^ client
]

{ #category : #'initialize-release' }
StampBenchmark >> initialize [
	super initialize.
	binary := false
]

{ #category : #accessing }
StampBenchmark >> messageOfSize: size [
	^ message
		ifNil: [ 
			message := binary
				ifTrue: [ self randomBytes: size ]
				ifFalse: [ self randomString: size ] ]
]

{ #category : #accessing }
StampBenchmark >> messageOfSize: size tag: number [
	(self messageOfSize: size) writeStream nextPutAll: (self tag: number).
	^ message
]

{ #category : #accessing }
StampBenchmark >> queue [
	^ '/queue/stamp-benchmark'
]

{ #category : #private }
StampBenchmark >> randomBytes: size [
	^ ByteArray new: size streamContents: [ :out |
		 size timesRepeat: [ 
			out nextPut: 100 atRandom ] ]
]

{ #category : #private }
StampBenchmark >> randomString: size [
	^ String new: size streamContents: [ :out |
		 size timesRepeat: [ 
			out nextPut: 'abcdefghijklmnopqrstuvwxyz' atRandom ] ]
]

{ #category : #running }
StampBenchmark >> readCount: count [
	| client subscription frame |
	client := self client.
	^ [ 
	client open.
	subscription := client newSubscriptionTo: self queue.
	subscription clientIndividualAck.
	client write: subscription subscribeFrame.
	Array new: count streamContents: [ :out |
		1 to: count do: [ :each | 
			frame := client read.
			client write: frame ackFrame.
			out nextPut: frame body ].
		client write: subscription unsubscribeFrame ] ] ensure: [ client close ]
]

{ #category : #running }
StampBenchmark >> readNoAckCount: count [
	| client subscription frame |
	client := self client.
	^ [ 
	client open.
	subscription := client newSubscriptionTo: self queue.
	client write: subscription subscribeFrame.
	Array new: count streamContents: [ :out |
		1 to: count do: [ :each | 
			frame := client read.
			out nextPut: frame body ].
		client write: subscription unsubscribeFrame ] ] ensure: [ client close ]
]

{ #category : #accessing }
StampBenchmark >> sendFrameOfSize: size tag: number for: client [
	| frame body |
	frame := client newSendFrameTo: self queue.
	body := self messageOfSize: size tag: number.
	binary
		ifTrue: [ frame bytes: body ]
		ifFalse: [ frame text: body ].
	^ frame
]

{ #category : #accessing }
StampBenchmark >> tag: number [
	^ binary
		ifTrue: [ number asByteArray, #[ 0 0 ] ]
		ifFalse: [ number asString, '  ' ]
]

{ #category : #running }
StampBenchmark >> writeCount: count ofSize: size [
	| client frame |
	client := self client.
	^ [ 
	client open.
	1 to: count do: [ :each | 
		frame := self sendFrameOfSize: size tag: each for: client. 
		client writeWithReceipt: frame ].
	count ] ensure: [ client close ]
]

{ #category : #running }
StampBenchmark >> writeNoReceiptCount: count ofSize: size [
	| client frame |
	client := self client.
	^ [ 
	client open.
	1 to: count do: [ :each | 
		frame := self sendFrameOfSize: size tag: each for: client. 
		client writeNoFlush: frame ].
	count ] ensure: [ client close ]
]
