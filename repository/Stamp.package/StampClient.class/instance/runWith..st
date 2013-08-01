reading
runWith: block
	"Enter a loop reading messages.
	Block is evaluated for each incoming message.
	ConnectionClosed can be signalled to exit the loop"
	
	[ 
		[ block value: self readMessage ]
			on: ConnectionTimedOut  
			do: [ "Ignore & continue" ] 
	] repeat