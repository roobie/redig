Red [
		Title: "Tests for %test.red"
]

no-print: func [blk /local result][
	_print: :print
	print: func [][]

	result: do blk

	print: :_print
	return result
]

do %test.red
T: test

T/suite [
	T/test "That test/suite, test/test and test/assert work as expected" [
		_T: test
		results: no-print [
			_T/suite [
				_T/test "Tfail" [
					_T/assert [1 = 2]
				]

				_T/test "Tsucceed" [
					_T/assert [2 = 2]
				]

				_T/test "Tarbitrary" [
					_T/assert [[1 2 3] = [1 2 3]]
				]
			]
		]
		T/assert [(length? results/tests/ok) = 3]           ;-- An entry for each test
		T/assert [(length? results/tests/failed) = 3]       ;-- An entry for each test

		failed: select results/tests/failed "Tfail"
		T/assert [(length? failed) = 1]
		T/assert [failed/1 = "1 = 2"]

		succeed: select results/tests/ok "Tsucceed"
		T/assert [(length? succeed) = 1]
		T/assert [succeed/1 = "2 = 2"]

		arbitrary: select results/tests/ok "Tarbitrary"
		T/assert [(length? succeed) = 1]
		T/assert [arbitrary/1 = "[1 2 3] = [1 2 3]"]
	]
]
