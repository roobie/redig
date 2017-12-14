Red [
	Title: "Simple test framework"
	Author: "Björn Roberg"
	Purpose: "To provide an easy and helpful way of unit-testing code."
	File: %test.red
	License: "Apache License 2.0 https://www.apache.org/licenses/LICENSE-2.0"
]

test: func [] [
	context [
		current-test: none
		ok-tests: copy #()
		failed-tests: copy #()

		reset: function [][
			self/ok-tests: copy #()
			self/failed-tests: copy #()
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
		][
			do (blk)
			; print [
			; 	pad/left length? ok-tests 4
			; 	"# OKAY"
			; ]
			; print [
			; 	pad/left length? failed-tests 4
			; 	"# FAIL"
			; ]
			foreach test-name keys-of self/failed-tests [
				val: select failed-tests test-name
				if not zero? length? val [
					print ["Test [" test-name "] failed"]
					foreach fail val [
						print ["    " fail]
					]
				]
			]

			results: context [
				tests: context [
					ok: copy ok-tests
					failed: copy failed-tests
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
			put self/ok-tests name (copy [])
			put self/failed-tests name (copy [])

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
			/local lst res
		][
			res: try (blk)
			either error? res [
				lst: select self/failed-tests self/current-test
				append/only lst reduce [(mold/only blk) res]
			][
				either res [
					lst: select self/ok-tests self/current-test
					append/only lst (mold/only blk)
				][
					lst: select self/failed-tests self/current-test
					append/only lst (mold/only blk)
				]
			]
		]
	]
]
