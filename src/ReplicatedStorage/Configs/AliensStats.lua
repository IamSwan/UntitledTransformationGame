local template = {
	["MaxHealth"] = 100,
	["AttackMult"] = 1,
	["WalkSpeed"] = 12,
	["RunSpeed"] = 12 * 2,
	["JumpHeight"] = 7.2,
}

return table.freeze({
	["Human"] = template,
	["Pyronite"] = {
		["MaxHealth"] = 160,
		["AttackMult"] = 1.5,
		["WalkSpeed"] = 12,
		["RunSpeed"] = 12 * 2.5,
		["JumpHeight"] = 10,
	},
	["Kineceleran"] = {
		["MaxHealth"] = 80,
		["AttackMult"] = 1.2,
		["WalkSpeed"] = 30,
		["RunSpeed"] = 30 * 5,
		["JumpHeight"] = 7.2,
	},
	["Petrosapien"] = {
		["MaxHealth"] = 230,
		["AttackMult"] = 2,
		["WalkSpeed"] = 12,
		["RunSpeed"] = 12 * 2,
		["JumpHeight"] = 10,
	},
	["Ectonurite"] = {
		["MaxHealth"] = 120,
		["AttackMult"] = 1.2,
		["WalkSpeed"] = 12,
		["RunSpeed"] = 12 * 2.5,
		["JumpHeight"] = 7.2,
	},
	["Dummian"] = {
		["MaxHealth"] = 9999,
		["AttackMult"] = 20,
		["WalkSpeed"] = 20,
		["RunSpeed"] = 80 * 3,
		["JumpHeight"] = 30,
	},
})
