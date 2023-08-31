;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
ScriptName HM_dialogue_check_order_ready Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
	Actor akSpeaker = akSpeakerRef As Actor
	Quest thisQuest = GetOwningQuest()
	HM_inventory _inventory = (thisQuest As HM_inventory)
	HM_actor _actor = (thisQuest As HM_actor)
	hm_array_extension_library _hmael = (thisQuest As hm_array_extension_library)
	
	;BEGIN CODE
	_actor.vendor = akSpeaker
	_actor.vendor_disposition = akSpeaker.getRelationshipRank(_actor.player)
	_actor.player.addperk(_actor.vendor_discount)
	_inventory.equipment_ready = (Utility.GetCurrentGameTime() >= _hmael.aStructureGetMember_float(akSpeaker, _actor.TIME_STARTED_WORKING) + _hmael.aStructureGetMember_float(akSpeaker, _actor.NPC_SERVICE_COMPLETION_TIME) )
	;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
