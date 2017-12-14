Red [
	Title: "Simple test framework"
	Author: "Björn Roberg"
	Purpose: "To provide an easy and helpful way of unit-testing code."
	File: %test.red
	Tabs: 4
	License: "Apache License 2.0 https://www.apache.org/licenses/LICENSE-2.0"
]

test: func [] [
	context [
		current-test: none
		ok-assertions: copy #()
		failed-assertions: copy #()

		reset: function [][
			self/ok-assertions: copy #()
			self/failed-assertions: copy #()
		]

		suite: function [
			{
				This function accepts a block which will be passed to `do`.

				After a suite has been run, the numbers of okay and failed tests will
				be `print`ed. 
			}
			blk[block!] "The block of code to `do`"
			/local
				results
				val
				ok-count
				failed-count
		][
			do (blk)

			ok-count: 0
			foreach lst values-of self/ok-assertions [
				ok-count: ok-count + length? lst
			]
			print [
				pad/left ok-count 4
				"# OKAY"
			]
			failed-count: 0
			foreach lst values-of self/failed-assertions [
				failed-count: failed-count + length? lst
			]
			print [
				pad/left failed-count 4
				"# FAIL"
			]
			total-assertion-count: (ok-count + failed-count)
			; prin "1.."
			; print total-assertion-count
			foreach test-name keys-of self/failed-assertions [
				val: select failed-assertions test-name
				if not zero? length? val [
					print ["Test [" test-name "] failed"]
					foreach fail val [
						print ["    " fail]
					]
				]
			]

			results: context [
				tests: context [
					ok: copy ok-assertions
					failed: copy failed-assertions
				]
			]
			self/reset
			return results
		]

		test: function [
			{
				Used as a way of grouping assertions
			}
			name[string!] "The name of the test"
			blk[block!] "The block that comprises the test"
			/local
				result
		][
			self/current-test: name
			put self/ok-assertions name (copy [])
			put self/failed-assertions name (copy [])

			result: try (blk)
			print ["Test [" pad name 20 "] completed"]
			if error? result [
				print ["Error(s) occured:" lf result]
			]

			self/current-test: none
		]

		assert: function [
			{
				Checks the value that the block evaluates to, and if it is an error? or
				otherwise false, will store the block which then will be `print`ed.
			}
			blk[block!]
			/msg _msg
			/local lst res
		][
			res: try (blk)
			either error? res [
				lst: select self/failed-assertions self/current-test
				either msg [
					append/only lst reduce [(mold/only blk) _msg res]
				][
					append/only lst reduce [(mold/only blk) res]
				]
			][
				either res [
					lst: select self/ok-assertions self/current-test
					either msg [
						append/only lst reduce [(mold/only blk) _msg]
					][
						append/only lst (mold/only blk)
					]
				][
					lst: select self/failed-assertions self/current-test
					either msg [
						append/only lst reduce [(mold/only blk) _msg]
					][
						append/only lst (mold/only blk)
					]
				]
			]
		]
	]
]
