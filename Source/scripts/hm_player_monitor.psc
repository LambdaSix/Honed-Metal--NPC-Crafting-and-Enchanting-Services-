ScriptName HM_player_monitor Extends ReferenceAlias

HM_Actor Property		_actor Auto
HM_Inventory Property	_inventory Auto

State TransformItems
	Event OnItemAdded (Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)		
		If (akSourceContainer == _inventory.sale_container && _inventory.packed_items_list.Find(akBaseItem as MiscObject) > -1)
			Form stored_item = _actor._mod._hmael.aStructureGetMapElement_formForm(_actor.vendor, _inventory.EQUIPMENT_RELATION, akBaseItem)
			
			_actor.player.RemoveItem(akBaseItem, aiItemCount, True)
			If (_actor.skill_affects_quality && _actor._mod._hmael.aStructureGetMember_int(_actor.vendor, _actor.TRANSACTION_TYPE) == _actor.CRAFT_SERVICE && \
			!(stored_item.HasKeyword(Keyword.GetKeyword("ArmorJewelry") ) ) && !(stored_item.HasKeyword(Keyword.GetKeyword("ArmorClothing") ) ) )
				_inventory.item_storage.RemoveItem(stored_item, aiItemCount, True, _inventory.transition_container)
				_inventory.adjustEquipmentQuality(stored_item, _inventory.transition_container)
				_inventory.transition_container.RemoveAllItems(_actor.player)
			Else
				_inventory.item_storage.RemoveItem(stored_item, aiItemCount, True, _actor.player)
			EndIF
		EndIf
	EndEvent
EndState

Int Property script_version Hidden
Int Function get ()
	return (13)
EndFunction
EndProperty