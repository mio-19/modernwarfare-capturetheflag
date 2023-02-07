local rankings = ctf_rankings.init()
local recent_rankings = ctf_modebase.recent_rankings(rankings)
local features = ctf_modebase.features(rankings, recent_rankings)

local old_bounty_reward_func = ctf_modebase.bounties.bounty_reward_func
local old_get_next_bounty = ctf_modebase.bounties.get_next_bounty
-- based on classic mode
ctf_modebase.register_mode("modern", {
	treasures = {
		["default:ladder_wood" ] = {                max_count = 40, rarity = 0.6, max_stacks = 5}, -- modern: increase count
		["default:torch"       ] = {                max_count = 40, rarity = 0.6, max_stacks = 5}, -- modern: increase count

		["default:cobble"      ] = {min_count = 78, max_count = 99, rarity = 0.6, max_stacks = 2}, -- modern: increase count
		["default:wood"        ] = {min_count = 45, max_count = 99, rarity = 0.6, max_stacks = 2}, -- modern: increase count

		["ctf_teams:door_steel"] = {rarity = 0.4, max_stacks = 3}, -- modern: increase count

		["default:pick_steel"  ] = {rarity = 0.6, max_stacks = 3}, -- modern: increase count
		["default:shovel_steel"] = {rarity = 0.6, max_stacks = 2}, -- modern: increase count
		["default:axe_steel"   ] = {rarity = 0.6, max_stacks = 2}, -- modern: increase count

		["ctf_melee:sword_steel"  ] = {rarity = 0.6  , max_stacks = 2}, -- modern: increase count

		["ctf_ranged:pistol_loaded" ] = {rarity = 0.6 , max_stacks = 2}, -- modern: increase count
		["ctf_ranged:rifle_loaded"  ] = {rarity = 0.6                 }, -- modern: increase count
		["ctf_ranged:shotgun_loaded"] = {rarity = 0.6                }, -- modern: increase count
		["ctf_ranged:smg_loaded"    ] = {rarity = 0.6                }, -- modern: increase count

		["ctf_ranged:ammo" ] = {min_count = 4, max_count = 10, rarity = 0.6 , max_stacks = 2}, -- modern: increase count
		["default:apple"   ] = {min_count = 6, max_count = 16, rarity = 0.6 , max_stacks = 2}, -- modern: increase count

		["grenades:frag" ] = {min_count = 2, max_count = 5, rarity = 0.4, max_stacks = 1}, -- modern: increase count
		["grenades:smoke"] = {min_count = 2, max_count = 5, rarity = 0.6, max_stacks = 2}, -- modern: increase count

		-- modern: added
		["ctf_healing:medkit" ] = {rarity = 0.5 , max_stacks = 2},
		["vehicles:missile_2_item"] = {min_count = 3, max_count = 16, rarity = 0.5, max_stacks = 5},
		["vehicles:rc"] = {rarity = 0.3},
		["vehicles:apache_spawner"] = {rarity = 0.3},
		["vehicles:backpack"] = {rarity = 0.3},
	},
	crafts = {"ctf_ranged:ammo", "ctf_melee:sword_steel", "ctf_melee:sword_mese", "ctf_melee:sword_diamond"},
	physics = {sneak_glitch = true, new_move = false},
	team_chest_items = {"default:cobble 99", "default:wood 99", "default:torch 30", "ctf_teams:door_steel 6",
						"ctf_healing:medkit 30", "vehicles:apache_spawner 2", "vehicles:backpack 4", "vehicles:missile_2_item 32", "vehicles:rc 4"}, -- modern: new items
	rankings = rankings,
	recent_rankings = recent_rankings,
	summary_ranks = {
		_sort = "score",
		"score",
		"flag_captures", "flag_attempts",
		"kills", "kill_assists", "bounty_kills",
		"deaths",
		"hp_healed"
	},

	stuff_provider = function()
		--return {"default:sword_stone", "default:pick_stone", "default:torch 15", "default:stick 5"}
		return {"default:sword_steel", "default:pick_steel", "default:torch 15", "default:stick 5", "ctf_ranged:rifle_loaded 1"} -- modern: changed
	end,
	initial_stuff_item_levels = features.initial_stuff_item_levels,
	on_mode_start = function()
		ctf_modebase.bounties.bounty_reward_func = ctf_modebase.bounty_algo.kd.bounty_reward_func
		ctf_modebase.bounties.get_next_bounty = ctf_modebase.bounty_algo.kd.get_next_bounty
	end,
	on_mode_end = function()
		ctf_modebase.bounties.bounty_reward_func = old_bounty_reward_func
		ctf_modebase.bounties.get_next_bounty = old_get_next_bounty
	end,
	on_new_match = features.on_new_match,
	on_match_end = features.on_match_end,
	team_allocator = features.team_allocator,
	on_allocplayer = features.on_allocplayer,
	on_leaveplayer = features.on_leaveplayer,
	on_dieplayer = features.on_dieplayer,
	on_respawnplayer = features.on_respawnplayer,
	can_take_flag = features.can_take_flag,
	on_flag_take = features.on_flag_take,
	on_flag_drop = features.on_flag_drop,
	on_flag_capture = features.on_flag_capture,
	on_flag_rightclick = function() end,
	get_chest_access = features.get_chest_access,
	can_punchplayer = features.can_punchplayer,
	on_punchplayer = features.on_punchplayer,
	on_healplayer = features.on_healplayer,
	calculate_knockback = function()
		return 0
	end,
})

-- modern begin
ctf_modebase.current_mode = "modern"
ctf_modebase.mode_on_next_match = "modern"

local select_map_for_mode_old = ctf_modebase.map_catalog.select_map_for_mode
function ctf_modebase.map_catalog.select_map_for_mode(mode)
	if mode == "modern" then
		return select_map_for_mode_old("classic")
	end
	return select_map_for_mode_old(mode)
end