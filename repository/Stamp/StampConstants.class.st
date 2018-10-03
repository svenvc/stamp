"
I am StampConstants.

"
Class {
	#name : #StampConstants,
	#superclass : #Object,
	#category : 'Stamp-Core'
}

{ #category : #accessing }
StampConstants class >> defaultPort [
	^ 61613
]

{ #category : #accessing }
StampConstants class >> maxBodySize [
	^ 2**20
]

{ #category : #accessing }
StampConstants class >> maxHeaderLength [
	^ 1024
]

{ #category : #accessing }
StampConstants class >> maxHeaderLineLength [
	^ 1024
]

{ #category : #accessing }
StampConstants class >> maxNumberOfHeaders [
	^ 32
]
