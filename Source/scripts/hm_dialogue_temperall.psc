;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname hm_dialogue_temperall Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
;BEGIN CODE
    Quest thisQuest = GetOwningQuest()
  	(thisQuest As HM_Main).startService(akSpeakerRef as Actor, (thisQuest As HM_Actor).TEMPER_SERVICE)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
