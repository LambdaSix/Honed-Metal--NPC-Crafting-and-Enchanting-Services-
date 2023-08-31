ScriptName HM_main Extends Quest

HM_mod						Property _mod Auto
HM_Actor					Property _actor Auto
HM_Stations					Property _station Auto
HM_Inventory				Property _inventory Auto
HM_player_monitor			Property _player Auto
HM_vendor_container			Property _vendor_container Auto
HM_array_extension_library	Property _hmael Auto
Int Property				UNREGISTER = 0 AutoReadOnly Hidden
Int Property				CRAFT_SESSION = 1 AutoReadOnly Hidden
Int Property				ENCHANT_SESSION = 2 AutoReadOnly Hidden
Int Property				TEMPER_SESSION = 3 AutoReadOnly Hidden
Bool						service_queue
Bool						activation_success

Function StartService(Actor craftsman, Int service)
	If (_actor.player.IsInCombat() )
		Debug.MessageBox(_mod.messages.COMBAT_STATE)
		Return
	EndIf
	Self.goToState("ServiceVerify")
	Self.registerForMenu("Dialogue Menu")
	_actor.service_type = service
	_actor.vendor = craftsman
	If (service == _actor.CRAFT_SERVICE)
		setUpCraftService()
	ElseIf (service == _actor.RECHARGE_SERVICE)
		setUpRechargeService()
	ElseIf (service == _actor.RACK_SERVICE)	
		_actor.service_type = _actor.CRAFT_SERVICE ;for all internal purposes, we are crafting. Only difference is we call a different setUp function.
		setUpRackService()
	Else
		setUpEnchantNtemper()
	EndIf
EndFunction

State ServiceProcess
	Event OnMenuClose (String MenuName)
		If (MenuName == "ContainerMenu")
			_vendor_container.goToState("")
			_inventory.new_equipment = _vendor_container.getcontainerforms()
			Bool recharged = _inventory.new_equipment.length && \
				_inventory.restoreWeaponCharge(_inventory.new_equipment, _vendor_container, _inventory.item_storage)
			
			If (recharged)
				setUpTransaction()
			Else 
				Debug.MessageBox(_mod.messages.INVALID_RECHARGE_TARGET)
			EndIf
			_vendor_container.removeAllItems(_actor.player)
			cleanup(!recharged)
		ElseIf (MenuName == "Crafting Menu")
			_inventory.new_equipment = HMCraftingUtils.getItemsProduced()
			If (_inventory.new_equipment.length)
				setUpTransaction()
				cleanup()
			Else
				cleanup(True)
			EndIf
		Else
			Return
		EndIf
		Self.UnregisterForMenu(MenuName)
		Self.goToState("")
	EndEvent
EndState

State ServiceVerify
	Event OnMenuOpen(String menu)
		activation_success = (_actor.service_type != _actor.RECHARGE_SERVICE && menu == "Crafting Menu") || \
			(_actor.service_type == _actor.RECHARGE_SERVICE && menu == "ContainerMenu")
		If (activation_success && !service_queue)
			Self.goToState("ServiceProcess")
		EndIf
	EndEvent
	Event OnMenuClose(String menu)
		activation_success = (menu == "Dialogue Menu") 
		If (service_queue && menu == "Crafting Menu")
			service_queue = False
			activation_success = True
		EndIf
	EndEvent
EndState

State Deactivated
	Event OnUpdate ()
		Utility.Wait(1.0)
		Debug.MessageBox(_mod.messages.MOD_PAUSED)
		Self.UnregisterForUpdate() ;some users report message spam even though all registrations are single update only. This should stop that.
	EndEvent
	Function StartService(Actor craftsman, Int service)
		Self.OnUpdate()
	EndFunction
EndState

;-----------------------------------------------------------------------------------------------------------------------
Function setUpTransaction ()			
	Form[] NULL ;passing "None" to an array of forms generates a Papyrus warning.

	If (_actor.service_type != _actor.RECHARGE_SERVICE)
		_inventory.processCreatedEquipment()
		_inventory.getMaterialsUsed()
		_inventory.removeMaterialsFromNPC()
		_hmael.aStructureAddMember(_actor.vendor, _inventory.MATERIALS_COST, NULL, new_int_member = \
			_inventory.getMaterialsAverageCost() )
	EndIf
	_hmael.aStructureAddMember(_actor.vendor, _actor.TRANSACTION_TYPE, NULL, _actor.service_type)
	_hmael.aStructureAddMember(_actor.vendor, _actor.VENDOR_SKILL, NULL, (_actor.player.GetActorValue \
		(_actor.crafting_discipline) * _actor.max_skill_modifier) As Int)
	_hmael.aStructureAddMember(_actor.vendor, _actor.TIME_STARTED_WORKING, NULL, 0, Utility.GetCurrentGameTime() )
	_hmael.aStructureAddMember(_actor.vendor, _inventory.STORAGE_IDX, NULL, new_int_member = \
		_inventory.npc_storage_list.Find(_inventory.item_storage) )
	_actor.calculateNpcServiceTime()
	If (_actor.allow_courier_notification)
		_actor.sendCourierNotification()
	EndIf
	_actor.orders_list.AddForm(_actor.vendor.GetBaseObject() )
EndFunction

Function cleanup (Bool purge = False, Bool service_failure = False)
	If (_actor.service_type != _actor.RECHARGE_SERVICE)
		_inventory.addMaterials(False)
		restorePlayerState()
		If (_actor.crafting_messages)
			_mod.changeGameStrings(False)
		EndIf
		If (_actor.service_type == _actor.ENCHANT_SERVICE && _actor.vendors_know_basic_enchantments)
			_actor.learnEnchantments(False)
		EndIf
	EndIf
	If (purge)
		_hmael.deleteActorStructure(_actor.vendor)
		_inventory.releaseNPCStorage(_inventory.item_storage)
	EndIf
	If (service_failure)
		Self.UnregisterForMenu("Crafting Menu")
		Self.UnregisterForMenu("Container Menu")
	EndIf
	_mod.resetForms()
	HMCraftingUtils.registerForCraftingSession(UNREGISTER)
EndFunction

Function setUpServices (String menu)
	_mod.initforms()
	alterPlayerState()
	_hmael.createActorStructure(_actor.vendor)
	_inventory.acquireNPCStorage()
	_inventory.scanNPCMaterials()
	_inventory.addMaterials()
	If (_actor.crafting_messages)
		_mod.changeGameStrings()
	EndIf
	Self.RegisterForMenu(menu)
EndFunction

Function setUpRechargeService ()
	_inventory.acquireNPCStorage()
	_hmael.createActorStructure(_actor.vendor)
	_vendor_container.goToState("ReceiveWeapons")
	Self.RegisterForMenu ("ContainerMenu")
	activateObject(_vendor_container)
EndFunction

Function setUpCraftService ()
	setUpServices("Crafting Menu")
	HMCraftingUtils.registerForCraftingSession(CRAFT_SESSION)
	If (_actor.vendor == _actor.graymane)
		activateObject(_station.skyForge)
	Else
		activateObject(_station.forge)
	EndIf
EndFunction

Function setUpRackService ()
	setUpServices("Crafting Menu")
	HMCraftingUtils.registerForCraftingSession(CRAFT_SESSION)
	activateObject(_station.rack)
EndFunction

Function setUpEnchantNtemper ()
	setUpServices("Crafting Menu")
	If (_actor.service_type == _actor.ENCHANT_SERVICE)
		HMCraftingUtils.registerForCraftingSession(ENCHANT_SESSION)
		If (_actor.vendors_know_basic_enchantments)
			_actor.learnEnchantments()
		EndIf
		activateObject(_station.enchanter)
	Else
		HMCraftingUtils.registerForCraftingSession(TEMPER_SESSION)
		If (_actor.service_type == _actor.TEMPER_ARMOR_SERVICE)
			activateObject(_station.workbench)
		ElseIf (_actor.service_type == _actor.TEMPER_WEAPON_SERVICE)
			activateObject(_station.grindStone)
		ElseIf (_actor.service_type == _actor.TEMPER_SERVICE)
			service_queue = True
			if (!activateObject(_station.workbench) )
				Return
			endif
			While (service_queue)
				utility.Wait(1.0)
			EndWhile
			activateObject(_station.grindStone)
		EndIf
	EndIf
EndFunction

Function alterPlayerState ()
	game.DisablePlayerControls(abCamSwitch = True)
	_actor.immobilizeNPC(_actor.vendor)
	_actor.modifySkillLevel()
	_actor.removePerks(true)
	_actor.addPerks()
	_actor.goToState("SkillMonitor")
EndFunction

Function restorePlayerState ()
	_actor.goToState("")
	_actor.immobilizeNPC(_actor.vendor, False)
	_actor.modifySkillLevel(True)
	_actor.removePerks()
	_actor.addPerks(True)
	game.EnablePlayerControls()
EndFunction

Bool Function verifyActivation()
	Int waited

	While (!activation_success && waited < 32) ;at least 4.096 seconds (32 * 0.128), more likely a few ms more.
		utility.wait(0.128)
		waited += 1
	EndWhile
	If (!activation_success)
		Self.goToState("")
		_vendor_container.goToState("")
		cleanup(True, True)
		service_queue = false
		Debug.MessageBox(_mod.messages.ACTIVATION_ERROR)
		Return (False)
	EndIf
	activation_success = false
	Return (True)
EndFunction

Bool Function activateObject(ObjectReference station)
	If (verifyActivation() )
		station.Activate(_actor.player)
		Return (verifyActivation() )
	EndIf
	Return (False)
EndFunction

Int Property script_version Hidden
	Int Function get ()
		return (13)
	EndFunction
EndProperty