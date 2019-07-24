"
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

client-command = ""SEND""
                      | ""SUBSCRIBE""
                      | ""UNSUBSCRIBE""
                      | ""BEGIN""
                      | ""COMMIT""
                      | ""ABORT""
                      | ""ACK""
                      | ""NACK""
                      | ""DISCONNECT""
                      | ""CONNECT""
                      | ""STOMP""

server-command = ""CONNECTED""
                      | ""MESSAGE""
                      | ""RECEIPT""
                      | ""ERROR""

header = header-name "":"" header-value
header-name = 1*<any OCTET except CR or LF or "":"">
header-value = *<any OCTET except CR or LF or "":"">
"
Class {
	#name : #StampFrame,
	#superclass : #Object,
	#instVars : [
		'headers'
	],
	#category : #'Stamp-Core'
}

{ #category : #accessing }
StampFrame class >> command [
	"The STOMP command that my instances implement."
	
	"This is actually subclassResponsability, but since I have abstract subclass,
	I return nil to allow searching to work"
	
	^ nil
]

{ #category : #accessing }
StampFrame class >> concreteSubclassForType: command [
	^ self allSubclasses
		detect: [ :subClass | subClass command = command ]
		ifNone: [ self error: 'Unrecognized command' ]
]

{ #category : #'instance creation' }
StampFrame class >> readFrom: stampMedium [
	| command |
	command := stampMedium readLine.
	^ command isEmpty
		ifTrue: [ 
			StampEmptyFrame new ]
		ifFalse: [
			(self concreteSubclassForType: command) new
				readFrom: stampMedium;
				yourself ]
]

{ #category : #accessing }
StampFrame >> command [
	<doc: 'The STOMP command that I implement'>
	^ self class command
]

{ #category : #testing }
StampFrame >> hasBody [
	^ false
]

{ #category : #testing }
StampFrame >> hasHeader: headerKey [
	^ self headers includesKey: headerKey
]

{ #category : #accessing }
StampFrame >> headerAt: headerName [
	^ self headers at: headerName
]

{ #category : #accessing }
StampFrame >> headerAt: headerName ifAbsent: block [
	^ self headers at: headerName ifAbsent: block
]

{ #category : #accessing }
StampFrame >> headerAt: headerName put: headerValue [
	"Set headerName to headerValue. 
	Note that according to the 1.2 spec, Repeated Header Entries, the first one wins."
	
	^ (self hasHeader: headerName)
		ifFalse: [ self headers at: headerName put: headerValue ]
]

{ #category : #accessing }
StampFrame >> headers [
	^ headers ifNil: [ headers := SmallDictionary new ]
]

{ #category : #printing }
StampFrame >> printOn: stream [
	super printOn: stream.
	self headers printElementsOn: stream
]

{ #category : #reading }
StampFrame >> readBodyFrom: stampMedium [
	stampMedium readEndFrame
]

{ #category : #'initialize-release' }
StampFrame >> readFrom: stampMedium [
	self readHeadersFrom: stampMedium.
	self readBodyFrom: stampMedium
]

{ #category : #reading }
StampFrame >> readHeadersFrom: stampMedium [
	| association |
	[ (association := stampMedium readHeader) notNil ] 
		whileTrue: [
			self headers size >= StampConstants maxNumberOfHeaders 
				ifTrue: [ self error: 'Too many headers' ].
			self headers add: association ]
]

{ #category : #writing }
StampFrame >> writeBodyOn: stampMedium [
	self hasBody
		ifTrue: [ 
			self body isString
				ifTrue: [ stampMedium nextPutString: self body ]
				ifFalse: [ stampMedium nextPutBytes: self body ] ]
]

{ #category : #writing }
StampFrame >> writeHeadersOn: stampMedium [
	self headers 
		keysAndValuesDo: [ :key :value |
			stampMedium nextPutHeader: key value: value ].
	stampMedium endLine
]

{ #category : #writing }
StampFrame >> writeOn: stampMedium [
	stampMedium 
		nextPutString: self command; 
		endLine.
	self writeHeadersOn: stampMedium.
	self writeBodyOn: stampMedium.
	stampMedium endFrame
]
