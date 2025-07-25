extends Node

enum States { IDLE, WALK, RUN, ATTACK, HURT, DEAD}
enum Direction { DOWN, UP, LEFT, RIGHT }
enum SlimeForm { GREEN, DEAD, LAVA}

const STATE_NAMES = {
	States.IDLE: "idle",
	States.WALK: "walk",
	States.RUN: "run",
	States.ATTACK: "attack",
	States.HURT: "hurt",
	States.DEAD: "dead"
}

const DIRECTION_NAMES = {
	Direction.DOWN: "down",
	Direction.UP: "up",
	Direction.LEFT: "left",
	Direction.RIGHT: "right"
}

const SLIME_FORMS = {
	SlimeForm.GREEN: {
		"name": "slime1",
		"fill_color": Color("63c99f"),
		"bg_color": Color("264547")
		},
	SlimeForm.DEAD: {
		"name": "slime2",
		"fill_color": Color("88c6ff"),
		"bg_color": Color("413b69")
		},
	SlimeForm.LAVA: {
		"name": "slime3",
		"fill_color": Color("eeb53f"),
		"bg_color": Color("41302f")
		}
}
