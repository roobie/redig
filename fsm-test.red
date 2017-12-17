Red [
	Title: "FSM tests"
]

do %fsm.red
do %tap.red

T: harness

fsm1: make-finite-state-machine [a b c][
	[a b]
	[b c]
	[c a]
	[c b]
]

T/suite 8 [
	T/case "transitions" [
		;-- initial state should be the first element in the states-spec block
		T/assert [fsm1/current-state = 'a]
		T/assert [fsm1/available-transitions = [b]]

		T/assert [(fsm1/transition 'b) = 'b]
		T/assert [fsm1/current-state = 'b]
		T/assert [fsm1/available-transitions = [c]]
		T/assert [(fsm1/transition 'c) = 'c]
		T/assert [fsm1/current-state = 'c]
		T/assert [fsm1/available-transitions = [a b]]
	]
]
