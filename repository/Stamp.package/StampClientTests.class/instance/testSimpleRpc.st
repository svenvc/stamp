testing
testSimpleRpc
	| client server request response |
	"The server is a client listening on commands coming in on a queue named factorial"
	server := self client.
	[ | subscription |
		server open.
		subscription := server newSubscriptionTo: 'factorial'.
		server write: subscription subscribeFrame.
		[ server runWith: [ :message | | number result |
			message body = 'quit'
				ifTrue: [ ConnectionClosed signal ].
			number := message body asInteger.
			result := server newSendFrameTo: message replyTo.
			result text: number factorial asString.
			server write: result ] ]
				on: ConnectionClosed
				do: [ server close ] ] fork.
	client := self client.
	client open.
	10 to: 20 do: [ :each |
		request := client newSendFrameTo: 'factorial'.
		request text: each asString.
		request replyTo: '/temp-queue/factorial'.
		client write: request.
		"Wait up to standard timeout for a reply"
		response := client readMessage.
		self assert: response body equals: each factorial asString ].
	request := client newSendFrameTo: 'factorial'.
	request text: 'quit'.
	client write: request.
	client close