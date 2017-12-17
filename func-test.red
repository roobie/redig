Red [
		Title: "Tests for func.red"
]

do %func.red
do %tap.red
T: harness

T/suite 44 [
	T/case "f/constantly" [
		c1: f/constantly 1
		T/assert [c1 = 1]
		T/assert [c1 = 1]
		loop 3 [
			T/assert [c1 = 1]
		]
	]
	T/case "f/repeatedly" [
		positive-integers: f/repeatedly :f/inc 1
		repeat count 5 [
			T/assert [count = positive-integers]
		]
	]
	T/case "f/compose" [
		fn: f/compose :f/math/double :f/inc
		T/assert [(fn 2) = 6]
		T/assert [(fn 3) = 8]
	]
	T/case "f/maybe" [
		v: 0
		act: f/maybe [
			v: f/inc v
		]
		act none
		T/assert [v = 0]
		act yes
		T/assert [v = 1]
		act [1 2 3]
		T/assert [v = 2]
	]
	T/case "f/map" [
		T/assert [(f/map :f/inc [1 2 3]) = [2 3 4]]
		T/assert [(f/map :f/inc #(a: 1 b: 2 c: 3)) = [2 3 4]]
		; assert [(f/map/keys func [k v][
		;     reduce [k v + 1]
		; ] #(a: 1 b: 2)) = [[a 2] [b 3]]]

		T/assert [(f/map :f/inc (make vector! [1 2 3])) = [2 3 4]]
		T/assert [(f/map :f/identity "abc") = [#"a" #"b" #"c"]]

		T/assert [(f/map-map/keys func [kvp][kvp/value] #(a: 1 b: 2)) = [1 2]]
		T/assert [(f/map-map/keys func [kvp][
			reduce [kvp/key kvp/value]
		] #(a: 1 b: 2)) = [[a 1] [b 2]]]

		lst: reduce [
			context [a: 1]
			context [a: 2]
			context [a: 3]
		]
		T/assert [(f/map (f/accessor 'a) lst) = [1 2 3]]
	]
	T/case "f/reduce" [
		T/assert [(f/reduce func [acc n][acc + n] 0 [1 2 3]) = 6]
		T/assert [(f/reduce :f/add 0 [1 2 3]) = 6]
	]
	T/case "f/filter" [
		T/assert [(f/filter func [n][n < 3] [1 2 3]) = [1 2]]
	]
	T/case "f/first-match" [
		haystack: [2 3 5 7 11]
		T/assert [(f/first-match func [n][all [2 < n n < 4]] haystack) = 3]
		T/assert [(f/first-match/default func [_][false] haystack -1) = -1]
	]
	T/case "f/sort" [
		src: [4 2 3 3 2 5 1]
		T/assert [(f/sort func [a b][a < b] src) = [1 2 2 3 3 4 5]]
		T/assert [src = [4 2 3 3 2 5 1]]
	]
	T/case "zipmap" [
		data: [
			[1 2 3]
			[4 5 6]
			[7 8 9]
		]
		res: f/zipmap func [args][f/reduce :f/add 0 args] data
		print res
		none
		;-- FIXME: not working
	]
	T/case "f/sequences" [
		seqs: f/sequences
		T/assert [seqs/positive-integers = 1]
		T/assert [seqs/positive-integers = 2]
		T/assert [seqs/positive-integers = 3]

		T/assert [seqs/negative-integers = -1]
		T/assert [seqs/negative-integers = -2]
		T/assert [seqs/negative-integers = -3]

		T/assert [seqs/powers-of-two = 1]
		T/assert [seqs/powers-of-two = 2]
		T/assert [seqs/powers-of-two = 4]

		T/assert [seqs/evens = 2]
		T/assert [seqs/evens = 4]
		T/assert [seqs/evens = 6]

		T/assert [seqs/odds = 1]
		T/assert [seqs/odds = 3]
		T/assert [seqs/odds = 5]
	]
]
