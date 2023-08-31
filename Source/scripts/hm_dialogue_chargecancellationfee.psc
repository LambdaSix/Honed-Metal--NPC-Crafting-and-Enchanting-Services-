;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname hm_dialogue_chargecancellationfee Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
    Quest			this_quest = GetOwningQuest()
    HM_Mod			_mod = (this_quest As HM_Mod)
	HM_inventory	_inventory = (this_quest As HM_Inventory)
    Actor			akSpeaker = akSpeakerRef As Actor
	Int				storageidx = _mod._hmael.aStructureGetMember_int(akSpeaker, _mod._inventory.STORAGE_IDX)

    ;BEGIN CODE
    game.getPlayer().removeitem(gold, Math.Ceiling(fee.value) )
    (this_quest As HM_Actor).orders_list.RemoveAddedForm(akSpeaker.GetBaseObject() )
	_inventory.releaseNPCStorage(None, storageidx)
	_inventory.npc_storage_list[storageidx].removeAllItems()
    _mod._courier.discardNotificationLetter(akSpeaker)
    _mod._hmael.deleteActorStructure(akSpeaker)
	fee.value = 0
    ;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

MiscObject Property     gold Auto
GlobalVariable Property fee Auto