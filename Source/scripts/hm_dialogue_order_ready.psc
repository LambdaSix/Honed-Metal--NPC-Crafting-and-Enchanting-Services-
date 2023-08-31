;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
ScriptName HM_dialogue_order_ready Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef) 
	Actor akSpeaker = akSpeakerRef As Actor 
	Quest this_quest = GetOwningQuest()
	HM_inventory _inventory = (this_quest As HM_inventory)
	HM_actor _actor = (this_quest As HM_Actor)
	HM_array_extension_library _hmael = (this_quest As HM_array_extension_library)
	Form[] equipment; = _hmael.aStructureGetMember_formArray(akSpeaker, _inventory.STORED_EQUIPMENT)
	Int equipment_count; = equipment.Find(None)
	
	;BEGIN CODE
	_actor.vendor = akSpeaker
	_inventory.item_storage = _inventory.npc_storage_list[_hmael.aStructureGetMember_int(akSpeaker, _inventory.STORAGE_IDX)]
	equipment = _inventory.item_storage.getContainerForms()
	equipment_count = equipment.Length
	_inventory.prepareItemsForSale(equipment)
	(this_quest As HM_main)._vendor_container.RegisterForMenu("BarterMenu")
	If (equipment_count > 10)
		(this_quest As HM_main)._vendor_container.goToState("Overflow")		
	Else
		(this_quest As HM_main)._vendor_container.goToState("SellItems")
	EndIf
	(this_quest As HM_main)._player.goToState("TransformItems")
	Utility.Wait(0.75)
	_actor.sale_merchant.ShowBarterMenu()
	;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment