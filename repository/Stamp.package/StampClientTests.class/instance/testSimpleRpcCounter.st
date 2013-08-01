testing
testSimpleRpcCounter
	| client server request response check |
	"The counter server listens to asynchroneous commands up, down and quit,
	as well as the synchroneous command value"
	server := self client.
	[ | subscription counter |
		server open.
		counter := 0.
		subscription := server newSubscriptionTo: 'counter'.
		server write: subscription subscribeFrame.
		[ server runWith: [ :message | | result |
			message body = #quit
				ifTrue: [ ConnectionClosed signal ].
			message body = #up
				ifTrue: [ counter := counter + 1 ].
			message body = #down
				ifTrue: [ counter := counter - 1 ].
			message body = #value
				ifTrue: [ 
					result := server newSendFrameTo: message replyTo.
					result text: counter asString.
					server write: result ] ] ]
				on: ConnectionClosed
				do: [ server close ] ] fork.
	client := self client.
	client open.
	"Helper block to access the current counter value synchroneously"
	check := [ 
		request := client newSendFrameTo: 'counter'.
		request text: 'value'.
		request replyTo: '/temp-queue/counter'.
		client write: request.
		response := client readMessage.
		response body asNumber ].
	self assert: check value equals: 0.
	100 timesRepeat: [ 
		client write: ((client newSendFrameTo: 'counter') text: 'up'; yourself) ].
	self assert: check value equals: 100.
	100 timesRepeat: [ 
		client write: ((client newSendFrameTo: 'counter') text: 'down'; yourself) ].
	self assert: check value equals: 0.
	request := client newSendFrameTo: 'counter'.
	request text: 'quit'.
	client write: request.
	client  close