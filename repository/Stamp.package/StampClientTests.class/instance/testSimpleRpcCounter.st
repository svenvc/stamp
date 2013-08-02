testing
testSimpleRpcCounter
	| client server request response check |
	"The counter server listens to asynchroneous commands up, down and quit,
	as well as the synchroneous command value"
	server := self client.
	[ | counter |
		server open.
		counter := 0.
		server subscribeTo: 'counter'.
		server runWith: [ :message |
			message body = #quit
				ifTrue: [ ConnectionClosed signal ].
			message body = #up
				ifTrue: [ counter := counter + 1 ].
			message body = #down
				ifTrue: [ counter := counter - 1 ].
			message body = #value
				ifTrue: [ server sendText: counter asString to: message replyTo ] ] ] fork.
	client := self client.
	client open.
	"Helper to access the current counter value synchroneously"
	check := [ 
		request := client newSendFrameTo: 'counter'.
		request text: 'value'.
		request replyTo: '/temp-queue/counter'.
		client write: request.
		response := client readMessage.
		response body asNumber ].
	self assert: check value equals: 0.
	100 timesRepeat: [ 
		client sendText: 'up' to: 'counter' ].
	self assert: check value equals: 100.
	100 timesRepeat: [ 
		client sendText: 'down' to: 'counter' ].
	self assert: check value equals: 0.
	client sendText: 'quit' to: 'counter'.
	client close