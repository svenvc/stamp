testing
testTextNoReceiptNoAck
	| benchmark read |
	benchmark := StampBenchmark new.
	self assert: (benchmark writeNoReceiptCount: 10 ofSize: 100) equals: 10.
	read := benchmark readNoAckCount: 10.
	self assert: read size equals: 10