Red [
	Title: "Finite state machine"
]

do %func.red

make-finite-state-machine: function [
	states-spec[block!]
	transitions-spec[block!]
][
	context [
		transitions: copy transitions-spec
		states: copy states-spec
		current-state: states-spec/1
		valid?: func [new-state /local finder match][
			finder: func [transition][
				(transition/1 = self/current-state)
				and
				(transition/2 = new-state)
			]
			match: f/first-match :finder self/transitions
			not none? match
		]
		available-transitions: func [/local temp][
			temp: f/filter func [t][t/1 = self/current-state] self/transitions
			f/map :second temp
		]
		transition: function [new-state][
			either self/valid? new-state [
				self/current-state: new-state
			][
				cause-error 'script 'invalid-arg [
					compose [
						new-state = (new-state)
						;; | current-state = (self/current-state)
					]
				]
			]
		]
	]
]
