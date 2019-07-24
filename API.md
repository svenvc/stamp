# Stamp - Generated Doc
## Manifest
Stamp is an implementation of STOMP (Simple (or Streaming) Text Oriented Message Protocol) for Pharo, a protocol to interact with message-oriented middleware (MOM).
More specifically, Stamp implements STOMP 1.2 and was tested against RabbitMQ 3.1. Other message-oriented middleware implementations accessible through STOMP include Apache ActiveMQ, Glassfish Open MQ and Fuse Message Broker based on Active MQ - but these have not yet been tested.
Messaging middleware is an important technology for building scaleable and flexible enterprise software architectures.

## Project Examples
```smalltalk
exampleSimpleSendRecvWithReceipt
	| client frame receiptId |
"
This example is based on the test testSimpleSendReceiveWithReceipts. 
This example illustrates how to use the #receipt feature. 
The receipt features serves to ensure the reception of a message to the queue. 
"
" Creates a client for interacting with a default RabbitMQ installation"
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
" Open the client connection "
	client open.
" Create a send frame, and setup the destination and message. Note that the message has the extra confiration of #receipt:. The identifier passed will be used in the #RECEIPT message sent by the RabbitMQ "
	(frame := StampSendFrame new)
		destination: '/queue/helloworld';
		text: 'Hello World from Stamp, the Pharo STOMP client';
		receipt: (receiptId := client nextId).
" Writes the message "
	client write: frame.
" Note that in this example we use read instead of readMessage. Because the #RECEIPT frame is not a message . "
	frame := client read.
" Some asserts to make the point  "
	self assert: frame command = #RECEIPT.
	self assert: frame receiptId = receiptId.
" Finishes the connection "
	client close
```
```smalltalk
exampleConnectForDebug
	| client |
" Creates a client for interacting with a default RabbitMQ installation"
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
" Sets it into debug mode "
	client debug: true.
" Open the client connection "
	client open.
	^ client
	
```
```smalltalk
exampleSimpleSendRecv
	| client frame destination subscriptionId |
" Creates a client for interacting with a default RabbitMQ installation"
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
" Open the client connection "
	client open.
" Create a send frame, and setup the destination and message "
	(frame := StampSendFrame new)
		destination: (destination := '/queue/helloworld');
		text: 'Hello World from Stamp, the Pharo STOMP client'.
" Writes the message "
	client write: frame.
" Create a subcsription frame, and setup the destination id "
	(frame := StampSubscribeFrame new)
		destination: destination;
		id: (subscriptionId := client nextId);
		autoAck.
" Writes the subscription "
	client write: frame.
" After subscribed it can read the messages from the same queue "
	frame := client readMessage.
" Finally, it prepares an unsubscription frame "
	(frame := StampUnsubscribeFrame new) id: subscriptionId.
" It writes the unsubscription  "
	client write: frame.
" Finishes the connection "
	client close
```
```smalltalk
exampleSimpleRpc
	| factorialConsumer factorialService request response |
" This example sets up a client named factorialService.
FactorialService is configured to consume numbers, and respond with the factorial of this received number. 
This example also sets up a client named factorialConsumer.
FactorialConsumer is configured to send numbers and log the factorial of the received result.
This example is based on the test testSimpleRpc. "
"====== factorialService side ======
Creates a StampClient for the default RabbitMQ installation"
	factorialService := StampClient new.
	factorialService login: 'guest'.
	factorialService passcode: 'guest'.
	
	[ 
" Open the connection "
	factorialService open.
" Subscribe to the queue factorial "
	factorialService subscribeTo: 'factorial'.
" Forks a #runWith: call. "
	factorialService
		runWith: [ :message | 
			| number |
" If the received message is quit, it stops the process by using the special exception #ConnectionClosed"
			message body = 'quit' ifTrue: [ 
				ConnectionClosed signal 
			].
" Otherwise, the message must by a number encoded as string "
			number := message body asInteger.
" Sends  the result of the calculation to the #replyTo queue "
			factorialService sendText: number factorial asString to: message replyTo 
		] ] fork.

"==== factorialConsumer side =====
Creates a StampClient for the default RabbitMQ installation "
	factorialConsumer := StampClient new.
	factorialConsumer login: 'guest'.
	factorialConsumer passcode: 'guest'.
	
" Open the connection "
	factorialConsumer open.
	10 to: 20 do: [ :each | 
" Creates a send frame targeting the queue #factorial "
		request := factorialConsumer newSendFrameTo: 'factorial'.
		
" It sets the each number asString in the text of the frame "
		request text: each asString.
		
" Sets up as replyTo queue /temp-queue/factorial "
		request replyTo: '/temp-queue/factorial'.
		
" Writes and flush the frame to the queue manager "
		factorialConsumer write: request.
		
" Wait up to standard timeout for a reply "
		response := factorialConsumer readMessage.
		
" Logs the response with the Transcript "
		Transcript logCr: response body.
		  
].
" Once the the loop is finished, it sends the #quit message to the factorial queue, allowing the process to finish "
	factorialConsumer sendText: 'quit' to: 'factorial'.
" Closes the factorialConsumer connection "
	factorialConsumer close
```
```smalltalk
exampleSubscribeToQueueForOneTaskAtTheTime
	| client subscription |
" Create a stamp client for the default RabbitMq installation "
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
" Open the client connection "
	client open.
" Create a subcription helper object pointing to a given queue "
	subscription := client newSubscriptionTo: 'queue'.
"
Set the prefetchCount to 1. 
This is a RabbitMQ extension. The prefetch count for all subscriptions is set to unlimited by default. This can be controlled by setting the prefetch-count header on SUBSCRIBE frames to the desired integer count.
"
	subscription prefetchCount: 1. 
"Writes the generated subscription frame, for starting listening on this queue "
	client write: subscription subscribeFrame.
"Writes the generated unsubscription frame, for canceling the subscription on this queue "
	client write: subscription unsubscribeFrame.	
	client close.
```
```smalltalk
exampleOnTransactionCommited
	| client frame  transaction  |
	
" 
This example targets to illustrate the usage of transactions, in the success case (Begin and commit).
This example is based on the test #testSimpleSendUsingTransactionReceive.
"
	"====== factorialService side ======
Creates a StampClient for the default RabbitMQ installation"
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
" Open the client connection "
	client open.
" Creates a new trasnaction object. This object will help us to orchestrate a transaction "
	transaction := client newTransaction.
" Write the beginFrame. This frame indicates the starting point of the transaction to the queuing system. 
It is recommended to ensure the reception of a receipt, that acknowledges the beginning of the transaction "
	client writeWithReceipt: transaction beginFrame.
" After the begin of the transaction, we can send as much messages as we want, wrapping them into the transacion by using #wrap:"
	(frame := client newSendFrameTo: '/queue/helloworld')
		text: 'Hello World from Stamp, the Pharo STOMP client'.
	client write: (transaction wrap: frame).	"Apparently no receipts are delivered until commit"
"Finally, for finishing the transaction, we shall write the commitFrame of the transaction, that indicates the end of the transaction.
It is recommended to ensure the reception of a receipt, that acknowledges the finishing of the transaction "
	client writeWithReceipt: transaction commitFrame.
	
	client close
```
```smalltalk
exampleSubscribeToQueue
	| client |
" Create a stamp client for the default RabbitMq installation "
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
" Open the client connection "
	client open.
" Subscribe our client to the queue 'test' "
	client subscribeTo: 'test'
```
```smalltalk
exampleConnect
	| client |
" Creates a client for interacting with a default RabbitMQ installation"
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
" Open the client connection "
	client open.
	^ client
	
```
```smalltalk
exampleSendMessageToQueueWithReply
"
This example illustrates the usage of #replyTo:. 
 1- 	#replyTo: must be invoked with a temp-queue. 
 2- The client will be bound to the private-ephemeral queue named, for receiving a response. 
For More information, see #StampSendFrame >> #replyTo: or address the RabbitMQ documentation 
"
	| client frame |
" Create a stamp client for the default RabbitMq installation "
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
" Open the client connection "
	client open.
" Sends a text message 'something' "
	frame := client newSendFrameTo: 'queue'.
" It sets some text of the frame "
	frame text: 'some value'.
" Sets up as replyTo queue /temp-queue/response "
	frame replyTo: '/temp-queue/response'.
" Writes and flush the frame to the queue manager "
	client write: frame.
" Wait up to standard timeout for a reply "
	client readMessage.
```
```smalltalk
exampleReadSubscriptionLoop
	| client process |
" Create a stamp client for the default RabbitMq installation "
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
" Open the client connection "
	client open.
" Subscribe our client to the queue 'test' "
	client subscribeTo: 'test'.
" Stamp provides a runWith: loop in the level of the client. 
#runWith: receives a block that receives one message as parameter.
This method executes a repeat loop, that only stop with the special exception ConnectionClosed.
This call is mean to be called inside a forking process. 
"
	process := [client runWith: [: m | ConnectionClosed signal ]] fork .
	
	process terminate.
	client close.
	
	
	
```
```smalltalk
exampleOnTransactionAborted
	| client frame transaction |
" 
This example targets to illustrate the usage of transactions, in the success case (Begin and commit).
This example is based on the test #testSimpleSendUsingTransactionReceive.
"
"====== factorialService side ======
Creates a StampClient for the default RabbitMQ installation"
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
	" Open the client connection "
	client open.
" Creates a new trasnaction object. This object will help us to orchestrate a transaction "
	transaction := client newTransaction.
" Write the beginFrame. This frame indicates the starting point of the transaction to the queuing system. 
It is recommended to ensure the reception of a receipt, that acknowledges the beginning of the transaction "
	client writeWithReceipt: transaction beginFrame.
" After the begin of the transaction, we can send as much messages as we want, wrapping them into the transacion by using #wrap:"
	(frame := client newSendFrameTo: '/queue/helloworld')
		text: 'Hello World from Stamp, the Pharo STOMP client'.
	client write: (transaction wrap: frame).	"Apparently no receipts are delivered until commit"
"Finally, for finishing the transaction, we shall write the abortFrame of the transaction, that indicates the end of the transaction.
It is recommended to ensure the reception of a receipt, that acknowledges the finishing of the transaction "
	client writeWithReceipt: transaction abortFrame.
	client close
```
```smalltalk
exampleReadSubscription
	| client frame |
" Create a stamp client for the default RabbitMq installation "
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
" Open the client connection "
	client open.
" Subscribe our client to the queue 'test' "
	client subscribeTo: 'test'.
" From now on we can read messages of this queue "
	frame := client readMessage.
	
	
	
```
```smalltalk
exampleSendMessageToQueue
	| client  |
" Create a stamp client for the default RabbitMq installation "
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
" Open the client connection "
	client open.
" Sends a text message 'something' "
	client sendText: 'something' to: 'test'
```
```smalltalk
exampleSimpleSendRecvWithIndividualAck
	| client frame destination subscriptionId ack |
" Creates a client for interacting with a default RabbitMQ installation"
	client := StampClient new.
	client login: 'guest'.
	client passcode: 'guest'.
" Open the client connection "
	client open.
" Create a send frame, and setup the destination and message "
	(frame := StampSendFrame new)
		destination: (destination := '/queue/helloworld');
		text: 'Hello World from Stamp, the Pharo STOMP client'.
" Writes the message "
	client write: frame.
" Create a subcsription frame, and setup the destination id. We shall notice that the subscription is configured to be #clientIndividualAck"
	(frame := StampSubscribeFrame new)
		destination: destination;
		id: (subscriptionId := client nextId);
		clientIndividualAck.
" Writes the subscription "
	client write: frame.
" After subscribed it can read the messages from the same queue "
	frame := client readMessage.
	
" Once we got the message, we have to manually ack the message. If not, it will not be removed from the queue manager.
For doing so, we have first to create an ack frame for the received message "
	ack := frame ackFrame.
" And to write it down in the client to transmit it "
	client write: ack. 
	
" Finally, it prepares an unsubscription frame "
	(frame := StampUnsubscribeFrame new) id: subscriptionId.
" It writes the unsubscription  "
	client write: frame.
" Finishes the connection "
	client close
```



## StampClient
I am StampClient.
I connect to a STOMP 1.2 server as a client to send and/or receive messages.


### Properties
options
medium
connectFrame
connectedFrame
idGenerator
heartbeat
lastActivity
inbox

### Methods
#### StampClient>>heartbeat: milliseconds
Option-Property. It sets the option heartbeat. Value expected in milliseconds.  The value of the heartbeat should be at least 4 times the timeout property

#### StampClient>>readNextFrame
It reads the next frame from the actual medium. In case of ERROR frame, it signals an error.

#### StampClient>>runWith: block
Enter a loop reading messages, ignoring ConnectionTimedOut. Block is evaluated for each incoming message. When the loop ends, the receiver is #close-ed. ConnectionClosed can be signalled to exit the loop

#### StampClient>>port: integer
Option-Property. Sets the port for connecting the remote queue manager. T

#### StampClient>>virtualHost: hostName
Option-Property Sets the virtualhost for stablishing connectionwith the remote queue manager. This value will be concatenated to the host during the connection phase. 

#### StampClient>>host: hostName
Option-Property. Sets the host property. (Name/IP expected) 

#### StampClient>>debug: boolean
Option-Property. It sets the option debug. Boolean expected

#### StampClient>>newSubscriptionTo: destination
Creates a default SubscriptionFrame for subscribing to the given destination (queue name)

#### StampClient>>write: frame
Writes a given frame and flushes the connection

#### StampClient>>port
Option-Property. Gets the port for connecting the remote queue manager. The default value is StampConstants defaultPort 

#### StampClient>>clearInbox
Cleans up the inbox, by simply removing all the received messages

#### StampClient>>writeWithReceipt: outgoingFrame
Writes a given frame and flushes the connection. It waits for a receipts of the message 

#### StampClient>>newSendFrameTo: destination
Creates a default SendFrame for communicating a message to the given destination (queue name) 

#### StampClient>>heartbeat
Option-Property. It returns the hearbeat rate.60*1000 "milliseconds" by default 

#### StampClient>>readFromInboxSuchThat: block
It reads from the inbox, any frame that responds positively to the given block

#### StampClient>>timeout: seconds
Option-Property. Sets the timeout for the communication with the remote queue manager. The expected value is in seconds

#### StampClient>>readMessage
It reads the next frame that responds to the command command #MESSAGE.

#### StampClient>>close
It disconnect the client by informing the remote manager. It also closes the companion medium

#### StampClient>>readSuchThat: block
This method checks first in the inbox for any frame that responds to the given block. 
If none frame is found in the inbox, it follows up by reading from the manager next frames up to find a frame that responds positively to the given block. 
All the frames that are not accepted by the block are sequentially added to the inbox, for further usage. 
This call may fail by Timeout.

#### StampClient>>open
It connects the queue manager. It ensures that the client is not connected (closing the ongoing connection if there is any). 

#### StampClient>>writeHeartbeat
Writes an empty frame as a heartbeat

#### StampClient>>closeIgnoringErrors
It informs the disconnection to the manager. It also closes the companion medium; It ignores all kind of error

#### StampClient>>host
Option-Property. Gets the host property. By default, is localhost

#### StampClient>>session
Gets the session id from the connectedFrame. It returns nil on a non-connected client

#### StampClient>>debug
Option-Property. It gets the option debug. The default value is False

#### StampClient>>passcode: string
Option-Property. Sets the password for login the remote queue manager. 

#### StampClient>>sendText: string to: destination
It writes a SendFrame to the given destination with the given string (text) message 

#### StampClient>>writeNoFlush: frame
Writes a given frame without flushing. After writting, it emits a StampFrameWrittenEvent announcement

#### StampClient>>connectFrame
It access the connectFrame. It implements a lazy initialization. It configures the creation of the connectFrame by using the, previously setted, properties: login, passcode, heartbeat and virtualHost

#### StampClient>>disconnect
It disconnect the client by informing the remote manager.

#### StampClient>>timeout
Option-Property. Gets the timeout for the communication with the remote queue manager. The default value is 1 second

#### StampClient>>newTransaction
Creates a default TransactionFrame 

#### StampClient>>medium
Access the medium object. It Lazily created it if is not yet created. This initialization creates a socket stream, that requires the host and port of the manager

#### StampClient>>subscribeTo: destination
It writes a SubscriptionFrame to subscribe to the given destination (queue name)

#### StampClient>>closeMedium
It  closes the companion medium. It ignores all kind of error

#### StampClient>>isConnected
Informs if the client is connected.

#### StampClient>>passcode
Option-Property. Gets the password for login the remote queue manager. The default value is nil

#### StampClient>>virtualHost
Option-Property. Gets the virtualhost for stablishing connectionwith the remote queue manager. The default value is / 

#### StampClient>>login: string
Option-Property. Sets the user name for login the remote queue manager

#### StampClient>>login
Option-Property. Gets the user name for login the remote queue manager. The default value is nil

#### StampClient>>read
It reads the next frame, and returns it regardless the kind



## StampConstants
I am StampConstants.


### Class Methods code
#### StampConstants class>>maxBodySize
```smalltalk
maxBodySize
	^ 2 ** 20
```

#### StampConstants class>>defaultPort
```smalltalk
defaultPort
	^ 61613
```

#### StampConstants class>>maxNumberOfHeaders
```smalltalk
maxNumberOfHeaders
	^ 32
```

#### StampConstants class>>maxHeaderLength
```smalltalk
maxHeaderLength
	^ 1024
```

#### StampConstants class>>maxHeaderLineLength
```smalltalk
maxHeaderLineLength
	^ 1024
```



## StampFrame
I am StampFrame.
I am the abstract superclass of an object hierarchy representing STOMP frames.
Simple (or Streaming) Text Oriented Message Protocol (STOMP), is a simple text-based protocol, designed for working with Message Oriented Middleware. It provides an interoperable wire format that allows STOMP clients to talk with any Message Broker supporting the protocol. It is thus language-agnostic, meaning a broker developed for one language or platform can receive communications from client software developed in another language.
This code implements STOMP 1.2
--- References ---
http://stomp.github.io/stomp-specification-1.2.html
http://stomp.github.com/
http://en.wikipedia.org/wiki/Streaming_Text_Oriented_Messaging_Protocol
--- BNF ---
NULL = <US-ASCII null (octet 0)>
LF = <US-ASCII line feed (aka newline) (octet 10)>
CR = <US-ASCII carriage return (octet 13)>
EOL = [CR] LF 
OCTET = <any 8-bit sequence of data>
frame-stream = 1*frame
frame = command EOL
                      *( header EOL )
                      EOL
                      *OCTET
                      NULL
                      *( EOL )
command = client-command | server-command
client-command = "SEND"
                      | "SUBSCRIBE"
                      | "UNSUBSCRIBE"
                      | "BEGIN"
                      | "COMMIT"
                      | "ABORT"
                      | "ACK"
                      | "NACK"
                      | "DISCONNECT"
                      | "CONNECT"
                      | "STOMP"
server-command = "CONNECTED"
                      | "MESSAGE"
                      | "RECEIPT"
                      | "ERROR"
header = header-name ":" header-value
header-name = 1*<any OCTET except CR or LF or ":">
header-value = *<any OCTET except CR or LF or ":">

### Properties
headers

### Methods
#### StampFrame>>command
The STOMP command that I implement



## StampLogEvent
I am StampLogEvent, the base class of a log events emitted by elements of the Stamp framework.
I add a timestamp and a simple id attribute. The id can wrap around and should only be used to distinguish between events that have the same timestamp.
StampLogEvents are distributed as Announcement through a singleton Announcer that I maintain.
I have a small convenience API to log to the Transcript or open a simple GUI on the emitted log events.

### Properties
timestamp
id

### Class Methods
#### StampLogEvent class>>stopLoggingToTranscript
 Stops logging messages into transcript

#### StampLogEvent class>>logToTranscript
 Start logging messages into transcript



## StampSendFrame
I am StampSendFrame
I am a StampClientFrame.
I implement STOMP SEND.
Sent to deliver a message from the client to the server.


### Properties
headers
body

### Methods
#### StampSendFrame>>persistent: boolean
This is a RabbitMQ extension. Setting the persistent header to true has the effect of making the message persistent. Receipts for SEND frames with persistent:true are not sent until a confirm is received from the broker. MESSAGE frames for persistent messages will contain a persistent:true header.

#### StampSendFrame>>replyTo: string
This is a RabbitMQ extension. Temp queue destinations allow you to define temporary destinations in the reply-to header of a SEND frame. Temp queues are managed by the broker and their identities are private to each session -- there is no need to choose distinct names for temporary queues in distinct sessions. To use a temp queue, put the reply-to header on a SEND frame and use a header value starting with /temp-queue/. A temporary queue is created (with a generated name) that is private to the session and automatically subscribes to that queue. A different session that uses reply-to:/temp-queue/foo will have a new, distinct queue created. The internal subscription id is a concatenation of the string /temp-queue/ and the temporary queue (so /temp-queue/foo in this example). The subscription id can be used to identify reply messages. Reply messages cannot be identified from the destination header, which will be different from the value in the reply-to header. The internal subscription uses auto-ack mode and it cannot be cancelled. The /temp-queue/ destination is not the name of the destination that the receiving client uses when sending the reply. Instead, the receiving client can obtain the (real) reply destination queue name from the reply-to header of the MESSAGE frame. This reply destination name can then be used as the value of the destination header in the SEND frame sent in reply to the received MESSAGE. Reply destination queue names are opaque and cannot be inferred from the /temp-queue/ name. SEND and SUBSCRIBE frames must not contain /temp-queue destinations in the destination header. Messages cannot be sent to /temp-queue destinations, and subscriptions to reply queues are created automatically.



## StampSubscribeFrame
I am StampSubscribeFrame
I am a StampClientFrame.
I implement STOMP SUBSCRIBE.
Sent to subscribe to a message stream.

### Methods
#### StampSubscribeFrame>>clientAck
When the ack mode is client, then the client MUST send the server ACK frames for the messages it processes. If the connection fails before a client sends an ACK frame for the message the server will assume the message has not been processed and MAY redeliver the message to another client. The ACK frames sent by the client will be treated as a cumulative acknowledgment. This means the acknowledgment operates on the message specified in the ACK frame and all messages sent to the subscription before the ACK'ed message. In case the client did not process some messages, it SHOULD send NACK frames to tell the server it did not consume these messages.

#### StampSubscribeFrame>>prefetchCount: integer
This is a RabbitMQ extension. The prefetch count for all subscriptions is set to unlimited by default. This can be controlled by setting the prefetch-count header on SUBSCRIBE frames to the desired integer count.

#### StampSubscribeFrame>>clientIndividualAck
When the ack mode is client-individual, the acknowledgment operates just like the client acknowledgment mode except that the ACK or NACK frames sent by the client are not cumulative. This means that an ACK or NACK frame for a subsequent message MUST NOT cause a previous message to get acknowledged.

#### StampSubscribeFrame>>persistent: boolean
This is a RabbitMQ extension. The STOMP adapter supports durable topic subscriptions. Durable subscriptions allow clients to disconnect from and reconnect to the STOMP broker as needed, without missing messages that are sent to the topic. Topics are neither durable nor transient, instead subscriptions are durable or transient. Durable and transient can be mixed against a given topic. To create a durable subscription, set the persistent header to true in the SUBSCRIBE frame. When creating a durable subscription, the id header must be specified.

#### StampSubscribeFrame>>ack: string
See #autoAck, #clientAck and #clientIndividualAck

#### StampSubscribeFrame>>autoAck
When the ack mode is auto, then the client does not need to send the server ACK frames for the messages it receives. The server will assume the client has received the message as soon as it sends it to the client. This acknowledgment mode can cause messages being transmitted to the client to get dropped. This is the default.



## StampSubscription
I am StampSubscription, a helper object to manage STOMP 1.2 subscriptions.


### Properties
subscribeFrame

### Methods
#### StampSubscription>>clientAck
Sets the subscription ClientAck - All the received messages since the last read will be deleted from the queue manager as soon as an ack is communicated 

#### StampSubscription>>clientIndividualAck
Sets the subscription clientIndividualAck - A  received message will be deleted from the queue manager as soon as it is acknowledged (individually) 

#### StampSubscription>>destination: string
Sets the destination of the subscription 

#### StampSubscription>>unsubscribeFrame
It creates an Unsubscribe frame for this subcription helper

#### StampSubscription>>autoAck
Sets the subscription AutoAck - All the received messages will be automatically deleted from the queue manager 

#### StampSubscription>>id: string
Sets the id of  subscription. This ID must be used also for unsubscribing 

#### StampSubscription>>subscribeFrame
Gets the subscribe frame being configured by this subscription helper. 



## StampTransaction
I am StampTransaction, a helper object to manage STOMP 1.2 transactions.

### Properties
beginFrame

### Methods
#### StampTransaction>>commitFrame
Creates an commit frame for this transaction helper 

#### StampTransaction>>abortFrame
Creates an abortion frame for this transaction helper 

#### StampTransaction>>wrap: frame
Wraps a frame by setting a transaction id from this helper. Meaning that the frame will be treated as belonging to this transaction 

#### StampTransaction>>beginFrame
Gets the begin frame for this transaction helper 



