testing
testSimpleRpc
	| client server request response |
	"The server is a client listening on commands coming in on a queue named factorial"
	server := self client.
	[
		server open.
		server subscribeTo: 'factorial'.
		server runWith: [ :message | | number |
			message body = 'quit'
				ifTrue: [ ConnectionClosed signal ].
			number := message body asInteger.
			server sendText: number factorial asString to: message replyTo ] ] fork.
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
	client sendText: 'quit' to: 'factorial'.
	client close