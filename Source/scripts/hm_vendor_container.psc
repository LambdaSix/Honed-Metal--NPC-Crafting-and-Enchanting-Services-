ScriptName HM_vendor_container Extends ObjectReference

HM_inventory	Property _inventory Auto
HM_mod			Property _mod Auto
HM_actor		Property _actor Auto
Bool			equipment_overflow

State SellItems
	Event OnItemAdded (Form item, Int count, ObjectReference akItemReference, ObjectReference source_container)		
		If (item As MiscObject == _inventory.gold)				
			Self.RemoveItem(item, count, True, _actor.vendor)			
		Else
			Self.RemoveItem(item, count, True, source_container)			
		EndIf	
	EndEvent
		
	Event OnMenuClose (String menuName)
		If (menuName == "BarterMenu")			
			Self.UnregisterForMenu("BarterMenu")
			Self.goToState("")
			_mod._main._player.gotoState("")
			_inventory.equipment_ready = False
			_actor.vendor_disposition = 0
			_actor.player.removePerk(_actor.vendor_discount)
			_mod._hmael.aStructureDeleteAllMapElements(_actor.vendor, _inventory.EQUIPMENT_RELATION)
			If (!Self.GetNumItems() && !equipment_overflow)				
				_inventory.releaseNPCStorage(None, _mod._hmael.aStructureGetMember_int(_actor.vendor, _inventory.STORAGE_IDX) )
				_actor.orders_list.RemoveAddedForm(_actor.vendor.GetBaseObject() )
				_mod._courier.discardNotificationLetter(_actor.vendor)
				_mod._hmael.deleteActorStructure(_actor.vendor)
			Else
				equipment_overflow = False
				Self.RemoveAllItems()
			EndIf
		EndIf
	EndEvent
EndState

State Overflow
	Event OnBeginState ()
		equipment_overflow = True
		Self.gotoState("SellItems")
		Debug.messageBox(_mod.messages.ITEMS_OVERFLOW)
	EndEvent
EndState

State ReceiveWeapons
	Event OnItemAdded (Form item, Int count, ObjectReference reference, ObjectReference source_container)
		If (!(item As Weapon) )
			Self.RemoveItem(item, count, True, source_container)
		EndIf
	EndEvent
EndState

State recover
	Event onMenuClose (String menuName)
		If (menuName == "ContainerMenu")
			Self.unregisterForMenu("ContainerMenu")
			Self.GoToState("")
			Self.removeAllItems()
		EndIf
	EndEvent
EndState

Int Property script_version Hidden
Int Function get ()
	return (13)
EndFunction
EndProperty
