extends Node

func load_audio(path, volume_db=0):
	var audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.stream = load("res://assets/audio/" + path)
	audio_stream_player.volume_db = volume_db
	add_child(audio_stream_player)
	return audio_stream_player

func _ready():
	var wind = load_audio("ambience_wind.wav", -10)
	wind.play()
	var music = load_audio("Autumn Lullaby.wav", -20)
	music.play()

func get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)

################################################################################

enum Item {
	CRACKER,
	CHOCOBERRY,
	SUGAR,
	MARSHMALLOW,
}

var state = {
	items =  {
		Item.CRACKER: 0,
		Item.CHOCOBERRY: 0,
		Item.SUGAR: 0,
		Item.MARSHMALLOW: 0,
	},
	head_elf_state = 0,
	give_sugar_event = false,
	gathered_resources = false,
	give_items_event = false,
	end_game_state = 0,
}

func get_num_items(item):
	return state.items[item]

func add_item(item, amount=1):
	state.items[item] += amount

func remove_item(item, amount=1):
	state.items[item] -= amount

################################################################################

var MESSAGES = {
	Elf = [
		[
			['eq',
				['get', ['end_game_state']],
				[6],
			],
			[
				"(whispered) Although I'm not sure we should give Marshmallow Elf one... I'm pretty sure he only uses 1 Sugar to make the Marshmallows, and he stashes the rest...",
			],
			[
				['set', ['end_game_state'], [1]]
			]
		],
		[
			['in-range',
				['get', ['end_game_state']],
				[1, 5],
			],
			[
				"You really helped us out. Everyone can get a smore now!",
			],
			[
				['++', ['end_game_state']]
			]
		],
		[
			['get', ['gathered_resources']],
			[
				"Thanks so much, Snowpal! Now we can all enjoy Smores!",
			],
			[
				['set', ['end_game_state'], [1]]
			]
		],
		[
			['and',
				['gte',
					['get', ['items', Item.CRACKER]],
					[10]
				],
				['and',
					['gte',
						['get', ['items', Item.MARSHMALLOW]],
						[10]
					],
					['gte',
						['get', ['items', Item.CHOCOBERRY]],
						[10]
					],
				],
			],
			[
				"Thank you so much, Snowpal! We can all enjoy smores now!",
			],
			[
				['set', ['gathered_resources'], [true]],
				['set', ['give_items_event'], [true]],
			]
		],
		[
			['eq',
				['get', ['head_elf_state']],
				[2]
			],
			[
				"I'll be waiting here for ingredients. We'll need 10 Crackers, 10 Marshmallows, and 10 Chocoberries. Thanks so much, Snowpal!",
			],
			[]
		],
		[
			['eq',
				['get', ['head_elf_state']],
				[1]
			],
			[
				"Yes, yes... I bet that’s what we all need to lift the spirits around here! Whaddaya say Snowpal? Could you talk to the elves and  help them get enough ingredients so they can make their favorite smores? THATS WHAT I AM TALKING ABOUT! Thanks a lot Snowpal!",
			],
			[
				['set', ['head_elf_state'], [2]]
			]
		],
		[
			[true],
			[
				"Merry holidays friend! Yesterday was another succesful Christmas with all the gifts delivered safely and on time. That really makes me jingle with happiness. Though, I must admit that it does put a bit of a strain on the elf folk, you know with the stress of timelines and protocol... Oh well, nothing that some delicious smores can’t cure...",
			],
			[
				['set', ['head_elf_state'], [1]]
			]
		],
	],
	MarshmallowElf = [
		[
			['get', ['gathered_resources']],
			[
				"Thanks a lot!",
				"This is lovely!",
				"Snowpal, I really appreciate this!",
				"Time to make some smores. Yummy!",
				"YAY!",
			],
			[]
		],
		[
			['gte',
				['get', ['items', Item.SUGAR]],
				[2]
			],
			[
				"Oooohhh! Is that Sugar I can smell? Let me turn that into a Marshmallow for you!",
			],
			[
				['set', ['give_sugar_event'], [true]]
			],
		],
		[
			[true],
			[
				"Hey there! I'm the Marshmallow Elf. If you fetch me 2 Sugars, I can turn them into Marshmallows!",
			],
			[]
		],
	],
	Others = [
		[
			['get', ['gathered_resources']],
			[
				"Thanks a lot!",
				"This is lovely!",
				"Snowpal, I really appreciate this!",
				"Time to make some smores. Yummy!",
				"YAY!",
			],
			[]
		],
		[
			['eq',
				['get', ['head_elf_state']],
				[2]
			],
			[
				"Thanks for agreeing to make us some smores, SnowPal!",
				"Have you got the ingredients yet Snowpal?",
				"Don’t overdo yourself Snowpal. You should finish your delivery first, then you can help someone else.",
			],
			[]
		],
		[
			[true],
			[
				"Hey, you should go talk to the head elf! He's next to the fire.",
			],
			[]
		],
	],
}

func parse(ast):
	if len(ast) == 1:
		return ast[0]
	if ast[0] == 'eq':
		return parse(ast[1]) == parse(ast[2])
	if ast[0] == 'gte':
		return parse(ast[1]) >= parse(ast[2])
	if ast[0] == 'and':
		return parse(ast[1]) and parse(ast[2])
	if ast[0] == 'get':
		var obj = state
		var path = ast[1].duplicate()
		while len(path) > 0:
			obj = obj[path.pop_front()]
		return obj
	if ast[0] == 'set':
		var obj = state
		var path = ast[1].duplicate()
		var value = parse(ast[2])
		while len(path) > 1:
			obj = obj[path.pop_front()]
		obj[path.pop_front()] = value
	if ast[0] == 'in-range':
		var value = parse(ast[1])
		return value >= ast[2][0] and value <= ast[2][1]
	if ast[0] == '++':
		var obj = state
		var path = ast[1].duplicate()
		while len(path) > 1:
			obj = obj[path.pop_front()]
		obj[path.pop_front()] += 1
		

func choose(array):
	return array[randi() % len(array)]

func get_message(name):
	var choices = MESSAGES.get(name)
	if choices == null:
		choices = MESSAGES.Others
	for choice in choices:
		var ast = choice[0]
		var messages = choice[1]
		var effects = choice[2]
		if parse(ast):
			var message = choose(messages)
			for effect in effects:
				parse(effect)
			return message
