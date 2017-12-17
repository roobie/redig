Red [
		Title: "Flags"
]

do %func.red

flags: context [
	new: func [
		names[block!]
		return: [object!]
	][
		seq: f/sequences

		return context [
			data: #()
			foreach name names [
				put data name seq/powers-of-two
			]
			mask: func [names /local result][
				result: 0
				foreach name names [
					result: (select data name) or result
				]
				return result
			]
			is-set: func [mask name][
				(mask or (select data name)) = mask
			]
		]
	]
]

access: flags/new [exec write read]
probe (access)
rwmask: access/mask [write read]
print access/is-set rwmask 'write
