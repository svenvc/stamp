accessing
connectFrame
	^ connectFrame ifNil: [
		connectFrame := StampConnectFrame new.
		connectFrame host: self host.
		self login ifNotNil: [ :value | connectFrame login: value ].
		self passcode ifNotNil: [ :value | connectFrame passcode: value ].
		self heartbeat ifNotNil: [ :value | connectFrame heartbeat: (Array with: value with: value) ].
		connectFrame ]