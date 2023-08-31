ScriptName HM_courier Extends Quest

WICourierScript Property	courier Auto
ReferenceAlias Property		notification_note_alias Auto
ReferenceAlias Property		sender_alias Auto
hm_actor Property			_actor Auto

Int				delivered
Actor[]			outgoing
Actor[]			senders
Float[]			post_dates
Float[]			queue_time_added
Int				last_read
Book Property	notification_letter Auto


Event OnInit ()
	senders = New Actor[11]
	outgoing = New Actor[11]
	post_dates = New Float[11]
	queue_time_added = New Float[11]
EndEvent


Event OnUpdateGameTime ()	
	If (outgoing.Find(None) < 1)
		Return 
	EndIf
	dispatchCourier()
	updatQueues()
	processNextRequest()	
EndEvent


Function onMessageRead(ObjectReference letter)
	Actor sender	
	;Todo. Match sender with inventory reference.	
	;
	last_read += 1
	If (last_read >= senders.Find(None) || last_read >= delivered)
		sender = senders[0]
		last_read = 0		
	Else
		sender = senders[last_read]
	EndIf	
	sender_alias.ForceRefTo(sender)
EndFunction


Function onMessageDelivered()
	last_read = senders.Find(None)
	last_read -= ((!(!last_read)) As Int)
	Debug.notification(notification_letter.getName() )
	sender_alias.ForceRefTo(senders[last_read])
	delivered += 1
EndFunction


Function discardNotificationLetter(Actor sender)
	Int idx = senders.Find(sender)
	If (idx < 0)
		Return ;
	ElseIf ((idx + 1) > delivered)
		courier.pCourierContainer.removeItem(notification_letter)
		courier.decrementItemCount()
		(courier.pCourier As Actor).EvaluatePackage()
	Else
		_actor.player.RemoveItem(notification_letter)
		delivered -= ((delivered > 0) As Int)
	EndIf
	senders[idx] = None
	hm_array_extension_library.sortActorArray(senders)
	If (senders.Find(None) > 0)
		sender_alias.ForceRefTo(senders[0]) ;in case the current alias points to the npc removed.
		last_read = 0
	EndIf
EndFunction


Function addPostRequest (Actor sender, Float post_by_date)
	If (!Self.IsRunning() )
		Self.Start()	
	EndIf	
	If (addToQueue(sender, post_by_date) )
		processNextRequest()
	EndIf
EndFunction


Function processNextRequest ()
	Int next_in_queue = outgoing.Find(None) - 1
	If (next_in_queue < 0)		
		Return
	EndIf		
	
	Float next_dispatch_departure = (post_dates[next_in_queue] - ((Utility.GetCurrentGameTime() - queue_time_added[next_in_queue]) * 24.0) )		
	If (next_dispatch_departure < 0.0246) ;Minimum time safe to register for update, according to the wiki, plus some headroom. 
		next_dispatch_departure = 0.025
	EndIf
	
	Self.RegisterForSingleUpdateGameTime(next_dispatch_departure)
EndFunction


Bool Function addToQueue (Actor sender, Float post_date)	
	Int element_count = post_dates.Find(0)
	Int index = 1
	Int counter	
	Float time_added
	Float current_post_date
	Actor current_sender
	Bool queues_updated	
	
	outgoing[element_count] = sender
	post_dates[element_count] = post_date
	queue_time_added[element_count] = Utility.GetCurrentGameTime()	
	updateCurrentRequest()
	
	element_count += 1
	While (index < element_count)
		current_post_date = post_dates[index]
		current_sender = outgoing[index]
		time_added = queue_time_added[index]
		counter = index - 1
		While (counter > -1 && post_dates[counter] <= current_post_date)
			post_dates[counter + 1] = post_dates[counter]
			outgoing[counter + 1] = outgoing[counter]
			queue_time_added[counter + 1] = queue_time_added[counter]
			counter -= 1
		EndWhile
		post_dates[counter + 1] = current_post_date
		outgoing[counter + 1] = current_sender		
		queue_time_added[counter + 1] = time_added
		index += 1
	EndWhile
	
	index = outgoing.Find(None) - 1	
	If (outgoing[index] == sender)
		queues_updated = True;
	EndIf	
	
	Return queues_updated
EndFunction


Function dispatchCourier ()
	Int next_in_queue = outgoing.Find(None) - 1
	notification_note_alias.ForceRefTo(outgoing[next_in_queue].PlaceAtMe(notification_letter) )
	notification_note_alias.GetReference().Enable()
	courier.addAliasToContainer(notification_note_alias)
	Int letter_idx = senders.Find(None)
	senders[letter_idx] = outgoing[next_in_queue]
EndFunction


Function updatQueues ()
	Int last_index = outgoing.Find(None) - 1	
	outgoing[last_index] = None
	post_dates[last_index] = 0
EndFunction


Function updateCurrentRequest ()
	Int next_in_queue = outgoing.Find(None) - 1
	If (!next_in_queue)
		Return;
	EndIf	
	Float dispatch_time_remaining = (post_dates[next_in_queue - 1] - ((Utility.GetCurrentGameTime() - queue_time_added[next_in_queue - 1]) * 24.0) )	
	If (post_dates[next_in_queue] < post_dates[next_in_queue - 1] && post_dates[next_in_queue] > dispatch_time_remaining)		
		post_dates[next_in_queue - 1] = dispatch_time_remaining
	EndIf
EndFunction