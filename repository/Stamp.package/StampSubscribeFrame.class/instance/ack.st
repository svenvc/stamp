accessing
ack
	"See #autoAck, #clientAck and #clientIndividualAck"

	^ self headerAt: #ack ifAbsent: [ #auto ]