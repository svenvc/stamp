# Stamp - Generated Doc
## Manifest
Stamp is an implementation of STOMP (Simple (or Streaming) Text Oriented Message Protocol) for Pharo, a protocol to interact with message-oriented middleware (MOM).
More specifically, Stamp implements STOMP 1.2 and was tested against RabbitMQ 3.1. Other message-oriented middleware implementations accessible through STOMP include Apache ActiveMQ, Glassfish Open MQ and Fuse Message Broker based on Active MQ - but these have not yet been tested.
Messaging middleware is an important technology for building scaleable and flexible enterprise software architectures

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



