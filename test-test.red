Red [
		Title: "Tests for %test.red"
]

do %test.red

T: test

T/suite [
	T/test "suite" [
		inferior-t: test
		_print: :print
		print: func [][]
		results: inferior-t/suite [
			inferior-t/test "Tfail" [
				inferior-t/assert [1 = 2]
			]
			inferior-t/test "Tsucceed" [
				inferior-t/assert [2 = 2]
			]
		]
		print: :_print
		T/assert [(length? results/tests/ok) = 2]
		T/assert [(length? results/tests/failed) = 2]

		failed: select results/tests/failed "Tfail"
		T/assert [(length? failed) = 1]
		T/assert [failed/1 = "1 = 2"]

		succeed: select results/tests/ok "Tsucceed"
		T/assert [(length? succeed) = 1]
		T/assert [succeed/1 = "2 = 2"]
	]
]
