accessing
readCount: count
	| client message subscription frame |
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
			message := frame body.
			out nextPut: (message copyUpTo: Character space) ].
		client write: subscription unsubscribeFrame ] ] ensure: [ client close ]