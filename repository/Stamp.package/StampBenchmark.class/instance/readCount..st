running
readCount: count
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