"
I am StampConnectFrame
I am a StampClientFrame.
I implement STOMP CONNECT.

Sent to initialize a new connection to a host.
"
Class {
	#name : #StampConnectFrame,
	#superclass : #StampClientFrame,
	#category : 'Stamp-Core'
}

{ #category : #accessing }
StampConnectFrame class >> command [
	"The STOMP command that my instances implement."
	
	^ #CONNECT
]

{ #category : #accessing }
StampConnectFrame >> acceptVersion [
	^ self headerAt: #'accept-version'
]

{ #category : #accessing }
StampConnectFrame >> acceptVersion: versions [
	self headerAt: #'accept-version' put: versions
]

{ #category : #accessing }
StampConnectFrame >> heartbeat [
	^ ($, split: (self headerAt: #'heart-beat' ifAbsent: [ '0,0' ])) 
			collect: [ :each | each trimBoth asInteger ]
]

{ #category : #accessing }
StampConnectFrame >> heartbeat: values [
	self 
		headerAt: #'heart-beat' 
		put: ('{1},{2}' format: { values first asString. values second asString } )
]

{ #category : #accessing }
StampConnectFrame >> host [
	^ self headerAt: #host
]

{ #category : #accessing }
StampConnectFrame >> host: virtualHost [
	self headerAt: #host put: virtualHost
]

{ #category : #'initialize-release' }
StampConnectFrame >> initialize [
	super initialize.
	self headerAt: #'accept-version' put: '1.2' 
]

{ #category : #accessing }
StampConnectFrame >> login [
	^ self headerAt: #login
]

{ #category : #accessing }
StampConnectFrame >> login: userId [
	self headerAt: #login put: userId
]

{ #category : #accessing }
StampConnectFrame >> passcode [
	^ self headerAt: #passcode
]

{ #category : #accessing }
StampConnectFrame >> passcode: password [
	self headerAt: #passcode put: password
]

{ #category : #accessing }
StampConnectFrame >> receipt [
	^ self shouldNotImplement 
]

{ #category : #accessing }
StampConnectFrame >> receipt: string [
	self shouldNotImplement 
]
