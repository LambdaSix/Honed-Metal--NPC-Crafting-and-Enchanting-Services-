ScriptName HM_Messages Extends Quest


;################# ATTENTION TRANSLATORS ################:
; If you are translating the mod for SSE and its family (AE, VR, etc) all the versions have the exact same assests. You
; do not need to make 3 different copies, just release one .esp and it will work for all 3 versions of the game.
; All text shown to the user is contained in this script, with the exception of dialogue and the MCM text which is
; contained in HonedMetal.esp and the MCM translation file, respectively.

String Property ENCHANTMENT_LEARNED Hidden
	String Function Get ()
		Return "After keen examination, the enchanter carefully dismantles the item to learn its properties."
	EndFunction
EndProperty

String Property ENCHANTMENT_KNOWN Hidden
	String Function Get ()
		Return  "The enchanter already knows this enchantment."
	EndFunction
EndProperty

String Property INSUFICIENT_MATERIALS Hidden
	String Function Get ()
		Return  "The blacksmith doesn't have the components required to create this item."
	EndFunction
EndProperty

String Property INSUFICIENT_SKILL Hidden
	String Function Get ()
		Return  "The blacksmith doesn't have sufficient skill to improve this."
	EndFunction
EndProperty

String Property ADDED_FACTION Hidden
	String Function Get ()
		Return  " has been added."
	EndFunction
EndProperty

String Property TESTING_PERKS Hidden
	String Function Get ()
		Return  "All known crafting and enchanting perks have been adeed to you."
	EndFunction
EndProperty

String Property ORDERED Hidden
	String Function Get ()
		Return  "ordered "
	EndFunction
EndProperty

String Property PERKS_RESET Hidden
	String Function Get ()
		Return "Your smithing and enchanting perks have been reset."
	EndFunction
EndProperty

String Property INITIALIZED Hidden
	String Function Get ()
		Return "Honed Metal successfully initialized."	
	EndFunction
EndProperty

String Property PLUGIN_OUTDATED_ERROR Hidden
	String Function Get ()
		Return  "The detected version of HonedMetal.dll is too old. Make sure you are not mixing different versions of the mod.\nDetected version: "
	EndFunction
EndProperty

String Property PLUGIN_REGISTRATION_ERROR Hidden
	String Function Get ()
		Return  "HonedMetal.dll could not be detected or failed SKSE registration. Make sure the plugin is present in your Data/SKSE/Plugins folder and that you're using the correct SKSE runtime for which the plugin was compiled. The SKSE log should provide more details."
	EndFunction
EndProperty

String Property UPDATE_SUCCESS Hidden
	String Function Get ()
		Return  "Honed Metal successfully updated to version " 
	EndFunction
EndProperty

String Property UNSUPPORTED_UPGRADE Hidden
	String Function Get ()
		Return  "Honed Metal:\nUpgrading from a previous version of the mod to this release is not supported. Many properties were renamed, deleted, or changed; these values can not be updated programatically but must be filled by the game, which happens when a mod is installed afresh. Instructions on how to do this can be found in the mod's description page at Nexusmods.com."
	EndFunction
EndProperty

String Property UNINSTALL Hidden
	String Function Get ()
		Return  "Honed Metal has been successfully uninstalled. Save the game now, quit and remove the mod. If you wish, you can safely re-install after you save the game with the mod removed."	
	EndFunction
EndProperty

String Property COMBAT_STATE Hidden
	String Function Get ()
		Return "The game does not allow crafting stations to be activated While in combat. You must get out of the combat state before requesting smithing or enchanting services."
	EndFunction
EndProperty

String Property PROPERTY_ERROR Hidden
	String Function Get ()
		Return "Honed Metal:\nOne or more of the mod's script properties failed an integrity check, indicating their values are corrupt. For your safety and my sanity, the mod will stop now."
	EndFunction
EndProperty

String Property MOD_PAUSED Hidden
	String Function Get ()
		Return  "Honed Metal:\nDue to the previously specified error, the mod has been paused. It will not work until you rectify the issue and reset the mod through the 'Repair' MCM option."
	EndFunction
EndProperty

String Property ARRAY_LIMIT Hidden
	String Function Get ()
		Return  "You have reached the maximum amount of concurrent merchants of which Honed Metal is able to keep track. Please retrieve all your items from a blacksmith or enchanter to create additional space. Items you create/modify will not be saved."
	EndFunction
EndProperty

String Property STOPPED Hidden
	String Function Get ()
		Return "Honed Metal:\nFor unknown reasons, the mod's main quest seems not to be running. The only way to restart the quest wihout starting a new game is to remove the mod, save the game once the mod is removed and then install again. Use the Uninstall feature in the MCM before removal."
	EndFunction
EndProperty

String Property SCRIPT_MISMATCH Hidden
	String Function Get ()
		Return "Honed Metal:\nScript version mismatch. Either SkyUI/SkyAway is not installed, or you have a patch or translation mod overriding the scripts packed by Honed Metal. Check your load order and remove them."
	EndFunction
EndProperty

String Property FILE_MISMATCH Hidden
	String Function Get ()
		Return "Honed Metal:\nYou seem to be using different script - plugin versions. Make sure 'HonedMetal.esp' and 'HonedMetal.bsa' are of the same release. Are you using an outdated HM patch or translation mod?"	
	EndFunction
EndProperty

String Property ACTIVATION_ERROR Hidden
	String Function Get ()
		Return  "Honed Metal:\n The dialogue event responsible for starting the mod's routines did not trigger in a timely manner. We have recovered from the error and cleaned up, please try again.\n\nTIP: If the NPC has no voice, skipping the silent dialogue line by clicking or pressing tab usually avoids this error."
	EndFunction
EndProperty	

String Property ITEM_PREFIX Hidden
	String Function Get ()
		Return  "Packed"
	EndFunction
EndProperty

String Property NPC_SKILL_RESTORED Hidden
	String Function Get ()
		Return  "The default skill values have been restored to the 'NPC Skill Rebalance' table."
	EndFunction
EndProperty
	
String Property RECOVER_CONTAINER Hidden
	String Function Get ()
		Return  "The storage chest in which service NPCs store your items will open once you close the MCM."
	EndFunction	
EndProperty

String Property ITEMS_OVERFLOW Hidden
	String Function Get ()
		Return  "You ordered too many items and not all could be displayed. They will appear next time you open this window, after purchasing some of the items already shown."
	EndFunction	
EndProperty

String Property INVALID_RECHARGE_TARGET Hidden
	String Function Get ()
		Return "No weapopns were given, no enchantments detected or charge levels already at maximum capacity. All invalid weapons have been returned to your inventory."
	EndFunction
EndProperty

Int Property script_version Hidden
	Int Function Get ()
		return (13)
	EndFunction
EndProperty
