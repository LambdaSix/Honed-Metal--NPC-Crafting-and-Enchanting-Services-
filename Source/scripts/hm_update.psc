ScriptName HM_update Extends ReferenceAlias

HM_mod Property	_mod Auto
bool			waiting

Event OnInit()
	If (!_mod.initialized)
		Utility.Wait(1.0)
		Self.OnPlayerLoadGame()
	EndIf
EndEvent

Event OnPlayerLoadGame ()
	If (waiting)
		Return
	EndIf
	waiting = true
	While (!_mod._actor.player.Is3dLoaded() )
		utility.wait(3.0)
	EndWhile
	waiting = false
	Bool success

	If (_mod.version && _mod.version < 1.23)
		_mod.latest_version = 1.23
		_mod.latest_script_version = 13
		_mod.latest_file_version = 8
		success = _mod.update()
	ElseIf (!_mod.initialized)
		success = _mod.initialize()
	Else
		success = _mod.checkDLL() && _mod.checkModIntegrity()
	EndIf
	If (!success)
		_mod.pauseMod()
	EndIf
EndEvent


Int Property script_version Hidden
	Int Function Get ()
		return (13)
	EndFunction
EndProperty
