ScriptName hm_array_extension_library Extends Quest

Actor[] structures
Int[] maps

Form[] structure_0_map_0_form_keys
Form[] structure_0_map_1_form_keys
Form[] structure_1_map_0_form_keys
Form[] structure_1_map_1_form_keys
Form[] structure_2_map_0_form_keys
Form[] structure_2_map_1_form_keys
Form[] structure_3_map_0_form_keys
Form[] structure_3_map_1_form_keys
Form[] structure_4_map_0_form_keys
Form[] structure_4_map_1_form_keys
Form[] structure_5_map_0_form_keys
Form[] structure_5_map_1_form_keys
Form[] structure_6_map_0_form_keys
Form[] structure_6_map_1_form_keys
Form[] structure_7_map_0_form_keys
Form[] structure_7_map_1_form_keys
Form[] structure_8_map_0_form_keys
Form[] structure_8_map_1_form_keys
Form[] structure_9_map_0_form_keys
Form[] structure_9_map_1_form_keys

Int[] structure_0_map_0_int_values
Int[] structure_0_map_1_int_values
Int[] structure_1_map_0_int_values
Int[] structure_1_map_1_int_values
Int[] structure_2_map_0_int_values
Int[] structure_2_map_1_int_values
Int[] structure_3_map_0_int_values
Int[] structure_3_map_1_int_values
Int[] structure_4_map_0_int_values
Int[] structure_4_map_1_int_values
Int[] structure_5_map_0_int_values
Int[] structure_5_map_1_int_values
Int[] structure_6_map_0_int_values
Int[] structure_6_map_1_int_values
Int[] structure_7_map_0_int_values
Int[] structure_7_map_1_int_values
Int[] structure_8_map_0_int_values
Int[] structure_8_map_1_int_values
Int[] structure_9_map_0_int_values
Int[] structure_9_map_1_int_values

;/Float[] structure_0_map_0_float_values
Float[] structure_0_map_1_float_values
Float[] structure_1_map_0_float_values
Float[] structure_1_map_1_float_values
Float[] structure_2_map_0_float_values
Float[] structure_2_map_1_float_values
Float[] structure_3_map_0_float_values
Float[] structure_3_map_1_float_values
Float[] structure_4_map_0_float_values
Float[] structure_4_map_1_float_values
Float[] structure_5_map_0_float_values
Float[] structure_5_map_1_float_values
Float[] structure_6_map_0_float_values
Float[] structure_6_map_1_float_values
Float[] structure_7_map_0_float_values
Float[] structure_7_map_1_float_values
Float[] structure_8_map_0_float_values
Float[] structure_8_map_1_float_values
Float[] structure_9_map_0_float_values
Float[] structure_9_map_1_float_values/;

Form[] structure_0_map_0_form_values
Form[] structure_0_map_1_form_values
Form[] structure_1_map_0_form_values
Form[] structure_1_map_1_form_values
Form[] structure_2_map_0_form_values
Form[] structure_2_map_1_form_values
Form[] structure_3_map_0_form_values
Form[] structure_3_map_1_form_values
Form[] structure_4_map_0_form_values
Form[] structure_4_map_1_form_values
Form[] structure_5_map_0_form_values
Form[] structure_5_map_1_form_values
Form[] structure_6_map_0_form_values
Form[] structure_6_map_1_form_values
Form[] structure_7_map_0_form_values
Form[] structure_7_map_1_form_values
Form[] structure_8_map_0_form_values
Form[] structure_8_map_1_form_values
Form[] structure_9_map_0_form_values
Form[] structure_9_map_1_form_values

Form[] structure_0_member_form_array_0
Form[] structure_0_member_form_array_1
Form[] structure_1_member_form_array_0
Form[] structure_1_member_form_array_1
Form[] structure_2_member_form_array_0
Form[] structure_2_member_form_array_1
Form[] structure_3_member_form_array_0
Form[] structure_3_member_form_array_1
Form[] structure_4_member_form_array_0
Form[] structure_4_member_form_array_1

Form[] structure_5_member_form_array_0
Form[] structure_5_member_form_array_1
Form[] structure_6_member_form_array_0
Form[] structure_6_member_form_array_1
Form[] structure_7_member_form_array_0
Form[] structure_7_member_form_array_1
Form[] structure_8_member_form_array_0
Form[] structure_8_member_form_array_1
Form[] structure_9_member_form_array_0
Form[] structure_9_member_form_array_1

Float[] structure_0_float_members
Float[] structure_1_float_members
Float[] structure_2_float_members
Float[] structure_3_float_members
Float[] structure_4_float_members
Float[] structure_5_float_members
Float[] structure_6_float_members
Float[] structure_7_float_members
Float[] structure_8_float_members
Float[] structure_9_float_members

Int[] structure_0_int_members
Int[] structure_1_int_members
Int[] structure_2_int_members
Int[] structure_3_int_members
Int[] structure_4_int_members
Int[] structure_5_int_members
Int[] structure_6_int_members
Int[] structure_7_int_members
Int[] structure_8_int_members
Int[] structure_9_int_members

Int[] structure_0_member_identifiers
Int[] structure_1_member_identifiers
Int[] structure_2_member_identifiers
Int[] structure_3_member_identifiers
Int[] structure_4_member_identifiers
Int[] structure_5_member_identifiers
Int[] structure_6_member_identifiers
Int[] structure_7_member_identifiers
Int[] structure_8_member_identifiers
Int[] structure_9_member_identifiers

Int[] structure_0_array_member_identifiers
Int[] structure_1_array_member_identifiers
Int[] structure_2_array_member_identifiers
Int[] structure_3_array_member_identifiers
Int[] structure_4_array_member_identifiers
Int[] structure_5_array_member_identifiers
Int[] structure_6_array_member_identifiers
Int[] structure_7_array_member_identifiers
Int[] structure_8_array_member_identifiers
Int[] structure_9_array_member_identifiers



Float[] null_float
Int[] null_int
Form[] null_form






;The messages in this script are debug messages. They are here to help me identify issues with the mod. You don't need to translate them.

;Extern:

Function createActorStructure (Actor structure_identifier)
	Int structure_index = structures.Find(structure_identifier)
	If (structure_index < 0)
		structure_index = structures.Find(None)
		If (structure_index < 0)
			HM_mod _mod = ((Self As Quest) As HM_mod)
			;consoleUtil.printMessage(_mod.messages.ARRAY_LIMIT)
			Return
		EndIf
		structures[structure_index] = structure_identifier
		;consoleUtil.printMessage("createActorStructure: adding structure: " + structure_identifier + " at index " + structure_index)
	EndIf	
EndFunction

Function deleteActorStructure (Actor structure_identifier)
	Int structure_index = structures.Find(structure_identifier)

	If (structure_index < 0)
		;consoleUtil.printMessage("HMAEL deleteActorStructure: structure id " + structure_identifier + " doesn't exist.")
		Return
	EndIf
	Int map_idx = maps.Length

	While (map_idx > 0)
		map_idx -= 1
		If (maps[map_idx])
			aStructureDeleteAllMapElements(structure_identifier, maps[map_idx])
		EndIf
	EndWhile
	structures[structure_index] = None		
	Int[]	structure_members = getArrayMemberIdentifiers(structure_index)
	Int		member_index = structure_members.Length;Find(0)

	While(member_index > 0)
		member_index -= 1
		structure_members[member_index] = 0
		clearArray(getMemberFormArray(structure_index, member_index), null_float, null_int)
	EndWhile
	clearArray(null_form, getMemberFloatArray(structure_index), getMemberIntArray(structure_index) )
	structure_members = getMemberIdentifiers(structure_index)
	member_index = structure_members.Length;Find(0)
	While(member_index > 0)
		member_index -= 1
		structure_members[member_index] = 0
	EndWhile
EndFunction

Function aStructureAddMember (Actor structure_identifier, Int member_identifier, Form[] new_array_member, Int new_int_member = 0, Float new_float_member = 0.0)	
	Int structure_index = structures.Find(structure_identifier)	
	If (structure_index < 0)
		;consoleUtil.printMessage("aStructureAddMember: ERROR: structure doesn't exist")
		Return	
	EndIf	
	Int[] member_identifiers
	If (new_array_member.Find(None) > 0)
		member_identifiers = getArrayMemberIdentifiers(structure_index)
	Else
		member_identifiers = getMemberIdentifiers(structure_index)
	EndIf	
	Int member_index = member_identifiers.Find(member_identifier)
	If (member_index > -1)
		;consoleUtil.printMessage("aStructureAddMember: ERROR: member identifier already in use " + member_index +  " " + member_identifier)
		Return
	EndIf
	member_index = member_identifiers.Find(0)
	If (member_index < 0)
		;consoleUtil.printMessage("aStructureAddMember: ERROR: adding member: " + member_identifiers + " but there is no more space in the members array.")
	EndIf
	member_identifiers[member_index] = member_identifier	
	If (new_array_member.Find(None) > 0)	
		addFormArrayMember(new_array_member, getMemberFormArray(structure_index, member_index) )
	ElseIf (new_float_member)
		getMemberFloatArray(structure_index)[member_index] = new_float_member
	ElseIf (new_int_member)
		getMemberIntArray(structure_index)[member_index] = new_int_member	
	EndIf
EndFunction

Function aStructureDeleteMember (Actor structure_identifier, Int member_identifier)
	Int structure_index = structures.Find(structure_identifier)
	If (structure_index < 0)
		;consoleUtil.printMessage("aStructureDeleteMember: WARNING: structure does not exist " + structure_identifier)
		Return
	EndIf
	Int[] members = getMemberIdentifiers(structure_index)	
	Int member_index = members.Find(member_identifier)
	If (member_index > -1)
		members[member_index] = 0
	Else
		;consoleUtil.printMessage("aStructureDeleteMember: WARNING: member does not exist " + member_identifier)
	EndIf
EndFunction

Float Function aStructureGetMember_float (Actor structure_identifier, Int member_identifier)
	Int structure_index = structures.Find(structure_identifier)
	Int[] members = getMemberIdentifiers(structure_index)
	Int member_index = members.Find(member_identifier)
	If (structure_index < 0)
		;consoleUtil.printMessage("aStructureGetMember_float: WARNING: structure doesn't exist " + structure_identifier)
		Return 0.0
	ElseIf (member_index < 0)
		;consoleUtil.printMessage("aStructureGetMember_float: WARNING: member doesn't exist " + member_identifier)
		Return 0.0
	EndIf	
	Return getMemberFloatArray(structure_index)[member_index]
EndFunction

Int Function aStructureGetMember_int (Actor structure_identifier, Int member_identifier)
	Int structure_index = structures.Find(structure_identifier)
	Int[] members = getMemberIdentifiers(structure_index)
	Int member_index = members.Find(member_identifier)
	If (structure_index < 0)
		;consoleUtil.printMessage("aStructureGetMember_int: WARNING: structure doesn't exist " + structure_identifier)
		Return 0
	ElseIf (member_index < 0)
		;consoleUtil.printMessage("aStructureGetMember_int: WARNING: member doesn't exist " + member_identifier)
		Return 0
	EndIf	
	Return getMemberIntArray(structure_index)[member_index]
EndFunction

Form[] Function aStructureGetMember_formArray (Actor structure_identifier, Int member_identifier)
	Int structure_index = structures.Find(structure_identifier)	
	If (structure_index < 0)
		;consoleUtil.printMessage("aStructureGetMember_formArray: WARNING: structure doesn't exist " + structure_identifier)
		Return null_form	
	EndIf
	Int[] member_identifiers = getArrayMemberIdentifiers(structure_index)
	Int member_index = member_identifiers.Find(member_identifier)
	If (member_index > -1)
		Return getMemberFormArray(structure_index, member_index)
	Else 
		;consoleUtil.printMessage("aStructureGetMember_formArray: WARNING: member identifier not found " + member_index)	
	EndIf		
EndFunction

Actor[] Function getActorStructures ()
	Return structures
EndFunction

Function structuresAddMap (Int map_identifier)
	Int map_index = maps.Find(0)
	maps[map_index] = map_identifier
EndFunction

Function structuresDeleteMap (Int map_identifier)
	Int map_index = maps.Find(map_identifier)
	If (map_index < 0)
		;consoleUtil.printMessage("structuresDeleteMap: WARNING: map doesn't exist " + map_identifier)
		Return
	EndIf
	maps[map_index] = 0
EndFunction


Function aStructureAddMapElement_formInt (Actor structure_identifier, Int map_identifier, Form _key, Int value)
	Int structure_index = structures.Find(structure_identifier)
	Int map_index = maps.Find(map_identifier)
	If (structure_index < 0)
		;consoleUtil.printMessage("aStructureAddMapElement_formInt: ERROR: structure not found! " + structure_identifier)
		Return
	ElseIf (map_index < 0)
		;consoleUtil.printMessage("aStructureAddMapElement_formInt: ERROR: map identifier not found! " + map_identifier)
		Return
	EndIf	
	addMapElement(getMapFormKeys(structure_index, map_index), getMapIntValues(structure_index, map_index), float_values = null_float, form_values = null_form, Key_ = _key, int_value = value)	
EndFunction

Function aStructureModMapElement_formInt (Actor structure_identifier, Int map_identifier, Form _key, Int value)
	Int structure_index = structures.Find(structure_identifier)
	Int map_index = maps.Find(map_identifier)	
	If (structure_index < 0)
		;consoleUtil.printMessage("aStructureModMapElement_formInt: ERROR: structure not found! " + structure_identifier)
		Return
	ElseIf (map_index < 0)
		;consoleUtil.printMessage("aStructureModMapElement_formInt: ERROR: map identifier not found! " + map_identifier)
		Return
	EndIf
	modMapElement(getMapFormKeys(structure_index, map_index), getMapIntValues(structure_index, map_index), _key, value, null_float)	
EndFunction

Int Function aStructureGetMapElement_formInt (Actor structure_identifier, Int map_identifier, Form _key)
	Int structure_index = structures.Find(structure_identifier)
	Int map_index = maps.Find(map_identifier)
	If (structure_index < 0)
		;consoleUtil.printMessage("aStructureGetMapElement_formInt: WARNING: structure not found! " + structure_identifier)
		Return 0
	ElseIf (map_index < 0)
		;consoleUtil.printMessage("aStructureGetMapElement_formInt: WARNING: map identifier not found! " + map_identifier)
		Return 0
	EndIf
	Return getMapElement_int(getMapFormKeys(structure_index, map_index), getMapIntValues(structure_index, map_index), _key)	
EndFunction

Function aStructureDeleteMapElement (Actor structure_identifier, Int map_identifier, Form _key)
	Int structure_index = structures.Find(structure_identifier)
	Int map_index = maps.Find(map_identifier)
	If (structure_index < 0)
		;consoleUtil.printMessage("astructuresDeleteMapElement: WARNING: structure not found! " + structure_identifier)
		Return
	ElseIf (map_index < 0)
		;consoleUtil.printMessage("astructuresDeleteMapElement: WARNING: map identifier not found! " + map_identifier)
		Return
	EndIf
	deleteMapElement(getMapFormKeys(structure_index, map_index), _key, null_int)
EndFunction

Function aStructureDeleteAllMapElements (Actor structure_identifier, Int map_identifier)
	Int structure_index = structures.Find(structure_identifier)
	Int map_index = maps.Find(map_identifier)
	If (structure_index < 0)
		;consoleUtil.printMessage("astructuresDeleteMapElement: WARNING: structure not found! " + structure_identifier)
		Return
	ElseIf (map_index < 0)
		;consoleUtil.printMessage("astructuresDeleteMapElement: WARNING: map identifier not found! " + map_identifier)
		Return
	EndIf	
	Form[] map_keys = getMapFormKeys(structure_index, map_index)
	Int index = map_keys.Length	
	While (index)
		index -= 1
		map_keys[index] = None
	EndWhile
EndFunction

Form[] Function aStructureGetMapKeys (Actor structure_identifier, Int map_identifier)
	Int structure_index = structures.Find(structure_identifier)
	Int map_index = maps.Find(map_identifier)
	If (structure_index < 0)
		;consoleUtil.printMessage("aStructureGetMapKeys: WARNING: structure not found! " + structure_identifier)
		Return null_form
	ElseIf (map_index < 0)
		;consoleUtil.printMessage("aStructureGetMapKeys: WARNING: map identifier not found! " + map_identifier)
		Return null_form
	EndIf	
	Return getMapFormKeys(structure_index, map_index)
EndFunction

Function aStructureAddMapElement_formForm (Actor structure_identifier, Int map_identifier, Form _key, Form value)
	Int structure_index = structures.Find(structure_identifier)
	Int map_index = maps.Find(map_identifier)
	If (structure_index < 0)
		;consoleUtil.printMessage("aStructureAddMapElement_formInt: ERROR: structure not found! " + structure_identifier)
		Return
	ElseIf (map_index < 0)
		;consoleUtil.printMessage("aStructureAddMapElement_formInt: ERROR: map identifier not found! " + map_identifier)
		Return
	EndIf	
	addMapElement(getMapFormKeys(structure_index, map_index), form_values = getMapFormValues(structure_index, map_index), float_values = null_float, int_values = null_int, Key_ = _key, form_value = value)
EndFunction

Form Function aStructureGetMapElement_formForm (Actor structure_identifier, Int map_identifier, Form _key)
	Int structure_index = structures.Find(structure_identifier)
	Int map_index = maps.Find(map_identifier)
	If (structure_index < 0)
		;consoleUtil.printMessage("aStructureGetMapElement_formForm: WARNING: structure not found! " + structure_identifier)
		Return None
	ElseIf (map_index < 0)
		;consoleUtil.printMessage("aStructureGetMapElement_formForm: WARNING: map identifier not found! " + map_identifier)
		Return None
	EndIf
	Return getMapElement_form(getMapFormKeys(structure_index, map_index), getMapFormValues(structure_index, map_index), _key)	
EndFunction






;Static:
;Map functions
;---------------------;
Function addMapElement (Form[] keys, Int[] int_values, Float[] float_values, Form[] form_values, Form key_, Form form_value = None, Int int_value = 0, Float float_value = 0.0)	
	Int key_index = keys.Find(key_)
	If (key_index < 0)
		key_index = keys.Find(None)
		keys[key_index] = key_
		If (int_value)
			int_values[key_index] = int_value			
		ElseIf (float_values)
			float_values[key_index] = float_value
		ElseIf (form_values.Length)
			form_values[key_index] = form_value
		EndIf		
	Else
		;consoleUtil.printMessage("aStructureAddMapElement: WARNING: key " +  key_.getName() + " is already in the map")
	EndIf
EndFunction

Function modMapElement (Form[] keys, Int[] int_values, Form _key, Int int_value, Float[] float_values, Float float_value = 0.0)	
	Int key_index = keys.Find(_key)
	If (key_index < 0)
		;consoleUtil.printMessage("modMapElement: WARNING: key " +  _key + " not found in the map")
	ElseIf (int_value)
		int_values[key_index] = int_value
		;consoleUtil.printMessage("modMapElement: INFO: added value Int: " + int_value)
	ElseIf (float_values)
		;consoleUtil.printMessage("modMapElement: INFO: added value Float: " + float_value)
		float_values[key_index] = float_value		
	EndIf			
EndFunction

Int Function getMapElement_int (Form[] keys, Int[] values, Form _key)
	Int key_index = keys.Find(_key)
	If (key_index < 0)
		;consoleUtil.printMessage("getMapElement_int: WARNING: key " +  _key + " not found in the map")
		Return 1
	Else		
		Return values[key_index]	
	EndIf	
EndFunction

Float Function getMapElement_float (Form[] keys, Float[] values, Form _key)	
	Int key_index = keys.Find(_key)
	If (key_index < 0)
		;consoleUtil.printMessage("getMapElement_float: WARNING: key " +  _key + " not found in the map")
	Else		
		Return values[key_index]	
	EndIf	
EndFunction

Form Function getMapElement_form (Form[] keys, Form[] values, Form _key)	
	Int key_index = keys.Find(_key)
	If (key_index < 0)
		;consoleUtil.printMessage("getMapElement_float: WARNING: key " +  _key + " not found in the map")
	Else		
		Return values[key_index]	
	EndIf	
EndFunction

Function deleteMapElement (Form[] keys, Form _key, Int[] values)
	Int key_index = keys.Find(_key)
	If (key_index < 0)
		;consoleUtil.printMessage("deleteMapElement: WARNING: key " +  _key + " not found in the map")
	Else		
		keys[key_index] = None
	EndIf
	If (values)
		values[key_index] = 0	
	EndIf
EndFunction

Form[] Function getMapFormKeys (Int structure_index, Int map_index)
	If (!structure_index)
		If (!map_index)			
			Return structure_0_map_0_form_keys			
		ElseIf (map_index == 1)			
			Return structure_0_map_1_form_keys			
		EndIf
	ElseIf (structure_index == 1)
		If (!map_index)
			Return structure_1_map_0_form_keys			
		ElseIf (map_index == 1)			
			Return structure_1_map_1_form_keys			
		EndIf		
	ElseIf (structure_index == 2)
		If (!map_index)
			Return structure_2_map_0_form_keys			
		ElseIf (map_index == 1)			
			Return structure_2_map_1_form_keys			
		EndIf
	ElseIf (structure_index == 3)
		If (!map_index)
			Return structure_3_map_0_form_keys			
		ElseIf (map_index == 1)			
			Return structure_3_map_1_form_keys			
		EndIf				
	ElseIf (structure_index == 4)
		If (!map_index)
			Return structure_4_map_0_form_keys			
		ElseIf (map_index == 1)			
			Return structure_4_map_1_form_keys			
		EndIf
	ElseIf (structure_index == 5)
		If (!map_index)
			Return structure_5_map_0_form_keys			
		ElseIf (map_index == 1)			
			Return structure_5_map_1_form_keys			
		EndIf
	ElseIf (structure_index == 6)
		If (!map_index)
			Return structure_6_map_0_form_keys			
		ElseIf (map_index == 1)			
			Return structure_6_map_1_form_keys			
		EndIf			
	ElseIf (structure_index == 7)
		If (!map_index)
			Return structure_7_map_0_form_keys			
		ElseIf (map_index == 1)			
			Return structure_7_map_1_form_keys			
		EndIf				
	ElseIf (structure_index == 8)
		If (!map_index)
			Return structure_8_map_0_form_keys			
		ElseIf (map_index == 1)			
			Return structure_8_map_1_form_keys			
		EndIf			
	ElseIf (structure_index == 9)
		If (!map_index)
			Return structure_9_map_0_form_keys			
		ElseIf (map_index == 1)			
			Return structure_9_map_1_form_keys			
		EndIf
	EndIf
EndFunction

Int[] Function getMapIntValues (Int structure_index, Int map_index)
	If (!structure_index)
		If (!map_index)			
			Return structure_0_map_0_int_values	
		ElseIf (map_index == 1)			
			Return structure_0_map_1_int_values			
		EndIf
	ElseIf (structure_index == 1)
		If (!map_index)
			Return structure_1_map_0_int_values			
		ElseIf (map_index == 1)			
			Return structure_1_map_1_int_values			
		EndIf		
	ElseIf (structure_index == 2)
		If (!map_index)
			Return structure_2_map_0_int_values			
		ElseIf (map_index == 1)			
			Return structure_2_map_1_int_values			
		EndIf
	ElseIf (structure_index == 3)
		If (!map_index)
			Return structure_3_map_0_int_values			
		ElseIf (map_index == 1)			
			Return structure_3_map_1_int_values			
		EndIf				
	ElseIf (structure_index == 4)
		If (!map_index)
			Return structure_4_map_0_int_values			
		ElseIf (map_index == 1)			
			Return structure_4_map_1_int_values			
		EndIf
	ElseIf (structure_index == 5)
		If (!map_index)
			Return structure_5_map_0_int_values			
		ElseIf (map_index == 1)			
			Return structure_5_map_1_int_values			
		EndIf
	ElseIf (structure_index == 6)
		If (!map_index)
			Return structure_6_map_0_int_values			
		ElseIf (map_index == 1)			
			Return structure_6_map_1_int_values			
		EndIf			
	ElseIf (structure_index == 7)
		If (!map_index)
			Return structure_7_map_0_int_values			
		ElseIf (map_index == 1)			
			Return structure_7_map_1_int_values			
		EndIf				
	ElseIf (structure_index == 8)
		If (!map_index)
			Return structure_8_map_0_int_values			
		ElseIf (map_index == 1)			
			Return structure_8_map_1_int_values			
		EndIf			
	ElseIf (structure_index == 9)
		If (!map_index)
			Return structure_9_map_0_int_values			
		ElseIf (map_index == 1)			
			Return structure_9_map_1_int_values			
		EndIf
	EndIf
EndFunction

Form[] Function getMapFormValues (Int structure_index, Int map_index)
	If (!structure_index)
		If (!map_index)			
			Return structure_0_map_0_form_values	
		ElseIf (map_index == 1)			
			Return structure_0_map_1_form_values			
		EndIf
	ElseIf (structure_index == 1)
		If (!map_index)
			Return structure_1_map_0_form_values			
		ElseIf (map_index == 1)			
			Return structure_1_map_1_form_values			
		EndIf		
	ElseIf (structure_index == 2)
		If (!map_index)
			Return structure_2_map_0_form_values			
		ElseIf (map_index == 1)			
			Return structure_2_map_1_form_values			
		EndIf
	ElseIf (structure_index == 3)
		If (!map_index)
			Return structure_3_map_0_form_values			
		ElseIf (map_index == 1)			
			Return structure_3_map_1_form_values			
		EndIf				
	ElseIf (structure_index == 4)
		If (!map_index)
			Return structure_4_map_0_form_values			
		ElseIf (map_index == 1)			
			Return structure_4_map_1_form_values			
		EndIf
	ElseIf (structure_index == 5)
		If (!map_index)
			Return structure_5_map_0_form_values			
		ElseIf (map_index == 1)			
			Return structure_5_map_1_form_values			
		EndIf
	ElseIf (structure_index == 6)
		If (!map_index)
			Return structure_6_map_0_form_values			
		ElseIf (map_index == 1)			
			Return structure_6_map_1_form_values			
		EndIf			
	ElseIf (structure_index == 7)
		If (!map_index)
			Return structure_7_map_0_form_values			
		ElseIf (map_index == 1)			
			Return structure_7_map_1_form_values			
		EndIf				
	ElseIf (structure_index == 8)
		If (!map_index)
			Return structure_8_map_0_form_values			
		ElseIf (map_index == 1)			
			Return structure_8_map_1_form_values			
		EndIf			
	ElseIf (structure_index == 9)
		If (!map_index)
			Return structure_9_map_0_form_values			
		ElseIf (map_index == 1)			
			Return structure_9_map_1_form_values			
		EndIf
	EndIf
EndFunction

;Member functions
;------------------------;
Function addFormArrayMember (Form[] form_array, Form[] member_form_array)	
	Int size = form_array.Find(None)	
	While (size)
		size -= 1
		member_form_array[size] = form_array[size]	;Assigning one array to the other directly doesn't work here. We have to do it element by element.
	EndWhile
EndFunction

Form[] Function getMemberFormArray (Int  structure_index, Int member_index)
	If(!structure_index)	
		If (!member_index)
			Return structure_0_member_form_array_0
		ElseIf (member_index == 1)
			Return structure_0_member_form_array_1
		EndIf				
	ElseIf(structure_index == 1)		
		If (!member_index)
			Return structure_1_member_form_array_0
		ElseIf (member_index == 1)
			Return structure_1_member_form_array_1
		EndIf	
	ElseIf(structure_index == 2)		
		If (!member_index)
			Return structure_2_member_form_array_0
		ElseIf (member_index == 1)
			Return structure_2_member_form_array_1
		EndIf		
	ElseIf(structure_index == 3)		
		If (!member_index)
			Return structure_3_member_form_array_0
		ElseIf (member_index == 1)
			Return structure_3_member_form_array_1
		EndIf
	ElseIf(structure_index == 4)		
		If (!member_index)
			Return structure_4_member_form_array_0
		ElseIf (member_index == 1)
			Return structure_4_member_form_array_1
		EndIf
	ElseIf(structure_index == 5)		
		If (!member_index)
			Return structure_5_member_form_array_0
		ElseIf (member_index == 1)
			Return structure_5_member_form_array_1
		EndIf
	ElseIf(structure_index == 6)		
		If (!member_index)
			Return structure_6_member_form_array_0
		ElseIf (member_index == 1)
			Return structure_6_member_form_array_1
		EndIf
	ElseIf(structure_index == 7)		
		If (!member_index)
			Return structure_7_member_form_array_0
		ElseIf (member_index == 1)
			Return structure_7_member_form_array_1
		EndIf
	ElseIf(structure_index == 8)		
		If (!member_index)
			Return structure_8_member_form_array_0
		ElseIf (member_index == 1)
			Return structure_8_member_form_array_1
		EndIf
	ElseIf(structure_index == 9)		
		If (!member_index)
			Return structure_9_member_form_array_0
		ElseIf (member_index == 1)
			Return structure_9_member_form_array_1
		EndIf
	EndIf
	Return null_form
EndFunction

Float[] Function getMemberFloatArray (Int structure_index)
	If (!structure_index)		
		Return structure_0_float_members		
	ElseIf (structure_index == 1)		
		Return structure_1_float_members		
	ElseIf (structure_index == 2)		
		Return structure_2_float_members		
	ElseIf (structure_index == 3)		
		Return structure_3_float_members		
	ElseIf (structure_index == 4)		
		Return structure_4_float_members		
	ElseIf (structure_index == 5)		
		Return structure_5_float_members		
	ElseIf (structure_index == 6)		
		Return structure_6_float_members		
	ElseIf (structure_index == 7)		
		Return structure_7_float_members		
	ElseIf (structure_index == 8)		
		Return structure_8_float_members		
	ElseIf (structure_index == 9)	
		Return structure_9_float_members		
	Else		
		Return null_float
	EndIf	
EndFunction

Int[] Function getMemberIntArray (Int structure_index)
	If (!structure_index)		
		Return structure_0_int_members		
	ElseIf (structure_index == 1)		
		Return structure_1_int_members
	ElseIf (structure_index == 2)		
		Return structure_2_int_members		
	ElseIf (structure_index == 3)		
		Return structure_3_int_members		
	ElseIf (structure_index == 4)		
		Return structure_4_int_members		
	ElseIf (structure_index == 5)		
		Return structure_5_int_members	
	ElseIf (structure_index == 6)		
		Return structure_6_int_members
	ElseIf (structure_index == 7)		
		Return structure_7_int_members
	ElseIf (structure_index == 8)		
		Return structure_8_int_members
	ElseIf (structure_index == 9)		
		Return structure_9_int_members	
	EndIf
	Return null_int
EndFunction

Int[] Function getMemberIdentifiers (Int structure_index)
	If (!structure_index)		
		Return structure_0_member_identifiers		
	ElseIf (structure_index == 1)		
		Return structure_1_member_identifiers		
	ElseIf (structure_index == 2)		
		Return structure_2_member_identifiers		
	ElseIf (structure_index == 3)		
		Return structure_3_member_identifiers		
	ElseIf (structure_index == 4)		
		Return structure_4_member_identifiers	
	ElseIf (structure_index == 5)		
		Return structure_5_member_identifiers		
	ElseIf (structure_index == 6)		
		Return structure_6_member_identifiers	
	ElseIf (structure_index == 7)	
		Return structure_7_member_identifiers		
	ElseIf (structure_index == 8)		
		Return structure_8_member_identifiers		
	ElseIf (structure_index == 9)		
		Return structure_9_member_identifiers	
	EndIf
	Return null_int
EndFunction

Int[] Function getArrayMemberIdentifiers (Int structure_index)
	If (!structure_index)		
		Return structure_0_array_member_identifiers		
	ElseIf (structure_index == 1)		
		Return structure_1_array_member_identifiers		
	ElseIf (structure_index == 2)		
		Return structure_2_array_member_identifiers		
	ElseIf (structure_index == 3)		
		Return structure_3_array_member_identifiers		
	ElseIf (structure_index == 4)		
		Return structure_4_array_member_identifiers	
	ElseIf (structure_index == 5)		
		Return structure_5_array_member_identifiers		
	ElseIf (structure_index == 6)		
		Return structure_6_array_member_identifiers	
	ElseIf (structure_index == 7)	
		Return structure_7_array_member_identifiers		
	ElseIf (structure_index == 8)		
		Return structure_8_array_member_identifiers		
	ElseIf (structure_index == 9)		
		Return structure_9_array_member_identifiers	
	EndIf
	Return null_int
EndFunction


;General
;----------------------------------------------
Function sortFormArray (Form[] array)
	Int filled_index
	Int empty_index
	Int size = array.Length
	
	While (empty_index < size)		
		empty_index = array.Find(None, empty_index)
		filled_index = empty_index + 1
		While (!array[filled_index])
			filled_index += 1
			If (filled_index == size)				
				Return
			EndIf
		EndWhile		
		array[empty_index] = array[filled_index]		
		array[filled_index] = None
	EndWhile	
EndFunction

Function sortActorArray (Actor[] array)	Global
	Int filled_index
	Int empty_index
	Int size = array.Length
	
	While (empty_index < size)		
		empty_index = array.Find(None, empty_index)
		filled_index = empty_index + 1
		While (!array[filled_index])
			filled_index += 1
			If (filled_index == size)				
				Return
			EndIf
		EndWhile		
		array[empty_index] = array[filled_index]		
		array[filled_index] = None
	EndWhile	
EndFunction

Function sortIntArray (Int[] array)
	Int filled_index
	Int empty_index
	Int size = array.Length
	
	While (empty_index < size)		
		empty_index = array.Find(0, empty_index)
		filled_index = empty_index + 1
		While (!array[filled_index])
			filled_index += 1
			If (filled_index == size)				
				Return
			EndIf
		EndWhile		
		array[empty_index] = array[filled_index]		
		array[filled_index] = 0
	EndWhile	
EndFunction

Perk[] Function mergePerkArrays (Perk[] src, Int srclen, Perk[] src2, Int srclen2)
	Perk[] dst
	Int i = srclen
	Int j = srclen2
			
	If (j && (j + i < 128) )
		dst = new Perk[128]
		While (j)
			j-= 1
			dst[j] = src2[j]
		EndWhile
		j = srclen2
		While (i)
			i -= 1
			dst[j] = src[i]
			j += 1
		EndWhile
	ElseIf (i)
		dst = src
	Else
		dst = src2
	EndIf
	Return (dst)
EndFunction

Function clearArray(Form[] formarr, Float[] floatarray, Int[] intarray)
	Int size

	If (formarr)
		size = formarr.Length;Find(None) ;'formarray' seems to be some sort of internal keyword
		While(size > 0)
			size -= 1
			formarr[size] = None
		EndWhile
	EndIf
	If (floatarray)
		size = floatarray.Length;Find(0.0)
		While(size > 0)
			size -= 1
			floatarray[size] = 0.0
		EndWhile
	EndIf
	If (intarray)
		size = intarray.Length;Find(0)
		While(size > 0)
			size -= 1
			intarray[size] = 0
		EndWhile
	EndIf
EndFunction

Function createArrays ()
	structures = New Actor[10]
	maps = New Int[2]
	
	structure_0_map_0_form_keys = New Form[16]
	structure_0_map_1_form_keys = New Form[16]
	structure_1_map_0_form_keys = New Form[16]
	structure_1_map_1_form_keys = New Form[16]
	structure_2_map_0_form_keys = New Form[16]
	structure_2_map_1_form_keys = New Form[16]
	structure_3_map_0_form_keys = New Form[16]
	structure_3_map_1_form_keys = New Form[16]
	structure_4_map_0_form_keys = New Form[16]
	structure_4_map_1_form_keys = New Form[16]
	structure_5_map_0_form_keys = New Form[16]
	structure_5_map_1_form_keys = New Form[16]
	structure_6_map_0_form_keys = New Form[16]
	structure_6_map_1_form_keys = New Form[16]
	structure_7_map_0_form_keys = New Form[16]
	structure_7_map_1_form_keys = New Form[16]
	structure_8_map_0_form_keys = New Form[16]
	structure_8_map_1_form_keys = New Form[16]
	structure_9_map_0_form_keys = New Form[16]
	structure_9_map_1_form_keys = New Form[16]
	
	structure_0_map_0_int_values = New Int[16]		;Values stored in these arrays directly correlate to the values in keys, simulating [key][value] pairs.
	structure_0_map_1_int_values = New Int[16]		;their maximum length will be the maximum size for the keys arrays.
	structure_1_map_0_int_values = New Int[16]
	structure_1_map_1_int_values = New Int[16]
	structure_2_map_0_int_values = New Int[16]
	structure_2_map_1_int_values = New Int[16]
	structure_3_map_0_int_values = New Int[16]
	structure_3_map_1_int_values = New Int[16]
	structure_4_map_0_int_values = New Int[16]
	structure_4_map_1_int_values = New Int[16]
	structure_5_map_0_int_values = New Int[16]
	structure_5_map_1_int_values = New Int[16]
	structure_6_map_0_int_values = New Int[16]
	structure_6_map_1_int_values = New Int[16]
	structure_7_map_0_int_values = New Int[16]
	structure_7_map_1_int_values = New Int[16]
	structure_8_map_0_int_values = New Int[16]
	structure_8_map_1_int_values = New Int[16]
	structure_9_map_0_int_values = New Int[16]
	structure_9_map_1_int_values = New Int[16]
	
	structure_0_map_0_form_values = New Form[16]		;Values stored in these arrays directly correlate to the values in keys, simulating [key][value] pairs.
	structure_0_map_1_form_values = New Form[16]		;their maximum length will be the maximum size for the keys arrays.
	structure_1_map_0_form_values = New Form[16]
	structure_1_map_1_form_values = New Form[16]
	structure_2_map_0_form_values = New Form[16]
	structure_2_map_1_form_values = New Form[16]
	structure_3_map_0_form_values = New Form[16]
	structure_3_map_1_form_values = New Form[16]
	structure_4_map_0_form_values = New Form[16]
	structure_4_map_1_form_values = New Form[16]
	structure_5_map_0_form_values = New Form[16]
	structure_5_map_1_form_values = New Form[16]
	structure_6_map_0_form_values = New Form[16]
	structure_6_map_1_form_values = New Form[16]
	structure_7_map_0_form_values = New Form[16]
	structure_7_map_1_form_values = New Form[16]
	structure_8_map_0_form_values = New Form[16]
	structure_8_map_1_form_values = New Form[16]
	structure_9_map_0_form_values = New Form[16]
	structure_9_map_1_form_values = New Form[16]
	
	structure_0_member_identifiers = New Int[6]
	structure_1_member_identifiers = New Int[6]
	structure_2_member_identifiers = New Int[6]
	structure_3_member_identifiers = New Int[6]
	structure_4_member_identifiers = New Int[6]
	structure_6_member_identifiers = New Int[6]
	structure_6_member_identifiers = New Int[6]
	structure_7_member_identifiers = New Int[6]
	structure_8_member_identifiers = New Int[6]
	structure_9_member_identifiers = New Int[6]
	
	structure_0_array_member_identifiers = New Int[2]
	structure_1_array_member_identifiers = New Int[2]
	structure_2_array_member_identifiers = New Int[2]
	structure_3_array_member_identifiers = New Int[2]
	structure_4_array_member_identifiers = New Int[2]
	structure_6_array_member_identifiers = New Int[2]
	structure_6_array_member_identifiers = New Int[2]
	structure_7_array_member_identifiers = New Int[2]
	structure_8_array_member_identifiers = New Int[2]
	structure_9_array_member_identifiers = New Int[2]
	
	structure_0_member_form_array_0 = New Form[16]
	structure_1_member_form_array_0 = New Form[16]
	structure_2_member_form_array_0 = New Form[16]
	structure_3_member_form_array_0 = New Form[16]
	structure_4_member_form_array_0 = New Form[16]
	structure_6_member_form_array_0 = New Form[16]
	structure_6_member_form_array_0 = New Form[16]
	structure_7_member_form_array_0 = New Form[16]
	structure_8_member_form_array_0 = New Form[16]
	structure_9_member_form_array_0 = New Form[16]	
	
	structure_0_float_members = New Float[6]	;Values are stored on these arrays according to the index of the identifiers in member_identifiers
	structure_1_float_members = New Float[6]	;because of this, their maximum length will always be the maximum size of member_identifiers.
	structure_2_float_members = New Float[6]
	structure_3_float_members = New Float[6]
	structure_4_float_members = New Float[6]
	structure_6_float_members = New Float[6]
	structure_6_float_members = New Float[6]
	structure_7_float_members = New Float[6]
	structure_8_float_members = New Float[6]
	structure_9_float_members = New Float[6]
	
	structure_0_int_members = New Int[6]
	structure_1_int_members = New Int[6]
	structure_2_int_members = New Int[6]
	structure_3_int_members = New Int[6]
	structure_4_int_members = New Int[6]
	structure_6_int_members = New Int[6]
	structure_6_int_members = New Int[6]
	structure_7_int_members = New Int[6]
	structure_8_int_members = New Int[6]
	structure_9_int_members = New Int[6]
EndFunction

Int Property script_version Hidden
Int Function get ()
	return (13)
EndFunction
EndProperty
