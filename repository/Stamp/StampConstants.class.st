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
	<doc>
	^ 61613
]

{ #category : #accessing }
StampConstants class >> maxBodySize [
	<doc>
	^ 2 ** 20
]

{ #category : #accessing }
StampConstants class >> maxHeaderLength [
	<doc>
	^ 1024
]

{ #category : #accessing }
StampConstants class >> maxHeaderLineLength [
	<doc>
	^ 1024
]

{ #category : #accessing }
StampConstants class >> maxNumberOfHeaders [
	<doc>
	^ 32
]
