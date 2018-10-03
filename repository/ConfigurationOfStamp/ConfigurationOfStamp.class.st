"
Stamp is an implementation of STOMP 1.2, a protocol to access message oriented middleware like RabbitMQ.


ConfigurationOfStamp load.

ConfigurationOfStamp loadBleedingEdge.


Written by Sven Van Caekenberghe - http://stfx.eu

"
Class {
	#name : #ConfigurationOfStamp,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : 'ConfigurationOfStamp'
}

{ #category : #'development support' }
ConfigurationOfStamp class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>

]

{ #category : #private }
ConfigurationOfStamp class >> baseConfigurationClassIfAbsent: aBlock [

	^Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			Smalltalk at: #MetacelloBaseConfiguration ifAbsent: aBlock ].

]

{ #category : #accessing }
ConfigurationOfStamp class >> catalogContactInfo [
	^ 'Written and maintained by Sven Van Caekenberghe (http://stfx.eu) and the community. Discussions on the Pharo mailing lists.'
]

{ #category : #accessing }
ConfigurationOfStamp class >> catalogDescription [
	^ 'Stamp is an implementation of STOMP 1.2, a protocol to access message oriented middleware like RabbitMQ.'
]

{ #category : #accessing }
ConfigurationOfStamp class >> catalogKeywords [
	^ #(format stomp rabbitmq messaging middleware client queueing)
]

{ #category : #private }
ConfigurationOfStamp class >> ensureMetacello [

	(self baseConfigurationClassIfAbsent: []) ensureMetacello
]

{ #category : #private }
ConfigurationOfStamp class >> ensureMetacelloBaseConfiguration [

	Smalltalk
		at: #MetacelloBaseConfiguration
		ifAbsent: [ 
			| repository version |
			repository := MCHttpRepository location: 'http://seaside.gemstone.com/ss/metacello' user: '' password: ''.
			repository
				versionReaderForFileNamed: 'Metacello-Base-DaleHenrichs.2.mcz'
				do: [ :reader | 
					version := reader version.
					version load.
					version workingCopy repositoryGroup addRepository: repository ] ]
]

{ #category : #'metacello tool support' }
ConfigurationOfStamp class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
ConfigurationOfStamp class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
ConfigurationOfStamp class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfStamp class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project version: #development) load
]

{ #category : #accessing }
ConfigurationOfStamp class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfStamp class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."

	"self validate"

	<apiDocumentation>
	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore
]

{ #category : #baselines }
ConfigurationOfStamp >> baseline1: spec [
	<version: '1-baseline'>
	spec for: #common do: [
		spec 
			blessing: #baseline;
			repository: 'http://smalltalkhub.com/mc/SvenVanCaekenberghe/Stamp/main/';
			package: 'Stamp' ]

]

{ #category : #accessing }
ConfigurationOfStamp >> customProjectAttributes [
	^ #()
]

{ #category : #'symbolic versions' }
ConfigurationOfStamp >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'common' version: '1-baseline'.

]

{ #category : #accessing }
ConfigurationOfStamp >> project [

	^ project ifNil: [ | constructor |
		"Bootstrap Metacello if it is not already loaded"
		(self class baseConfigurationClassIfAbsent: []) ensureMetacello.
		"Construct Metacello project"
		project := MetacelloMCProject new projectAttributes: self customProjectAttributes. 
		constructor := (Smalltalk at: #MetacelloVersionConstructor) on: self project: project.
		project loadType: #linear. "change to #atomic if desired"
		project ]
]

{ #category : #tags }
ConfigurationOfStamp >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'common' version: '4'.

]

{ #category : #versions }
ConfigurationOfStamp >> version1: spec [
	<version: '1' imports: #('1-baseline')>
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'Stamp' with: 'Stamp-SvenVanCaekenberghe.19' ]

]

{ #category : #versions }
ConfigurationOfStamp >> version2: spec [
	<version: '2' imports: #('1-baseline')>
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'Stamp' with: 'Stamp-SvenVanCaekenberghe.22' ]

]

{ #category : #versions }
ConfigurationOfStamp >> version3: spec [
	<version: '3' imports: #('1-baseline')>
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'Stamp' with: 'Stamp-SvenVanCaekenberghe.24' ]

]

{ #category : #versions }
ConfigurationOfStamp >> version4: spec [
	<version: '4' imports: #('1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 4'.
		spec author: 'NorbertHartl'.
		spec timestamp: '12/13/2017 14:29'.
		spec package: 'Stamp' with: 'Stamp-SvenVanCaekenberghe.25'. ].

]
