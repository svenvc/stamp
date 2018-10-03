"
I am StampBenchmarkTests.

I assume a working STOMP 1.2 compatible server is running on localhost:61613

Tested against RabbitMQ 3.1, with default guest/guest and additional vhost localhost.

"
Class {
	#name : #StampBenchmarkTests,
	#superclass : #TestCase,
	#category : 'Stamp-Tests'
}

{ #category : #testing }
StampBenchmarkTests >> testBinary [
	| benchmark read |
	benchmark := StampBenchmark new.
	benchmark binary.
	self assert: (benchmark writeCount: 10 ofSize: 100) equals: 10.
	read := benchmark readCount: 10.
	self assert: read size equals: 10
]

{ #category : #testing }
StampBenchmarkTests >> testBinaryNoReceiptNoAck [
	| benchmark read |
	benchmark := StampBenchmark new.
	benchmark binary.
	self assert: (benchmark writeNoReceiptCount: 10 ofSize: 100) equals: 10.
	read := benchmark readNoAckCount: 10.
	self assert: read size equals: 10
]

{ #category : #testing }
StampBenchmarkTests >> testText [
	| benchmark read |
	benchmark := StampBenchmark new.
	self assert: (benchmark writeCount: 10 ofSize: 100) equals: 10.
	read := benchmark readCount: 10.
	self assert: read size equals: 10
]

{ #category : #testing }
StampBenchmarkTests >> testTextNoReceiptNoAck [
	| benchmark read |
	benchmark := StampBenchmark new.
	self assert: (benchmark writeNoReceiptCount: 10 ofSize: 100) equals: 10.
	read := benchmark readNoAckCount: 10.
	self assert: read size equals: 10
]
