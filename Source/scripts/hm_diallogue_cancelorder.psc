;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname hm_diallogue_cancelorder Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
    Quest			this_quest = GetOwningQuest()
	HM_Actor		_actor = (this_quest As HM_Actor)
	HM_inventory	_inventory = (this_quest As HM_inventory)
	Actor			akSpeaker = akSpeakerRef As Actor
	Int				service = (this_quest As HM_array_extension_library).aStructureGetMember_int(akSpeaker, _actor.TRANSACTION_TYPE)
	
    ;BEGIN CODE
	If (service != _actor.RECHARGE_SERVICE)
		ObjectReference	storage = _inventory.npc_storage_list[(this_quest As HM_array_extension_library).aStructureGetMember_int(akSpeaker, _inventory.STORAGE_IDX)]
		Form[]			equipment = _inventory.item_storage.getContainerForms()
		Int[]			cost = New Int[128]
		Int				idx = equipment.Length
		Int				ordercost
		Int				itemsvalue
			
		If (service == _actor.CRAFT_SERVICE)
			_inventory.calcCraftingCost(cost, equipment, equipment.Length)
		Else
			_inventory.calcEnchTemperingCost(cost, equipment, equipment.Length, service)
		EndIf
		While (idx)
			idx -= 1
			ordercost += cost[idx]
			itemsvalue += equipment[idx].GetGoldValue()
		EndWhile
		If (service == _actor.CRAFT_SERVICE)
			fee.value = (ordercost - itemsvalue) * 0.75
		Else
			fee.value = (8.0 / Math.sqrt(ordercost) ) * (ordercost - itemsvalue)
		EndIf
		If (fee.value < 10)
			fee.value = 10
		EndIf
	EndIf
    this_quest.UpdateCurrentInstanceGlobal(fee)
    ;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property fee  Auto  
