ScriptName HM_MCM Extends SKI_ConfigBase

HM_mod Property			_mod Auto
HM_Inventory Property	_inventory Auto
HM_Actor Property		_actor Auto
Float Property			SKILL_CAP = 200 AutoReadOnly

String[]				menu_entries
Int						menu_version




Event OnConfigInit()
	menu_entries = New String[2]
	menu_version = 11
EndEvent

Event OnPageReset(String page)	
	drawMenu("$General", 0)
	drawMenu("$Maintenance", 1)
EndEvent

Event OnOptionSliderOpen(Int option)
	setMenuParameters(option)
EndEvent

Event OnOptionSliderAccept(Int option, Float value)
	updateMenu(option, value, True)
	updateModValues(option, value)
EndEvent

Event OnOptionSelect(Int option)
	Bool value = updateMenu(option)
	updateModValues(option, value As Float)
EndEvent

Event OnOptionMenuOpen(Int option)
	setMenuParameters(option)
	drawSubMenu(0, 0, menu_entries)
EndEvent

Event OnOptionMenuAccept (Int option, Int index)
	updateModValues (option, index As Float)
EndEvent

Event OnOptionHighlight(Int option) 
	drawToolTips(option)
EndEvent

Event OnVersionUpdate (Int version)
	If (version != menu_version)
		menu_entries = New String[2]
		menu_version = 11	
	EndIf
EndEvent



Int craft
Int temper
Int enchant
Int skillsmithing
Int use_mats
Int use_raremats
Int use_enchants
Int use_dualench
Int use_courier
Int skillrebal
Int limitservice
Int minskill
Int skillcap
Int craftcost
Int tempcost
Int enchcost
Int matscost
Int chargecost
Int repairmod
Int deletemod
Int resetperks
Int resetskill
Int recoverlost
Int addfactionsmith
Int addfactionench
Int modskill
Int modsmithskill
Int modenchskill
Int craftime
Int tempertime
Int enchtime
Int chargetime
Int matstime
Int raremattime
Int craftingmssgs
Int perksdebug

Function drawMenu (String header, Int cursor_position)
	SetCursorFillMode(TOP_TO_BOTTOM)
	SetCursorPosition(cursor_position)
	AddHeaderOption(header)
	If (header == "$General")
		craft = AddToggleOption("$Allow Crafting", _actor.crafting)
		temper = AddToggleOption("$Allow Tempering", _actor.tempering)
		enchant = AddToggleOption("$Allow Enchanting", _actor.enchanting)
		limitservice = AddToggleOption("$NPC Limit Service", _actor.restrict_npc_service)
		skillsmithing = AddToggleOption("$Skill Based Smithing", _actor.skill_affects_quality)
		use_mats = AddToggleOption("$NPCs Have Materials", _actor.vendors_have_basic_mats)
		use_raremats = AddToggleOption("$NPCs Have Rare Materials", _actor.vendors_have_rare_mats)
		use_enchants = AddToggleOption("$Enchanters Know Enchantments", _actor.vendors_know_basic_enchantments)
		skillrebal = AddToggleOption("$NPC Skill Rebalance", _actor.npc_skill_rebalance)
		use_dualench = AddToggleOption("$Use Dual Enchantments", _actor.allow_dual_enchantment)
		use_courier = AddToggleOption("$Allow Courier Notifications", _actor.allow_courier_notification)
		AddEmptyOption()
		minskill = AddSliderOption("$NPC Minimum Skill Level", _actor.minimum_skill_level, "{0}")
		skillcap = AddSliderOption("$NPC Skill Level Cap", _actor.max_skill_modifier * 100.0, "{0}")
		craftcost = AddSliderOption("$Crafting Cost Multiplier", _actor.craft_price_multiplier, "{2}")
		tempcost = AddSliderOption("$Tempering Cost Multiplier", _actor.temper_price_multiplier, "{2}")
		enchcost = AddSliderOption("$Enchanting Cost Multiplier", _actor.enchant_price_multiplier, "{2}")
		chargecost = AddSliderOption("$Recharge Cost Multiplier", _actor.recharge_price_multiplier, "{2}")
		matscost = AddSliderOption("$Materials Cost Multiplier", _actor.materials_price_multiplier, "{2}")
	ElseIf (header == "$Maintenance")
		repairmod = AddToggleOption("$Repair", False)	
		deletemod = AddToggleOption("$Uninstall Mod", False)
		recoverlost = AddToggleOption("$Recover Lost Items", False)
		perksdebug = AddToggleOption("$Test Perks", False)
		resetperks = AddToggleOption("$Reset Perks", False)
		resetskill = AddToggleOption("$Reset NPC Skill", False)
		craftingmssgs = AddToggleOption("$Status Messages", _actor.crafting_messages)
		AddHeaderOption("")
		addfactionsmith = AddMenuOption("$Add NPC To Smithing Faction", "")		
		addfactionench = AddMenuOption("$Add NPC To Enchanting Faction", "")
		modskill = AddTextOption("$Change NPC Skill", "")		
		modsmithskill = AddSliderOption("$NPC Smithing-Skill Level", 0.0, "{0}", OPTION_FLAG_DISABLED)
		modenchskill = AddSliderOption("$NPC Enchanting-Skill Level", 0.0, "{0}", OPTION_FLAG_DISABLED)
		AddHeaderOption("")
		craftime = AddSliderOption("$Crafting Time", _actor.time_crafting_takes, "{2}")
		tempertime = AddSliderOption("$Tempering Time", _actor.time_tempering_takes, "{2}")
		enchtime = AddSliderOption("$Enchanting Time", _actor.time_enchanting_takes, "{2}")
		chargetime = AddSliderOption("$Recharging Time", _actor.time_recharging_takes, "{2}")
		matstime = AddSliderOption("$Common Materials Acquisition Time", _inventory.common_materials_acquisition_time, "{2}")
		raremattime = AddSliderOption("$Rare Materials Acquisition Time", _inventory.rare_materials_acquisition_time, "{2}")
	EndIf
EndFunction


Function drawSubMenu (Int start_index, Int default_index, String[] entries)	
	SetMenuDialogOptions(entries)
	SetMenuDialogStartIndex(start_index)
	SetMenuDialogDefaultIndex(default_index)
EndFunction


Function setMenuParameters (Int option)	
	If (option == minskill)
		SetSliderDialogStartValue(_actor.minimum_skill_level)
		SetSliderDialogDefaultValue(15.0)
		SetSliderDialogRange(1.0, _actor.max_skill_modifier * 100.0)
		SetSliderDialogInterval(1.0)
		
	ElseIf (option == skillcap)
		SetSliderDialogStartValue(_actor.max_skill_modifier * 100.0)
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(10, SKILL_CAP)
		SetSliderDialogInterval(1.0)
		
	ElseIf (option == craftcost)
		SetSliderDialogStartValue(_actor.craft_price_multiplier)
		SetSliderDialogDefaultValue(0.72)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.01)
		
	ElseIf (option == tempcost)
		SetSliderDialogStartValue(_actor.temper_price_multiplier)
		SetSliderDialogDefaultValue(0.16)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.01)
		
	ElseIf (option == enchcost)
		SetSliderDialogStartValue(_actor.enchant_price_multiplier)
		SetSliderDialogDefaultValue(0.40)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.01)
		
	ElseIf (option == chargecost)
		SetSliderDialogStartValue(_actor.recharge_price_multiplier)
		SetSliderDialogDefaultValue(0.92)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.01)
		
	ElseIf (option == matscost)
		SetSliderDialogStartValue(_actor.materials_price_multiplier)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.01)

	ElseIf (option == addfactionsmith || option == addfactionench)
		Actor npc =   _actor.getClosestActor()
		If (npc != _actor.player)
			menu_entries[0] =  "$Do NOT add"
			menu_entries[1] = npc.GetBaseObject().GetName()
		Else			
			menu_entries[0] = "$Nothing In Range"
			menu_entries[1] = ""
		EndIf		

	ElseIf (option == modsmithskill)
		SetSliderDialogStartValue(_actor.getClosestActor().GetActorValue("Smithing") )
		SetSliderDialogRange(_actor.minimum_skill_level, SKILL_CAP)
		SetSliderDialogInterval(1.0)
		
	ElseIf (option == modenchskill)
		SetSliderDialogStartValue(_actor.getClosestActor().GetActorValue("Enchanting") )
		SetSliderDialogRange(_actor.minimum_skill_level, SKILL_CAP)
		SetSliderDialogInterval(1.0)

	ElseIf (option == craftime)
		SetSliderDialogStartValue(_actor.time_crafting_takes)
		SetSliderDialogDefaultValue(0.2)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.01)

	ElseIf (option == tempertime)
		SetSliderDialogStartValue(_actor.time_tempering_takes)
		SetSliderDialogDefaultValue(0.12)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.01)	

	ElseIf (option == enchtime)
		SetSliderDialogStartValue(_actor.time_enchanting_takes)
		SetSliderDialogDefaultValue(0.08)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.01)
		
	ElseIf (option == chargetime)
		SetSliderDialogStartValue(_actor.time_recharging_takes)
		SetSliderDialogDefaultValue(0.05)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.01)
		
	ElseIf (option == matstime)
		SetSliderDialogStartValue(_inventory.common_materials_acquisition_time)
		SetSliderDialogDefaultValue(0.05)
		SetSliderDialogRange(0.0, 1.0)
		SetSliderDialogInterval(0.01)
		
	ElseIf (option == raremattime)
		SetSliderDialogStartValue(_inventory.rare_materials_acquisition_time)
		SetSliderDialogDefaultValue(0.33)
		SetSliderDialogRange(0.0, 1.0)
		SetSliderDialogInterval(0.01)
	EndIf	
EndFunction


Bool Function updateMenu (Int option, Float value = 0.0, Bool slider = False)
	If (slider)
		If (option == minskill || option == skillcap || option == modsmithskill || option == modenchskill)
			SetSliderOptionValue(option, value, "{0}")
		Else
			SetSliderOptionValue(option, value, "{2}")
		EndIf
	ElseIf (option == craft)
		SetToggleOptionValue(option, !_actor.crafting)
		Return !_actor.crafting
	ElseIf (option == temper)
		SetToggleOptionValue(option, !_actor.tempering)
		Return !_actor.tempering
	ElseIf (option == enchant)
		SetToggleOptionValue(option, !_actor.enchanting)
		Return !_actor.enchanting	
	ElseIf (option == skillsmithing)
		SetToggleOptionValue(option, !_actor.skill_affects_quality)
		Return !_actor.skill_affects_quality
	ElseIf (option == use_mats)
		SetToggleOptionValue(option, !_actor.vendors_have_basic_mats)
		Return !_actor.vendors_have_basic_mats		
	ElseIf (option == use_raremats)
		SetToggleOptionValue(option, !_actor.vendors_have_rare_mats)
		Return !_actor.vendors_have_rare_mats
	ElseIf (option == use_enchants)
		SetToggleOptionValue(option, !_actor.vendors_know_basic_enchantments)
		Return !_actor.vendors_know_basic_enchantments
	ElseIf (option == skillrebal)
		SetToggleOptionValue(option, !_actor.npc_skill_rebalance)
		Return !_actor.npc_skill_rebalance
	ElseIf (option == limitservice)
		SetToggleOptionValue(option, !_actor.restrict_npc_service)
		Return !_actor.restrict_npc_service
	ElseIf (option == deletemod)
		SetToggleOptionValue(option, True)
	ElseIf (option == modskill)
		Actor npc = _actor.getClosestActor()		
		If (npc != _actor.player)			
			SetTextOptionValue(option, npc.GetBaseObject().GetName() )
			SetOptionFlags(modsmithskill, OPTION_FLAG_NONE)
			SetOptionFlags(modenchskill, OPTION_FLAG_NONE)
		Else			
			SetTextOptionValue(option, "$Nothing In Range")
		EndIf		
	ElseIf (option == use_dualench)
		SetToggleOptionValue(option, !_actor.allow_dual_enchantment)
		Return !_actor.allow_dual_enchantment
	ElseIf (option == use_courier)
		SetToggleOptionValue(option, !_actor.allow_courier_notification)
		Return !_actor.allow_courier_notification
	ElseIf (option == craftingmssgs)
		SetToggleOptionValue(option, !_actor.crafting_messages)
		Return !_actor.crafting_messages
	EndIf	
	Return False
EndFunction


Function updateModValues (Int option, Float value)
	If (option == craft)
		_actor.crafting= value
	ElseIf (option == temper)
		_actor.tempering = value
	ElseIf (option == enchant)
		_actor.enchanting = value	
	ElseIf (option == skillsmithing)
		_actor.skill_affects_quality = value	
	ElseIf (option == use_mats)
		_actor.vendors_have_basic_mats = value
		_inventory.setAvailableMaterials()
	ElseIf (option == use_raremats)
		_actor.vendors_have_rare_mats = value
		_inventory.setAvailableMaterials()
	ElseIf (option == use_enchants)
		_actor.vendors_know_basic_enchantments = value
	ElseIf (option == skillrebal)
		_actor.npc_skill_rebalance = value
	ElseIf (option == limitservice)
		_actor.restrict_npc_service = value
	ElseIf (option == minskill)
		_actor.minimum_skill_level = value	
	ElseIf (option == skillcap)
		_actor.max_skill_modifier = value * 0.01
	ElseIf (option == craftcost)
		_actor.craft_price_multiplier = value
	ElseIf (option == tempcost)
		_actor.temper_price_multiplier = value
	ElseIf (option == enchcost)
		_actor.enchant_price_multiplier = value
	ElseIf (option == chargecost)
		_actor.recharge_price_multiplier = value
	ElseIf (option == matscost)
		_actor.materials_price_multiplier = value
	ElseIf (option == repairmod)		
		If (_mod.checkQuestStatus() )
			If (!_mod.update() )
				_mod.pauseMod()
			EndIf
		EndIf
	ElseIf (option == deletemod)	
		_mod.uninstall()
	ElseIf (option == resetperks)
		_actor.resetPerks()
		Debug.MessageBox(_mod.messages.PERKS_RESET)
	ElseIf (option == addfactionsmith && value)
		_actor.addNPCToFaction (True)
	ElseIf (option == addfactionench && value)
		_actor.addNPCToFaction (False)
	ElseIf (option == modsmithskill || option == modenchskill)
		String discipline
		
		If (option == modsmithskill)
			discipline = "Smithing"
		Else 
			discipline = "Enchanting"
		EndIf
		Actor npc = _actor.getClosestActor()	
		_actor.overridePredeterminedSkill(npc, value As Int, discipline)
		npc.SetActorValue(discipline, value)	
	ElseIf (option == craftime)
		_actor.time_crafting_takes = value	
	ElseIf (option == tempertime)
		_actor.time_tempering_takes = value	
	ElseIf (option == enchtime)
		_actor.time_enchanting_takes = value
	ElseIf (option == chargetime)
		_actor.time_recharging_takes = value
	ElseIf (option == matstime)
		_inventory.common_materials_acquisition_time = value
	ElseIf (option == raremattime)
		_inventory.rare_materials_acquisition_time = value
	ElseIf (option == use_dualench)
		_actor.allow_dual_enchantment = value
		_mod.activateDualEnchantment(value)
	ElseIf (option == use_courier)
		_actor.allow_courier_notification = value
	ElseIf (option == resetskill)
		_actor.InitializePredeterminedSkills(_mod.checkModPresence("Dragonborn.esm"), _mod.checkModPresence("Dawnguard.esm") )	
		Debug.MessageBox(_mod.messages.NPC_SKILL_RESTORED)
	ElseIf (option == craftingmssgs)
		_actor.crafting_messages = value
	ElseIf (option == recoverlost)
		ObjectReference[]	storage = _inventory.npc_storage_list
		HM_vendor_container	recover_container = _mod._main._vendor_container
		Int					idx = storage.Length

		While (idx)
			idx -= 1
			storage[idx].removeallitems(recover_container)
			_inventory.releaseNPCStorage(None, idx)
		EndWhile
		recover_container.goToState("recover")
		recover_container.registerForMenu("ContainerMenu")
		recover_container.activate(_actor.player)
		_mod.resetCourierSystem()
		_mod.resetPendingOrders()
		Debug.messageBox(_mod.messages.RECOVER_CONTAINER)
	ElseIf (option == perksdebug)
		_actor.player.SetActorValue("smithing", 100)
		_actor.player.SetActorValue("enchanting", 100)
		_actor.vendor = _actor.player ;is this needed anymore?
		_actor.service_type = _actor.CRAFT_SERVICE
		_actor.crafting_discipline = "smithing"
		_actor.AddPerks(skill = 100)
		_actor.crafting_discipline = "enchanting"
		_actor.service_type = _actor.ENCHANT_SERVICE
		_actor.AddPerks(skill = 100)
		_mod.resetForms()
		Debug.MessageBox(_mod.messages.TESTING_PERKS)
	EndIf
EndFunction


Function drawToolTips (Int option)
	If (option == craft)
		SetInfoText ("$ENABLE_CRAFTING")
	ElseIf (option == temper)
		SetInfoText ("$ENABLE_TEMPERING")
	ElseIf (option == enchant)
		SetInfoText ("$ENABLE_ENCHANTING")
	ElseIf (option == skillsmithing)
		SetInfoText ("$SKILL_BASED_SMITHING")
	ElseIf (option == use_mats)	
		SetInfoText ("$NPCS_HAVE_MATS")
	ElseIf (option == use_raremats)
		SetInfoText ("$NPCS_HAVE_RARE_MATS")
	ElseIf (option == use_enchants)
		SetInfoText ("$ENCHANTMENTS_KNOWN")
	ElseIf (option == skillrebal)
		SetInfoText ("$SKILL_REBALANCE")
	ElseIf (option == limitservice)
		SetInfoText ("$RESTRICT_SERVICE")
	ElseIf (option == minskill)
		SetInfoText ("$MIN_SKILL")
	ElseIf (option == skillcap)
		SetInfoText ("$SKILL_CAP")
	ElseIf (option == craftcost)
		SetInfoText ("$CRAFT_MULT")
	ElseIf (option == tempcost)
		SetInfoText ("$TEMP_MULT")
	ElseIf (option == enchcost)
		SetInfoText ("$ENCHANT_MULT")
	ElseIf (option == chargecost)
		SetInfoText ("$RECHARGE_MULT")
	ElseIf (option == matscost)
		SetInfoText ("$MATS_MULT")
	ElseIf (option == repairmod)
		SetInfoText ("$REPAIR_MOD")
	ElseIf (option == resetperks)
		SetInfoText ("$RESET_PERKS")
	ElseIf (option == addfactionsmith)
		SetInfoText ("$ADD_SMITH")
	ElseIf (option == addfactionench)
		SetInfoText ("$ADD_ENCHANT")
	ElseIf (option == modskill)
		SetInfoText ("$CHANGE_SKILL")
	ElseIf (option == modsmithskill)
		SetInfoText ("$CHANGE_SMITH_SKILL")
	ElseIf (option == modenchskill)
		SetInfoText ("$CHANGE_ENCHANT_SKILL")
	ElseIf (option == craftime)
		SetInfoText ("$CRAFT_TIME")
	ElseIf (option == tempertime)
		SetInfoText ("$TEMPER_TIME")
	ElseIf (option == enchtime)
		SetInfoText ("$ENCHANT_TIME")
	ElseIf (option == chargetime)
		SetInfoText ("$RECHARGE_TIME")
	ElseIf (option == matstime)
		SetInfoText ("$MATS_TIME")
	ElseIf (option == raremattime)
		SetInfoText ("$RARE_MATS_TIME")
	ElseIf (option == use_dualench)
		SetInfoText ("$EXTRA_EFFECT")
	ElseIf (option == use_courier)
		SetInfoText ("$ALLOW_COURIER")
	ElseIf (option == resetskill)
		SetInfoText ("$RESET_SKILLS")
	ElseIf (option == recoverlost)
		SetInfoText ("$RECOVER_ITEMS")
	ElseIf (option == craftingmssgs)
		SetInfoText ("$STATUS_MESSAGES")
	ElseIf (option == perksdebug)
		SetInfoText ("$TEST_PERKS")
	EndIf
EndFunction


Int Function GetVersion()
	Return 11
EndFunction

Int Property script_version Hidden
Int Function get ()
	return (13)
EndFunction
EndProperty
