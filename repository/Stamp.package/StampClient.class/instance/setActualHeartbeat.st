private
setActualHeartbeat
	| clientHeartbeat serverHeartbeat |
	clientHeartbeat := connectFrame heartbeat.
	serverHeartbeat := connectedFrame heartbeat.
	heartbeat := clientHeartbeat first max: serverHeartbeat second.
	"0 means client doesn't want it or server cannot deliver it"
	heartbeat isZero ifTrue: [ heartbeat := nil ].
	^ heartbeat 