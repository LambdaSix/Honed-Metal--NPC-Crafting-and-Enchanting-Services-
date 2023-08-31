ScriptName HM_mod Extends Quest

HM_inventory Property _inventory Auto
HM_Actor Property _actor Auto
HM_main Property _main Auto
HM_MCM Property _mcm Auto
HM_Stations Property _station Auto
HM_courier Property _courier Auto
HM_array_extension_library Property _hmael Auto
HM_update Property _update Auto
HM_Messages Property messages Auto
ReferenceAlias Property _mcm_alias Auto
ReferenceAlias Property _craft_alias Auto
ReferenceAlias Property _npc_stay_idle_alias Auto
Bool property initialized Auto Hidden
Float Property version Auto Hidden
Key Property file_version Auto
Float Property latest_version = 1.23 Auto Hidden
Int Property latest_file_version = 8 Auto Hidden
Int Property latest_script_version = 13 Auto Hidden

Form[]				null_form
Perk[]				null_perk
Int[]				null_int
ObjectReference[]	null_reference


Bool Function checkDLL ()
	Int plugin = SKSE.GetPluginVersion("HonedMetal")

	If (plugin >= 4)
		Return (True)
	ElseIf (plugin <= 0)
		Debug.MessageBox(messages.PLUGIN_REGISTRATION_ERROR)
	Else
		Debug.MessageBox(messages.PLUGIN_OUTDATED_ERROR + plugin)
	EndIf
	Return (False)
EndFUnction


Bool Function update ()
	If (version < 1.20)
		Debug.MessageBox(messages.UNSUPPORTED_UPGRADE)
	ElseIf (initialize() )
		Debug.MessageBox(messages.UPDATE_SUCCESS + " " + (version As Int) + "." + (version * 100.0 - 100.0) As Int)
		Return (True)
	EndIf
	Return (False)
EndFunction


Bool Function checkScriptsVersion ()
	Int version_sum = script_version + _main.script_version + _inventory.script_version +  _actor.script_version + _mcm.script_version + _hmael.script_version + \
		_update.script_version	+ _main._player.script_version + _main._vendor_container.script_version + messages.script_version + HMCraftingUtils.getScriptVersion()

	If (version_sum == (latest_script_version * 11) )
		Return (True)
	EndIf
	Debug.MessageBox(messages.SCRIPT_MISMATCH)	
	Return (False)
EndFunction


Bool Function checkFileVersion ()
	If (file_version && file_version.GetGoldValue() == latest_file_version)
		Return (True)
	EndIf
	Debug.MessageBox(messages.FILE_MISMATCH)
	Return (False)
EndFunction


Function initforms()
	_inventory.npc_materials = New Form[128]
	_inventory.npc_materials_count = New Int[128]
	_inventory.materials_used = New Form[128]
	_inventory.materials_used_count = New Int[128]
	_actor.known_enchantments = New Form[128]
	_inventory.npc_merchant_container = New ObjectReference[16]
EndFunction


Function resetForms ()
	_inventory.new_equipment = null_form
	_inventory.npc_materials = null_form
	_inventory.npc_materials_count = null_int
	_inventory.materials_used = null_form
	_inventory.materials_used_count = null_int
	_inventory.npc_merchant_container = null_reference
	_actor.known_enchantments = null_form
EndFunction


Bool Function initialize ()
	If (checkDLL() && checkModIntegrity() )
		resetForms()
		resetCourierSystem()
		cacheGameStrings()
		_hmael.createArrays()
		createStructureElements()
		_inventory.InitNPCStorage()
		clearStorageContainers()
		_inventory.setAvailableMaterials()
		_actor.orders_list.revert()
		_actor.InitializePredeterminedSkills(checkModPresence("Dragonborn.esm"), checkModPresence("Dawnguard.esm") )	
		applyCompatibilityOptions()
		updateCoreDefaults()
		version = latest_version
		initialized = True
		_main.goToState ("")
		Debug.Notification(messages.INITIALIZED)
		Return (True)
	EndIf
	Return (False)
EndFunction


Function uninstall ()
	resetCourierSystem()
	Self.Stop()
	_mcm.Stop()
	_mcm_alias.Clear()
	_craft_alias.Clear()
	_npc_stay_idle_alias.Clear()
	_station.enchanter.Delete()
	_station.workbench.Delete()
	_station.grindStone.Delete()
	_station.SkyForge.Delete()
	_station.forge.Delete()	
	_inventory.sale_container.Delete()
	_inventory.item_storage.Delete()
	_inventory.returns_container.Delete()
	_inventory.transition_container.Delete()
	_actor.sale_merchant.Delete()
	_actor.mannequin.Delete()
	Debug.MessageBox(messages.UNINSTALL)
EndFunction


Function pauseMod ()
	_main.GoToState("Deactivated")
	Self.RegisterForSingleUpdate(0)
EndFunction


Bool Function checkModIntegrity ()
	HM_inventory	inv = _inventory
	HM_actor		act = _actor
	HM_stations		stn = _inventory._station

	If (checkFileVersion() && checkScriptsVersion() )
		If (act.player && act.sale_merchant && act.mannequin && act.enchantments && act.stopSkillGain && _craft_alias && _update)
			If (_main._station && _main._inventory && _main._actor && _main._player && _main._vendor_container && _main._hmael)		
				If (inv._actor && inv._station && inv.sale_container && inv.transition_container && inv.returns_container && inv.materials)
					If (checkPackedItems() && stn.forge && stn.skyforge && stn.grindStone && stn.workbench && stn.enchanter && stn.rack)
						Return True
					EndIf
				EndIf
			EndIf
		EndIf
		Debug.MessageBox(messages.PROPERTY_ERROR)
	EndIf
	Return False
EndFunction


Bool Function checkPackedItems ()
	MiscObject[]	packed = _inventory.packed_items_list
	int				idx = packed.length
	int				verified

	While (idx)
		idx -= 1
		verified += ((packed[idx] as Bool) as Int)
	EndWhile
	Return (verified == 10)
EndFunction


Bool Function checkQuestStatus ()
	If ((Self As Quest).IsRunning() )
		Return True
	EndIf
	Debug.MessageBox(messages.STOPPED)
	Return False
EndFunction


Function resetCourierSystem ()
	Actor[] craftsmen = _hmael.getActorStructures()
	Int idx

	hm_array_extension_library.sortActorArray(craftsmen)
	idx = craftsmen.Find(None)
	While (idx > 0)
		idx -= 1
		_courier.discardNotificationLetter(craftsmen[idx])
	EndWhile
	_courier.Stop()
	_actor.player.RemoveItem(Game.GetFormFromFile(0x0001d211, "HonedMetal.esp"), 10, True)	
EndFunction


Function resetPendingOrders ()
	Actor[] craftsmen = _hmael.getActorStructures()
	
	hm_array_extension_library.sortActorArray(craftsmen)
	_actor.orders_list.revert()
	Int idx = craftsmen.Find(None)
	While (idx > 0)
		idx -= 1
		_hmael.deleteActorStructure(craftsmen[idx])
		craftsmen[idx] = None
	EndWhile
EndFunction


Function clearStorageContainers()
	ObjectReference[]	storage = _inventory.npc_storage_list
	Int					idx = storage.Length

	While (idx)
		idx -= 1
		storage[idx].removeallitems()
		_inventory.releaseNPCStorage(None, idx)
	EndWhile
EndFunction


Function createStructureElements ()
	;Enumerators	
	_inventory.EQUIPMENT_RELATION = 1 ;map identifier 
	_inventory.MATERIALS_COST = 2 ;member identifier
	_inventory.WEAPONS_AVERAGE_CHARGE = 3 ;member identifier	
	_inventory.STORAGE_IDX = 4 ;member identifier	
	_actor.TIME_STARTED_WORKING = 5 ;member identifier
	_actor.NPC_SERVICE_COMPLETION_TIME = 6 ;member identifier
	_actor.VENDOR_SKILL = 7 ;member identifier
	_actor.TRANSACTION_TYPE = 8 ;member identifier
	
	_hmael.structuresAddMap(_inventory.EQUIPMENT_RELATION)	
EndFunction


Bool Function checkModPresence (String mod_name)
	If (Game.GetModByName(mod_name) != 255)
		Return True
	EndIf
	Return False
EndFunction


Function applyCompatibilityOptions ()
	_actor.blacklisted_general = HMCraftingUtils.getPerksFromINI(0)
	_actor.blacklisted_enchants = HMCraftingUtils.getPerksFromINI(1)
	_actor.blacklisted = _actor.blacklisted_general
	activateDualEnchantment(!(checkModPresence("Requiem.esp") || checkModPresence("PerkusMaximus_Master.esp") ) )
	If (checkModPresence("Dragonborn.esm") )
		Form netch_leather = Game.GetFormFromFile(0x0501CD7C, "Dragonborn.esm")
		Form chitin_plate = Game.GetFormFromFile(0x0502B04E, "Dragonborn.esm")
		_inventory.materials.AddForm(netch_leather)
		_inventory.materials.AddForm(chitin_plate)
		Actor glover = (Game.GetFormFromFile(0x0001828E, "Dragonborn.esm")As Actor)
		Actor baldor = (Game.GetFormFromFile(0x00018FB5, "Dragonborn.esm")As Actor)
		If (glover || baldor)
			glover.AddToFaction(_actor.smithing_faction)
			baldor.AddToFaction(_actor.smithing_faction)
		EndIf
	EndIf
	If (checkModPresence("Dawnguard.esm") )
		Actor gunmar = (Game.GetFormFromFile(0x0000336C, "Dawnguard.esm")As Actor)
		Actor hestla = (Game.GetFormFromFile(0x00003365, "Dawnguard.esm")As Actor)
		If (gunmar || hestla)
			gunmar.AddToFaction(_actor.smithing_faction)
			hestla.AddToFaction(_actor.smithing_faction)
		EndIf
	EndIF
	_actor.crafting_messages = !checkModPresence("YOT - Your Own Thoughts.esp")
EndFunction


Function activateDualEnchantment (Bool use_dual_enchantment)	
	If (checkModPresence("Requiem.esp") )	
		Spell law_of_first = Game.GetFormFromFile(0x5568f5c3,"Requiem.esp") As Spell		
		If (use_dual_enchantment)
			_actor.player.addSpell(law_of_first, False)
		Else
			_actor.player.removeSpell(law_of_first)
		EndIf
	ElseIf (checkModPresence("PerkusMaximus_Master.esp") )			
		Spell xMAENCSplitEnchantAbility =  Game.GetFormFromFile(0x00419CB3,"PerkusMaximus_Master.esp") As Spell		
		If (use_dual_enchantment)
			_actor.player.AddSpell(xMAENCSplitEnchantAbility, False)
		Else			
			_actor.player.RemoveSpell(xMAENCSplitEnchantAbility)
		EndIf
	EndIf
	Perk[] dualenchs = _actor.blacklisted_enchants

	If (use_dual_enchantment)
		Int idx = dualenchs.length
		Int pos

		While (idx)
			idx -= 1
			pos = _actor.blacklisted.find(dualenchs[idx])
			If (pos > -1)
				_actor.blacklisted[pos] = none
				pos += 1
			EndIf
		EndWhile
	ElseIf (dualenchs.length)
		_actor.blacklisted = _hmael.mergePerkArrays(dualenchs, dualenchs.length, \
			_actor.blacklisted_general, _actor.blacklisted_general.length)
	EndIf
	_actor.allow_dual_enchantment = use_dual_enchantment
EndFunction

Function updateCoreDefaults ()
	If (version < 1.22)
		_actor.max_skill_modifier = 1.0
		_actor.craft_price_multiplier = 0.72
		_actor.temper_price_multiplier = 0.16
		_actor.enchant_price_multiplier = 0.4
		_actor.recharge_price_multiplier = 0.92
	EndIf
EndFunction

String default_ench_learned
String default_ench_known
String default_lack_perk_smith
String default_lack_perk_enchant
String default_lack_skill_temper
String default_lack_skill_craft
String default_lack_material
String default_encumbrance
String default_item_added 

;Weird error log appears at times stating 'GetGameSettingString' failed due to 'sAddItemtoInventory' not being a known game setting. 
;I haven't pinpointed the reason why this happens.
;Possible solution: cache the default strings upon mod initialization and simply apply them here.
;Downside: this will restore outdated strings if mods added later change them, or if they are changed dynamically.

Function cacheGameStrings()
	default_ench_learned = Game.GetGameSettingString("sEnchantmentsLearned")
	default_ench_known = Game.GetGameSettingString("sEnchantmentKnown")
	default_lack_perk_smith = Game.GetGameSettingString("sLackRequiredPerksToImprove")
	default_lack_perk_enchant = Game.GetGameSettingString("sLackRequiredPerkToImproveMagical")
	default_lack_skill_temper = Game.GetGameSettingString("sLackRequiredSkillToImprove")
	default_lack_skill_craft = Game.GetGameSettingString("sLackRequiredToCreate")
	default_lack_material = Game.GetGameSettingString("sLackRequiredToImprove")		
	default_item_added = Game.GetGameSettingString("sAddItemtoInventory")
EndFunction

Function changeGameStrings (Bool change_values = True)
	If (change_values)
		Game.SetGameSettingString("sEnchantmentsLearned", messages.ENCHANTMENT_LEARNED)
		Game.SetGameSettingString("sEnchantmentKnown", messages.ENCHANTMENT_KNOWN)
		Game.SetGameSettingString("sLackRequiredPerksToImprove", messages.INSUFICIENT_SKILL)
		Game.SetGameSettingString("sLackRequiredPerkToImproveMagical", messages.INSUFICIENT_SKILL)
		Game.SetGameSettingString("sLackRequiredSkillToImprove",messages.INSUFICIENT_SKILL)
		Game.SetGameSettingString("sLackRequiredToCreate", messages.INSUFICIENT_MATERIALS) 
		Game.SetGameSettingString("sLackRequiredToImprove", messages.INSUFICIENT_MATERIALS)
		Game.SetGameSettingString("sOverEncumbered", "")
		Game.SetGameSettingString("sAddItemtoInventory",messages.ORDERED)
	Else
		Game.SetGameSettingString("sEnchantmentsLearned", default_ench_learned)
		Game.SetGameSettingString("sEnchantmentKnown", default_ench_known)
		Game.SetGameSettingString("sLackRequiredPerksToImprove", default_lack_perk_smith)
		Game.SetGameSettingString("sLackRequiredPerkToImproveMagical", default_lack_perk_enchant)
		Game.SetGameSettingString("sLackRequiredSkillToImprove", default_lack_skill_temper)
		Game.SetGameSettingString("sLackRequiredToCreate", default_lack_skill_craft)
		Game.SetGameSettingString("sLackRequiredToImprove", default_lack_material)
		Game.SetGameSettingString("sOverEncumbered", default_encumbrance)
		Game.SetGameSettingString("sAddItemtoInventory", default_item_added)
	EndIf	
EndFunction

Int Property script_version Hidden
Int Function get ()
	return (13)
EndFunction
EndProperty
