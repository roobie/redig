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

do %tap.red
T: harness

T/suite 1 [
	T/case "T1" [
		; T/assert [1 = 1]
		; T/assert [1 = 1]
		; T/assert [1 = 1]
		; T/assert [1 = 1]
		; T/assert/msg [2 = 2] "Yes, two will be two"

		; T/assert [1 = 2]
		; T/assert/msg [2 = 4] "Oops, two is not four"
	]
	T/case "Err" [
		T/assert/msg [1 + "2"] "Should show as error"

		a: #(a: 1 b: 2)
		T/assert [(a) = [1 2]]
		T/assert/msg [(a) = [1 2]] "Should maybe equal"
	]
]

; TAP version 13
; 1..5
; ok 1 - T1: [1 = 1]
; ok 2 - T1: [1 = 1]
; ok 3 - T1: [1 = 1]
; ok 4 - T1: [1 = 1]
; ok 5 - T1: Yes, two will be two [2 = 2]
; not ok 6 - T1: [1 = 2]
; not ok 7 - T1: Oops, two is not four [2 = 4]
; not ok 8 - Err: Should show as error [1 + "2"] *** Script Error: + does not allow string! for its value2 argument*** Where: +*** Stack: replace
; not ok 9 -  Actual test count exceeds plan
