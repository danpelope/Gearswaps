

-------------------------------------------------------------------------------------------------------------------
-- Initialization function that defines sets and variables to be used.
-------------------------------------------------------------------------------------------------------------------
 
-- IMPORTANT: Make sure to also get the Mote-Include.lua file (and its supplementary files) to go with this.
 
-- Initialization function for this job file.
function get_sets()
	mote_include_version = 2

	-- Load and initialize the include file.
	include('Mote-Include.lua')
end
 
 
-- Setup vars that are user-independent.
function job_setup()
	
end
 
 
-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
	-- Options: Override default values
    state.OffenseMode:options('Normal', 'Acc')
    state.WeaponskillMode:options('Normal', 'Acc')
    state.HybridMode:options('Normal', 'PDT')
    state.CastingMode:options('Normal', 'Resistant')
    state.IdleMode:options('Normal','PDT')
    state.PhysicalDefenseMode:options('PDT', 'MDT')

end
 
-- Called when this job file is unloaded (eg: job change)
function file_unload()
	if binds_on_unload then
			binds_on_unload()
	end

	send_command('unbind ^`')
	send_command('unbind !-')
end
 
	   
-- Define sets and vars used by this job file.
function init_gear_sets()
sets.precast.FC = {ear2="Loquacious Earring"}

sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {})

sets.Twilight = {head="Twilight Helm",body="Twilight Mail"}
-- Weaponskill sets
-- Default set for any weaponskill that isn't any more specifically defined
sets.gorgets = {}
sets.gorgets.light = {neck="Light Gorget",waist="Light Belt"}
sets.gorgets.wind = {neck="Breeze Gorget",waist="Breeze Belt"}
sets.gorgets.ice = {neck="Snow Gorget",waist="Snow Belt"}

sets.precast.WS = {ammo="Hagneia Stone",head="Otomi Helm",neck="Asperity Necklace",ear1="Steelflash Earring",ear2="Bladeborn Earring",
	body="Xaddi Mail",hands="Miki. Gauntlets",ring1="Pyrosoul Ring",ring2="Rajas Ring",
	back="Letalis Mantle",waist="Wanion Belt",legs="Cizin Breeches +1",feet="Ejekamal Boots"}
sets.precast.WS.Acc = set_combine(sets.precast.WS, {waist="Dynamic Belt"})

-- Specific weaponskill sets. Uses the base set if an appropriate WSMod version isn't found.
sets.precast.WS['Resolution'] = set_combine(sets.precast.WS, sets.gorgets.wind)
sets.precast.WS['Resolution'].Acc = set_combine(sets.precast.WS['Resolution'], {head="Yaoyotl Helm",feet="Whirlpool Greaves"})

-- Midcast Sets
sets.midcast.FastRecast = {
	head="Otomi Helm",ear2="Loquacious Earring",
	body="Xaddi Mail",hands="Xaddi Gauntlets",ring1="Prolix Ring",
	legs="Cizin Breeches +1",feet="Whirlpool Greaves"}
		
-- any ninjutsu cast on self
sets.midcast.SelfNinjutsu = sets.midcast.FastRecast

-- any ninjutsu cast on enemies
sets.midcast.Ninjutsu = {}

--sets.midcast.Ninjutsu.Resistant = {}


-- Sets to return to when not performing an action.

-- Resting sets
sets.resting = {}

-- Idle sets (default idle set not needed since the other three are defined, but leaving for testing purposes)
sets.idle = {ammo="Hagneia Stone",head="Twilight Helm",neck="Wiglen Gorget",ear1="Steelflash Earring",ear2="Bladeborn Earring",
	body="Kumarbi's Akar",hands="Xaddi Gauntlets",ring1="Sheltered Ring",ring2="Paguroidea Ring",
	back="Letalis Mantle",waist="Flume Belt",legs="Blood Cuisses",feet="Ejekamal Boots"}

sets.idle.Town = sets.idle
sets.idle.Twilight = set_combine(sets.idle.Town, sets.Twilight)
sets.idle.Weak = set_combine(sets.idle.Town, sets.Twilight)

-- Defense sets

sets.defense.PDT = {
	head="Ighwa Cap",neck="Twilight Torque",ear1="Steelflash Earring",ear2="Bladeborn Earring",
	body="Xaddi Mail",hands="Umuthi Gloves",ring1="Dark Ring",ring2="Dark Ring",
	back="Iximulew Cape",waist="Flume Belt",legs="Cizin Breeches +1",feet="Gor. Sollerets +1"}
sets.defense.Twilight = set_combine(sets.defense.PDT, sets.Twilight)
sets.defense.MDT = set_combine(sets.defense.PDT, {back="Mubvum. Mantle"})

sets.Kiting = {legs="Blood Cuisses"}

-- Engaged sets

-- Variations for TP weapon and (optional) offense/defense modes. Code will fall back on previous
-- sets if more refined versions aren't defined.
-- If you create a set with both offense and defense modes, the offense mode should be first.
-- EG: sets.engaged.Dagger.Accuracy.Evasion

-- Normal melee group
sets.engaged = {ammo="Hagneia Stone",
	head="Otomi Helm",neck="Asperity Necklace",ear1="Steelflash Earring",ear2="Bladeborn Earring",
	body="Xaddi Mail",hands="Xaddi Gauntlets",ring1="K'ayres Ring",ring2="Rajas Ring",
	back="Letalis Mantle",waist="Windbuffet Belt",legs="Cizin Breeches +1",feet="Ejekamal Boots"}
sets.engaged.Acc = {neck="Iqabi Necklace",hands="Buremte Gloves",ring1="Mars's Ring",ring2="Enlivened Ring",waist="Dynamic Belt"}
sets.engaged.Twilight = set_combine(sets.engaged, sets.Twilight)
sets.engaged.Acc.Twilight = set_combine(sets.engaged.Acc, sets.Twilight)
sets.engaged.PDT = set_combine(sets.engaged, sets.defense.PDT)
sets.engaged.Acc.PDT = set_combine(sets.engaged.Acc, sets.defense.PDT)

 
		-- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
		-- sets if more refined versions aren't defined.
		-- If you create a set with both offense and defense modes, the offense mode should be first.
		-- EG: sets.engaged.Dagger.Accuracy.Evasion
	   
		-- Normal melee group

end
 
-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks that are called to process player actions at specific points in time.
-------------------------------------------------------------------------------------------------------------------
 

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.
function job_precast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Magic' then
		equip(sets.precast.FC)
	end
end
 

 
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_midcast(spell, action, spellMap, eventArgs)
	if spell.action_type == 'Magic' then
		equip(sets.midcast.FastRecast)
	end
end
 
-- Run after the default midcast() is done.
-- eventArgs is the same one used in job_midcast, in case information needs to be persisted.
function job_post_midcast(spell, action, spellMap, eventArgs)
    if spellMap == 'Cure' and spell.target.type == 'SELF' then
        equip(sets.midcast.CureSelf)
    end
end
 
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
--  function job_aftercast(spell, action, spellMap, eventArgs)
--      if not spell.interrupted then
--              if state.Buff[spell.english] ~= nil then
--                      state.Buff[spell.english] = true
--              end
--       end
--  end
 
-------------------------------------------------------------------------------------------------------------------
-- Customization hooks for idle and melee sets, after they've been automatically constructed.
-------------------------------------------------------------------------------------------------------------------
-- Modify the default idle set after it was constructed.
function customize_idle_set(idleSet)
	return idleSet
end
 
-- Modify the default melee set after it was constructed.
function customize_melee_set(meleeSet)
	return meleeSet
end
 
function job_buff_change(buff, gain)
	update_combat_form()
end
 
-- Called when the player's status changes.
function job_state_change(field, new_value, old_value)
	update_combat_form()
end

function job_post_precast(spell, action, spellMap, eventArgs)
	-- Make sure abilities using head gear don't swap 
    if spell.type:lower() == 'weaponskill' then
		if world.time >= (17*60) or world.time <= (7*60) then
			equip(sets.Lugra)
        end
    end
end

function update_combat_form()
    -- Check Weapontype
	if player.equipment.main == 'Ragnarok' then
        state.CombatForm:set('Ragnarok')
    else
		state.CombatForm:reset()
	end
end
 
-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_combat_form()
end
 
function select_default_macro_book()
	-- Default macro set/book
	-- I realize this will be better used with different /subs per book,
	-- but I won't worry about that till I get this working properly.
end