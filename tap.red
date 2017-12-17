Red [
	Title: "tap"
	Description: "Simple TAP version 13 producing test library"
	Author: "Björn Roberg"
	Purpose: "To provide an easy and helpful way of unit-testing code."
	File: %test.red
	Tabs: 4
	License: "Apache License 2.0 https://www.apache.org/licenses/LICENSE-2.0"
	Usage: {
		See tap-test.red for an example of programming with the harness.

		When run, the harness will produce TAP version 13 output, which in turn
		can be consumed by TAP version 13 aware consumers.

		Examples of a TAP version 13 aware consumers can be found here:
		https://testanything.org/consumers.html
		
		In the development of this module, a javascript consumer has been used
		as such:

		$ npm i -g faucet # will globally install the faucet TAP consumer
		$ red --cli my-tests.red | faucet # will output a colorful report
		
		Example output with faucet: (sans colors)
		✓ T1: [1 = 1]
		✓ T1: Yes, two will be two [2 = 2]
		⨯ T1: [1 = 2]
		⨯ fail 1
	}
	Notes: comment [
		TAP version 13 specification can be found here:
		https://testanything.org/tap-version-13-specification.html

		Failing tests does not cause the harness to output the YAML which allows for
		after-the-fact debugging by comparing expected and actual values.
	]
]

remove-new-lines: func [s[string!]][
	replace/all s "^/" ""
]

harness: func [] [
	context [
		current-test: none
		current-index: 0

		suite: func [
			{
				This function accepts a block which will be passed to `do`.
			}
			count[integer!] "The expected total count of assertions"
			blk[block!] "The block of code to `do`, usually 1..* `case`s"
			/local
		][
			print "TAP version 13"
			prin "1.."
			print count

			do (blk) ;-- run the code

			;-- check that there was not too many or too few assertions
			if self/current-index < count [
				prin "not ok "
				prin self/current-index
				prin " - "
				print " Actual test count is short of plan"
			]
			if self/current-index > count [
				self/current-index: self/current-index + 1
				prin "not ok "
				prin self/current-index
				prin " - "
				print " Actual test count exceeds plan"
			]
		]

		case: func [
			{
				Used as a way of grouping assertions
			}
			name[string!] "The name of the test"
			blk[block!] "The block that comprises the test"
		][
			;-- FIXME: implement support for nesting cases
			; if string? self/current-test [
			; ]
			self/current-test: name
			do (blk)
			; if error? result [
			; ]
			self/current-test: none
		]

		assert: func [
			{
				Checks the value that the block evaluates to, and if it is an error? or
				otherwise false, will store the block which then will be `print`ed.
			}
			blk[block!]
			/msg _msg
			/local res
		][
			self/current-index: self/current-index + 1
			res: try (blk)
			either error? res [
				prin "not ok "
				prin self/current-index
				prin [" -" self/current-test]
				prin ": "
				; res: replace/all (to string! res) "^/" ""
				print "# Diagnostic"
				print "---"
				either msg [
					print reduce [_msg (mold blk) "^/" res]
				][
					print reduce [(mold blk) "^/" res]
				]
				print "..."
			][
				either res [
					prin "ok "
				][
					prin "not ok "
				]
				prin self/current-index
				prin [" -" self/current-test]
				prin ": "
				either msg [
					print reduce [_msg (mold blk)]
				][
					print reduce [(mold blk)]
				]
				if not res [
					temp: compose/only blk
					found: temp/1
					operator: temp/2
					expected: temp/3
					; probe temp/1
					print "# Diagnostic"
					print "---"
					if msg [
						print ["message:" _msg]
					]
					print "severity: fail"
					print "data:"
					print ["    operator:" (trim/lines mold operator)]
					print ["    expected:" (trim/lines mold expected)]
					print ["    actual:" (trim/lines mold found)]
					print "..."
				]
			]
		]
	]
]
