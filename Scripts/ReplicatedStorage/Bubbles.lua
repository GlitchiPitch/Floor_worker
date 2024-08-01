local tutorial = {
    -- как пополнить уровни,
    -- мне нужно сначала 
}

local wardenBubbles = {
	brokenConveyor = "What, wait here i will call helper",
	getBribe = {
		"Do you think I'm a poor man who, if you show him a coin, will break his forehead?",
		"Go for a walk uncle, let's pretend we didn't see anything",
	},
	notEnoughMoney = 'You have no money',
}

local playerBubbles = {
	hungry = "I'm hungry i need to take a bread from that hole",
	zeroChemicals = "I have no chemicals, let's take them near the screen",
	liquidLevelIsFull = 'liquid level is full turn off it',
	conveyourIsOn = 'conveyour is on turn off it',
	isWorking = 'conveyor is broken',
	dailyNorm = 'daily norm was reached, need go to sleep',
}

local mood = {
	"I hope I save up enough money to get out of here",
	"I need to get out of here to see my family",
}


return {
	tutorial = tutorial,
	wardenBubbles = wardenBubbles,
	playerBubbles = playerBubbles,
	mood = mood,
}