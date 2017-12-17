Red [
	Title: "func"
	File: %func.red
	Tabs: 4
]

f: context [
	identity: func [a][a]
	inc: func [n][n + 1]
	dec: func [n][n - 1]

	math: context [
		double: func [n][n * 2]
		negate: func [n][- n]
		invert: func [n][1.0 / n]
	]

	add: func [a b][a + b]
	sub: func [a b][a - b]
	mul: func [a b][a * b]
	div: func [a b][a / b]

	sequences: func [][
		return context [
			positive-integers: f/repeatedly :f/inc 1
			negative-integers: f/repeatedly :f/dec -1
			powers-of-two: f/repeatedly :f/math/double 1
			evens: f/repeatedly func [n][n + 2] 2
			odds: f/repeatedly func [n][n + 2] 1
		]
	]

	maybe: func [blk][
		context [
			_blk: blk
			return func [val][
				if not none? val [
					do _blk
				]
			]
		]
	]

	compose: func [fn1 fn2][
		context [
			_fn1: :fn1
			_fn2: :fn2
			return func [val][
				_fn1 _fn2 val
			]
		]
	]

	accessor: func [name][
		context [
			_name: name
			return func [src][
				src/:_name
			]
		]
	]

	constantly: func [value][
		context [
			_value: value
			return func [][_value]
		]
	]

	repeatedly: func [stepper initial][
		context [
			_stepper: :stepper
			_value: initial
			return func [][
				retval: _value
				self/_value: _stepper _value
				return retval
			]
		]
	]

	map-series: function [
		applicant
		src
		/local result
	][
		result: copy []
		foreach element src [
			append/only result (applicant element)
		]
		return result
	]

	map-map: function [
		applicant
		src
		/keys
		/local result val tmp
	][
		either keys [
			result: copy []
			foreach k keys-of src [
				val: select src k
				tmp: context [
					key: k
					value: val
				]
				append/only result applicant tmp
			]
			return result
		][
			return self/map-series :applicant (values-of src)
		]
	]

	map: function [
	{
		Iterates thru a collection and invokes the `applicant` for each element.
		The result of this invocation is collected in a new collection of the
		same type. Supports both series! and map!.

		If src is a map! only the values will be passed to the applicant

		Example usage:
			f/map func[n][n + 1] [1 2 3] ;--> [2 3 4]
			f/map func[n][n + 1] #(a: 1 b: 2) ;--> [2 3] ;order is not guaranteed
	}
		applicant [function!] "The function to be invoked for each element"
		src [series! map!] "The source of the iteration"
		return: [block!]
		/keys
	][
		case [
			map? src    [self/map-map :applicant src]
			series? src [self/map-series :applicant src]
		]
	]

	reduce: function [
		aggregator[function!]
		initial-value
		src[series!]
		/local result
	][
		result: initial-value
		foreach element src [
			result: aggregator result element
		]
		return result
	]

	filter: function [
		applicant[function!]
		src[series!]
		/local result
	][
		result: copy []
		foreach element src [
			if applicant element [
				append/only result element
			]
		]
		return result
	]

	first-match: func [
		finder[function!]
		src[series!]
		/default default-value
		return: [series!]
	][
		foreach element src [
			if finder element [
				return element
			] 
		]
		return either default [default-value][none]
	]

	sort: func [comparator series /stable /local val][
		val: copy series
		either stable [
			system/words/sort/stable/compare val :comparator
		][
			system/words/sort/compare val :comparator
		]
		return val
	]

	zipmap: func [
		applicant [function!]
		multiple-series[series!] ;-- a 2D series
		/local len result
	][
		result: copy []
		len: length? (first multiple-series)
		repeat n len [
			args: f/map func [s][first next s] multiple-series
			append/only result (applicant args)
		]
		return result
	]

	interleave: 'not-implemented

	group-by: 'not-implemented

	partition: 'not-implemented
]
