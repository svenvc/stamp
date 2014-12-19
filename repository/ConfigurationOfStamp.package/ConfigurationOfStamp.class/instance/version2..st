versions
version2: spec
	<version: '2' imports: #('1-baseline')>
	spec for: #common do: [
		spec
			blessing: #release;
			package: 'Stamp' with: 'Stamp-SvenVanCaekenberghe.22' ]
