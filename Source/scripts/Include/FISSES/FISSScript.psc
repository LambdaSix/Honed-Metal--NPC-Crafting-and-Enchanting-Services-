;/ Decompiled by Champollion V1.0.0
Source   : FISSScript.psc
Modified : 2014-02-04 03:19:06
Compiled : 2014-02-04 03:21:56
User     : GrafConti
Computer : GRAFCONTI-PC
/;
scriptName FISSScript extends FISSInterface

;-- Properties --------------------------------------

;-- Variables ---------------------------------------
String Property LoadCObject = "NULL" Auto
String Property SaveCObject = "NULL" Auto

;-- Native Functions ---------------------------------------
String Function CFissBeginLoad(String filename) global native
String Function CFissEndLoad(String cobj) global native
Bool Function CFissLoadBool(String cobj, String name) global native
String Function CFissLoadString(String cobj, String name) global native
Float Function CFissLoadFloat(String cobj, String name) global native
Int Function CFissLoadInt(String cobj, String name) global native

String Function CFissBeginSave(String filename, String modname) global native
String Function CFissEndSave(String cobj) global native
Function CFissSaveBool(String cobj, String name, Bool value) global native
Function CFissSaveString(String cobj, String name, String value) global native
Function CFissSaveFloat(String cobj, String name, Float value) global native
Function CFissSaveInt(String cobj, String name, Int value) global native

String Function CFissSaveTextToTxtFile(String filename, String text) global native

;-- Functions ---------------------------------------

Float function getVersion()
	return 1.20000
endFunction

function beginLoad(String filename)
	If LoadCObject == "NULL" ; Avoid repeated beginLoad (prevent C code memory leak problem)
	   LoadCObject = CFissBeginLoad(filename) 
	EndIf
endFunction

String function endLoad()
	String Ret = CFissEndLoad(LoadCObject)
	LoadCObject = "NULL"
	return Ret
endFunction

Bool function loadBool(String name)
	return CFissLoadBool(LoadCObject, name)
endFunction

String function loadString(String name)
	return CFissLoadString(LoadCObject, name)
endFunction

Float function loadFloat(String name)
	return CFissLoadFloat(LoadCObject, name)
endFunction

Int function loadInt(String name)
	return CFissLoadInt(LoadCObject, name)
endFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function beginSave(String filename, String modname)
	If SaveCObject == "NULL" ; Avoid repeated beginSave (prevent C code memory leak problem)
	   SaveCObject = CFissBeginSave(filename, modname) 
	EndIf
endFunction

String function endSave()
	String Ret = CFissEndSave(SaveCObject)
	SaveCObject = "NULL"
	return Ret
endFunction

function saveBool(String name, Bool b)
	CFissSaveBool(SaveCObject, name, b)
endFunction

function saveString(String name, String S)
	CFissSaveString(SaveCObject, name, S)
endFunction

function saveFloat(String name, Float f)
	CFissSaveFloat(SaveCObject, name, f)
endFunction

function saveInt(String name, Int i)
	CFissSaveInt(SaveCObject, name, i)
endFunction

String function saveTextToTxtFile(String filename, String text)
	return CFissSaveTextToTxtFile(filename, text)
endFunction
