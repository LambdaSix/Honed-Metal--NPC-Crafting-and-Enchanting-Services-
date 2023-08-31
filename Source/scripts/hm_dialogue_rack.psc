;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname hm_dialogue_rack Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef As Actor
;BEGIN CODE	
	Quest thisQuest = GetOwningQuest()
	(thisQuest As HM_Main).startService(akSpeakerRef as Actor, (thisQuest As HM_Actor).RACK_SERVICE)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
