"
I am StampReceiptFrame.
I am a StampClientFrame.
I implement STOMP RECEIPT. 

Sent to confirm the reception of a message.
"
Class {
	#name : #StampReceiptFrame,
	#superclass : #StampServerFrame,
	#category : 'Stamp-Core'
}

{ #category : #accessing }
StampReceiptFrame class >> command [
	"The STOMP command that my instances implement."
	
	^ #RECEIPT
]

{ #category : #accessing }
StampReceiptFrame >> receiptId [
	^ self headerAt: #'receipt-id'
]

{ #category : #accessing }
StampReceiptFrame >> receiptId: string [
	self headerAt: #'receipt-id' put: string
]
