testing
testSimpleWorkQueue
	| processor1 processor2 client quit processed1 processed2 all |
	"Processor 1 & 2 listen for dummy work, waiting a number of milliseconds, failing on an odd or even count"
	quit := false.
	processed1 := SortedCollection new.
	processor1 := self client.
	processor1 open.
	[ | subscription |
		subscription := processor1 newSubscriptionTo: 'work'.
		subscription clientIndividualAck.
		processor1 write: subscription subscribeFrame.
		processor1 runWith: [ :message | | number |
			quit ifTrue: [ ConnectionClosed signal ].
			number := message body asInteger.
			(Delay forMilliseconds: number) wait.
			number even 
				ifTrue: [ 
					processed1 add: number. 
					processor1 write: message ackFrame ] 
				ifFalse: [ 
					processor1 write: message nackFrame ] ] ] fork.
	processed2 := SortedCollection new.
	processor2 := self client.
	processor2 open.
	[ | subscription |
		subscription := processor2 newSubscriptionTo: 'work'.
		subscription clientIndividualAck.
		processor2 write: subscription subscribeFrame .
		processor2 runWith: [ :message | | number |
			quit ifTrue: [ ConnectionClosed signal ].
			number := message body asInteger.
			(Delay forMilliseconds: number) wait.
			number odd
				ifTrue: [ 
					processed2 add: number.
					processor2 write: message ackFrame ] 
				ifFalse: [ 
					processor2 write: message nackFrame ] ] ] fork.
	all := SortedCollection new.
	client := self client.
	client open.
	100 timesRepeat: [ | number work |
		number := 10 atRandom .
		all add: number.
		work := client newSendFrameTo: 'work'.
		work text: number asString.
		client writeWithReceipt: work ].
	"wait at most 5 seconds"
	50 timesRepeat: [ 
		processed1 size + processed2 size >= 100 
			ifFalse: [ 0.1 second asDelay wait ] ].
	quit := true.
	client close.
	self assert: (processed1 allSatisfy: [ :each | each even ]).
	self assert: (processed2 allSatisfy: [ :each | each odd ]).
	self assert: processed1 , processed2 equals: all