accessing
connectFrame
	^ connectFrame ifNil: [
		connectFrame := StampConnectFrame new.
		connectFrame host: self host.
		connectFrame ]