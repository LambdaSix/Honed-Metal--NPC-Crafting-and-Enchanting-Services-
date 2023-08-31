ScriptName hm_courier_note Extends ObjectReference  


HM_courier Property _courier Auto

Event OnRead()	
	;hm_actor _actor = (quest.GetQuest("HM_Quest") As hm_actor)	
	;Bool is_read = (Self.GetBaseObject() As book).isRead()	
	_courier.onMessageRead(Self)
EndEvent

Event OnContainerChanged(ObjectReference new_container, ObjectReference old_container)
	If ( old_container == _courier.courier.pCourierContainer)
		_courier.onMessageDelivered()
	EndIf
	
EndEvent