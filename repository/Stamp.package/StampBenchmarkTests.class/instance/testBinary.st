testing
testBinary
	| benchmark read |
	benchmark := StampBenchmark new.
	benchmark binary.
	self assert: (benchmark writeCount: 10 ofSize: 100) equals: 10.
	read := benchmark readCount: 10.
	self assert: read size equals: 10