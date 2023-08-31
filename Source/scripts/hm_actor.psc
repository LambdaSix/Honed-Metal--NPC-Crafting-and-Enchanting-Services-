ScriptName HM_Actor Extends Quest Conditional

;Mcm
Bool Property enchanting Auto Conditional
Bool Property tempering Auto Conditional
Bool Property crafting Auto Conditional
Bool Property restrict_npc_service Auto Conditional
Bool Property vendors_have_basic_mats Auto
Bool Property vendors_have_rare_mats Auto
Bool Property vendors_know_basic_enchantments Auto
Bool Property lore_based_smithing Auto
Bool Property skill_affects_quality Auto
Bool Property npc_skill_rebalance Auto
Bool Property allow_dual_enchantment Auto
Bool Property allow_courier_notification Auto
Bool Property crafting_messages Auto
Float Property minimum_skill_level Auto
Float Property max_skill_modifier Auto
Float Property craft_price_multiplier Auto
Float Property enchant_price_multiplier Auto
Float Property recharge_price_multiplier Auto
Float Property temper_price_multiplier Auto
Float Property materials_price_multiplier Auto
Float Property time_crafting_takes Auto
Float Property time_tempering_takes Auto
Float Property time_enchanting_takes Auto
Float Property time_recharging_takes Auto


;Miscellaneous
Perk Property StopSkillGain Auto
Perk Property vendor_discount Auto
Perk[] Property blacklisted Auto Hidden
Perk[] Property blacklisted_general Auto Hidden
Perk[] Property blacklisted_enchants Auto Hidden
Int Property vendor_disposition Auto Conditional
Int Property service_type Auto Hidden
Form[] Property known_enchantments Auto Hidden
Actor Property player Auto
Actor Property vendor Auto Hidden
Actor Property sale_merchant Auto
Actor Property mannequin Auto
Actor Property graymane Auto
Faction Property smithing_faction Auto
Faction Property enchanting_faction Auto
ReferenceAlias Property npc_stay_idle_alias Auto
FormList Property enchantments Auto
FormList Property orders_list Auto
String Property crafting_discipline Auto Hidden

Int Property NPC_SERVICE_COMPLETION_TIME Auto Hidden ;;Enumerator. Defined in HM_mod::createStructureElements() 
Int Property TIME_STARTED_WORKING Auto Hidden ;Enumerator. Defined in HM_mod::createStructureElements()
Int Property VENDOR_SKILL Auto Hidden ;Enumerator. Defined in HM_mod::createStructureElements()
Int Property TRANSACTION_TYPE Auto Hidden ;Enumerator. Defined in HM_mod::createStructureElements()

Int Property CRAFT_SERVICE = 1 AutoReadOnly ;Enumerator.
Int Property ENCHANT_SERVICE = 2 AutoReadOnly ;Enumerator.
Int Property TEMPER_SERVICE = 3 AutoReadOnly ;Enumerator. Armor and weapons.
Int Property TEMPER_ARMOR_SERVICE = 4 AutoReadOnly ;Enumerator. Just armor.
Int Property TEMPER_WEAPON_SERVICE = 5 AutoReadOnly ;Enumerator. Just weapons.
Int Property RECHARGE_SERVICE = 6 AutoReadOnly ;Enumerator
Int Property RACK_SERVICE = 7 AutoReadOnly ;Enumerator
Int Property SMITHING_PERKS = 8 AutoReadOnly ;Enumerator
Int Property ENCHANTING_PERKS = 9 AutoReadOnly ;Enumerator

HM_Mod Property _mod Auto


Form[] null
Perk[] nullperk
Perk[] added_perks
Perk[] removed_perks
Form[] craftsmen
String opposite_discipline
Int[] craftsmen_skill
Float player_skill
Float opposite_skill
Float calculated_skill
Float offset

State SkillMonitor
	Event onBeginState()
		Self.registerForSingleUpdate(0)
	EndEvent
	Event onEndState()
		Self.UnregisterForUpdate()
	EndEvent
	Event OnUpdate()
		Float delta = calculated_skill - player.GetActorValue(crafting_discipline)

		If (delta as Int)
			player.ModActorValue(crafting_discipline, (delta as Int) )
			offset += delta
		EndIf
		Self.registerForSingleUpdate(1.0)
	EndEvent
EndState


Function modifySkillLevel (Bool restore = false)
	If (restore)
		player.SetActorValue(crafting_discipline, player_skill)
		player.modActorValue(crafting_discipline, (offset * -1.0) As Int)
		player.SetActorValue(opposite_discipline, opposite_skill)
		offset = 0
		Return		
	EndIf	
	If (service_type != ENCHANT_SERVICE)
		crafting_discipline = "Smithing"
		opposite_discipline = "Enchanting"
	Else
		crafting_discipline = "Enchanting"
		opposite_discipline = "Smithing"
	EndIf
	Float skill_level = vendor.GetActorValue(crafting_discipline)
	
	If (npc_skill_rebalance)
		Float adjusted_skill = getPredeterminedSkillLevel(vendor.GetBaseObject() )
	
		If (!adjusted_skill)
			adjusted_skill = Math.Ceiling(((skill_level / vendor.GetLevel() ) * 10.0) )
			If (adjusted_skill > 100.0)
				adjusted_skill = 100.0
			EndIf
			If (adjusted_skill >= skill_level)
				skill_level = adjusted_skill
			EndIf
		Else
			skill_level = adjusted_skill
		EndIf
	EndIf
	skill_level *= max_skill_modifier
	If (skill_level < minimum_skill_level)
		skill_level = minimum_skill_level
	EndIf
	player_skill = player.GetBaseActorValue(crafting_discipline)
	player.SetActorValue(crafting_discipline, skill_level As Int)
	opposite_skill = player.GetBaseActorValue(opposite_discipline)
	player.SetActorValue(opposite_discipline, vendor.GetActorValue(opposite_discipline) As Int)
	calculated_skill = skill_level
EndFunction

;/If the player requests services from a lower skilled NPC, the skill will be adjusted but the player will retain their
current perks. Should we fix this? Why increase execution time by accounting for this very niche case? Why would anyone
even want something like this? For the materials maybe... consider for next release. /; 
Function removePerks(Bool opposite = False)
	Perk[] toremove = added_perks
	Int idx = toremove.find(none)

	If (opposite)
		ActorValueInfo avalue = ActorValueInfo.GetActorValueInfoByName(opposite_discipline)
		toremove = avalue.GetPerks(player, unowned = false, allRanks = true)
		removed_perks = toremove
		idx = toremove.length
	EndIf
	While (idx > 0)
		idx -= 1
		player.removePerk(toremove[idx])
	EndWhile
	added_perks = nullperk
EndFunction


Function addPerks (Bool removed = false, Int skill = 0)
	If (removed)
		Int idx = removed_perks.length

		While (idx)
			idx -=1
			player.addPerk(removed_perks[idx])
		EndWhile
		removed_perks = nullperk
		Return
	EndIf
	If (!skill)
		skill = calculated_skill as Int
	EndIf
	ActorValueInfo discipline = ActorValueInfo.GetActorValueInfoByName(crafting_discipline)
	Perk[] craftsmans_perks = discipline.GetPerks(player, allRanks = true)
	Int idx = craftsmans_perks.length
	Int added = 1
	
	;added_perks = utility.CreateFormArray(1 + idx * ((idx < 512) as Int) )
	added_perks = new perk[128]
	added_perks[0] = stopSkillGain
	player.addPerk(stopSkillGain)
	While (idx)
		idx -= 1
		Perk current = craftsmans_perks[idx]
		If (skill >= HMCraftingUtils.getSkillReqForPerk(current, crafting_discipline) && blacklisted.find(current) < 0)
			player.addPerk(current)
			added_perks[added] = current
			added += 1
		EndIf
	EndWhile
EndFunction


Function resetPerks ()
	ActorValueInfo	craftav = ActorValueInfo.GetActorValueInfoByName("Smithing")
	ActorValueInfo	enchantav = ActorValueInfo.GetActorValueInfoByName("Enchanting")
	Perk[]			smith_perks = craftav.GetPerks(player, false, true)
	Perk[]			enchant_perks = enchantav.GetPerks(player, false, true)
	Int				perk_number = smith_perks.length
	Int				perk_points
	Perk			current_perk
	
	While (perk_number)
		perk_number -= 1
		current_perk = smith_perks[perk_number]
		If (player.HasPerk(current_perk) )
			player.RemovePerk(current_perk)
			perk_points += 1
		EndIf		
	EndWhile
	perk_number = enchant_perks.length
	While (perk_number)
		perk_number -= 1
		current_perk = enchant_perks[perk_number]
		If (player.HasPerk(current_perk) )
			player.RemovePerk(current_perk)
			perk_points += 1
		EndIf		
	EndWhile
	Game.AddPerkPoints(perk_points)
	player.SetActorValue ("smithing", 10)
	player.SetActorValue ("enchanting", 10)
EndFunction


Function InitializePredeterminedSkills (Bool include_dragonborn, Bool include_dawnguard)
	craftsmen = New Form[32]
	craftsmen_skill = New Int[32]
	
	;Smiths
	craftsmen[0] = Game.GetFormFromFile(0x0001361E, "Skyrim.esm"); Rustleif
	craftsmen[1] = Game.GetFormFromFile(0x00013B7C, "Skyrim.esm"); Gharol
	craftsmen[2] = Game.GetFormFromFile(0x00013650, "Skyrim.esm"); Lod
	craftsmen[3] = Game.GetFormFromFile(0x0001B079, "Skyrim.esm"); Dushnamub
	craftsmen[4] = Game.GetFormFromFile(0x0001339A, "Skyrim.esm"); Ghorza gra-Bagol
	craftsmen[5] = Game.GetFormFromFile(0x00055A5E, "Skyrim.esm"); Moth gro-Bagol
	craftsmen[6] = Game.GetFormFromFile(0x00019957, "Skyrim.esm"); Shuftharz
	craftsmen[7] = Game.GetFormFromFile(0x00029DAD, "Skyrim.esm"); Arnskar Ember-Master
	craftsmen[8] = Game.GetFormFromFile(0x00019DF2, "Skyrim.esm"); Asbjorn Fire-Tamer
	craftsmen[9] = Game.GetFormFromFile(0x0001334C, "Skyrim.esm"); Balimund 
	craftsmen[10] = Game.GetFormFromFile(0x00013475, "Skyrim.esm") ;Alvor
	craftsmen[11] = Game.GetFormFromFile(0x00013261, "Skyrim.esm") ;Beirand
	craftsmen[12] = Game.GetFormFromFile(0x00013B9D, "Skyrim.esm") ;Eorlund Gray-Mane
	craftsmen[13] = Game.GetFormFromFile(0x00013BB9, "Skyrim.esm") ;Adrianne Avenicci
	craftsmen[14] = Game.GetFormFromFile(0x00014142, "Skyrim.esm") ;Oengul War-Anvil
	craftsmen[15] = Game.GetFormFromFile(0x000136C3, "Skyrim.esm") ;Filnjar
	craftsmen[16] = Game.GetFormFromFile(0x00013B9F, "Skyrim.esm") ;Ulfberth War Bear
	craftsmen_skill[0] = 29
	craftsmen_skill[1] = 50
	craftsmen_skill[2] = 50
	craftsmen_skill[3] = 80
	craftsmen_skill[4] = 80
	craftsmen_skill[5] = 90
	craftsmen_skill[6] = 50
	craftsmen_skill[7] = 70
	craftsmen_skill[8] = 30
	craftsmen_skill[9] = 80
	craftsmen_skill[10] = 29
	craftsmen_skill[11] = 80
	craftsmen_skill[12] = 100
	craftsmen_skill[13] = 50
	craftsmen_skill[14] = 60
	craftsmen_skill[15] = 29
	craftsmen_skill[16] = 50 ; Same as Adrianne, since she's the one doing the crafting. Ulfberth states that himself.
	
	;Enchanters
	craftsmen[21] = Game.GetFormFromFile(0x00014146, "Skyrim.esm") ;Wuunferth the Unliving 
	craftsmen[22] = Game.GetFormFromFile(0x000132AA, "Skyrim.esm") ;Sybille Stentor
	craftsmen[23] = Game.GetFormFromFile(0x0001365F, "Skyrim.esm") ;Dravynea the Stoneweaver 
	craftsmen[24] = Game.GetFormFromFile(0x0001338E, "Skyrim.esm") ;Cacelmo
	craftsmen[25] = Game.GetFormFromFile(0x00019DEF, "Skyrim.esm") ;Wylandriah
	craftsmen[26] = Game.GetFormFromFile(0x00013BBB, "Skyrim.esm") ;Farengar Secret-Fire
	craftsmen[27] = Game.GetFormFromFile(0x0001E765, "Skyrim.esm") ;Hammal
	craftsmen[28] = Game.GetFormFromFile(0x0001C23E, "Skyrim.esm") ;Sergius Turrianus
	craftsmen_skill[21] = 70
	craftsmen_skill[22] = 60
	craftsmen_skill[23] = 45
	craftsmen_skill[24] = 80
	craftsmen_skill[25] = 65
	craftsmen_skill[26] = 55
	craftsmen_skill[27] = 90
	craftsmen_skill[28] = 100

	If (include_dawnguard)
		craftsmen[17] = Game.GetFormFromFile(0x0000336C, "Dawnguard.esm") ;Gunmar 0x0000336C
		craftsmen[18] = Game.GetFormFromFile(0x00003365, "Dawnguard.esm") ;Hestla
		craftsmen_skill[17] = 70		
		craftsmen_skill[18] = 45
	EndIf
	If (include_dragonborn)
		craftsmen[19] = Game.GetFormFromFile(0x0001828E, "Dragonborn.esm") ;Glover Mallory
		craftsmen[20] = Game.GetFormFromFile(0x00018FB5, "Dragonborn.esm") ;Baldor Iron-Shaper		
		craftsmen_skill[19] = 80	
		craftsmen_skill[20] = 90		
	EndIf	
EndFunction

Function overridePredeterminedSkill (Actor npc, Int new_skill_value, String discipline)
	Int craftsman_idx = craftsmen.Find(npc.GetBaseObject() ) ;20 = smithing - enchanting idx boundary

	If (npc)
		If (craftsman_idx < 0 || (craftsman_idx > 20 && discipline == "Smithing") || \
			(craftsman_idx <= 20 && discipline == "Enchanting") )
				Return
		EndIf
		craftsmen_skill[craftsman_idx] = new_skill_value	
	EndIf	
EndFunction


Actor Function getClosestActor ()
	Float posX = player.GetPositionX()
	Float posY = player.GetPositionY()
	Float posZ = player.GetPositionZ()
	Float rotation = player.GetAngleZ()
	Float distance = 128.0
	Float offsetX = (Math.sin(rotation) * distance) + posX
	Float offsetY = (Math.cos(rotation) * distance) + posY
	
	Return Game.FindClosestActor(offsetX, offsetY, posZ, 256)	
EndFunction


Function addNPCToFaction (Bool smithing)
	HM_Mod	mod = ((Self As Quest) As HM_mod)
	Actor	npc = getClosestActor()

	If (smithing)
		npc.AddToFaction(smithing_faction)
	Else
		npc.AddToFaction(enchanting_faction)
	EndIf
	Debug.MessageBox(npc.GetBaseObject().GetName() + mod.messages.ADDED_FACTION)
EndFunction


Function learnEnchantments (Bool learn = True)	
	Form[]	enchantments_list = enchantments.ToArray()
	Int		enchantment_number = enchantments_list.Length
	Int		known
		
	While (enchantment_number)
		enchantment_number -= 1		
		If (learn && enchantments_list[enchantment_number].PlayerKnows() )
			known_enchantments[known] = enchantments_list[enchantment_number]
			known += ((known < 128) as Int)
		ElseIf (known_enchantments.Find(enchantments_list[enchantment_number]) < 0)
			enchantments_list[enchantment_number].SetPlayerKnows(learn)
		EndIf
	EndWhile	
EndFunction


Function immobilizeNPC (Actor vendor, Bool restrain = True)
	If (restrain)
		npc_stay_idle_alias.ForceRefTo(vendor)
		vendor.EvaluatePackage()
	Else
		npc_stay_idle_alias.Clear()
	EndIf
EndFunction

Bool increased;
Function increasePlayerEncumbrance (Bool increase = True)
	Float encumbrance = 90000.0
	If (increase)		
		player.ModAV("carryWeight", encumbrance)
		increased = True
	ElseIf (increased)
		player.ModAV("carryWeight", (encumbrance * -1.0) )
		increased = False
	EndIf
EndFunction


Function calculateNpcServiceTime ()	
	HM_inventory	_inventory = _mod._inventory
	Int				items = _inventory.new_equipment.length
	Float			random = utility.randomFloat(1.0, 0.5 + math.log(vendor.getav(crafting_discipline) * 0.4343) )
	Float			modifier = 0.01
	Float			time
	
	If (service_type == ENCHANT_SERVICE)
		time = time_enchanting_takes
	ElseIf (service_type == RECHARGE_SERVICE)
		time = time_recharging_takes
	ElseIf (service_type == CRAFT_SERVICE)	
		time = time_crafting_takes
		modifier = 0.075
	Else
		time = time_tempering_takes
		modifier = 0.035
	EndIf
	If (time)
		time *= random
		While (items)
			items -= 1
			time += math.log(_inventory.new_equipment[items].getGoldValue() ) * 0.4343 * modifier
		EndWhile
	EndIf
	Form[]	used_mats = _inventory.materials_used
	Form[]	rare = _inventory.rare_materials.ToArray()
	Form[]	common = _inventory.materials.ToArray()
	Form[]	in_inventory = _inventory.npc_materials
	Int		mat_count
	Int		rare_mat_count
	Int		idx = used_mats.Find(None)

	If (idx > 0)
		While (idx)
			idx -= 1
			rare_mat_count += (rare.Find(used_mats[idx]) > -1 && in_inventory.find(used_mats[idx]) == -1)  As Int
		EndWhile
		idx = used_mats.find(none)
		While (idx)
			idx -= 1
			mat_count += (common.Find(used_mats[idx]) > -1 && in_inventory.find(used_mats[idx]) == -1) As Int
		EndWhile
		time += (mat_count * _inventory.common_materials_acquisition_time) + \
			(rare_mat_count * _inventory.rare_materials_acquisition_time)
	EndIf
	_mod._hmael.aStructureAddMember(vendor, NPC_SERVICE_COMPLETION_TIME, null, 0, time)
EndFunction


Function sendCourierNotification ()
	Float completion_time = _mod._hmael.aStructureGetMember_float(vendor, NPC_SERVICE_COMPLETION_TIME)
	If (completion_time)
		_mod._courier.addPostRequest(vendor, (completion_time * 24.0) ) ;converting from days to hours.
	EndIf
EndFunction


Int Function getPredeterminedSkillLevel (Form base_actor)
	Int index = craftsmen.Find(base_actor)

	If (!base_actor || index < 0 || (index > 20 && crafting_discipline == "Smithing") || \
		(index <= 20 && crafting_discipline == "Enchanting") )
			Return (0)
	EndIf
	Return (craftsmen_skill[index])
EndFunction

Int Property script_version Hidden
Int Function get ()
	return (13)
EndFunction
EndProperty
