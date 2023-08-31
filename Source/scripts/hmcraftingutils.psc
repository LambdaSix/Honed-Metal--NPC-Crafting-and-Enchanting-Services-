ScriptName HMCraftingUtils Hidden


;Valid session types:
;0 - unregister if previously registered.
;1 - crafting
;2 - enchanting
;3 - tempering

;Instructs the SKSE plugin to start listening for crafting menu open/close events. 
;Unregistering stops and deletes all information collected. Most of the functions here will only work while still registered.
Bool Function registerForCraftingSession(Int session_type) native global

;Returns an array of all forms crafted, tempered or enchanted in the last crafting session. Must be called while still registered.
Form[] Function getItemsProduced() native global

;Returns how many instances of a particular item were created/modified. Must be called while still registered.
;Zero is returned If the item isn't in the list of produced items for the session.
Int Function getProducedQuantityForItem(Form item) native global

;Returns true if the passed reference contains an item that was crafted, tempered or enchanted during the last crafting
;session. Capable of differentianting between items with the same formid.
;Must be called before unregistering for the crafting session.
Bool Function containsProducedItem(ObjectReference container) native global

;Much faster version of vanilla's 'getItemCount'. Returns how many instances of a form the passed reference has.
;The inventory data of the passed objectreference is cached upon the first call. Subsequent calls look up this cached
;data and return the count.
;If the passed objectreference differs from the one passed in the last call, a new cache is created.
;If either form or objectreference is None, the cache is cleared and -1 is returned.
;If the form is not present in the inventory of the passed reference, -1 is returned.
;Only works for inventory items.
Int Function getCachedItemCount(ObjectReference ref, Form item) native global

;Returns the cost of the passed Form in the container, as shown in the game's UI.
;Returns 0 if the Form is not in the container, or if either container or Form are none.
Int Function getDisplayCostForItem(ObjectReference container, Form item) native global

;Returns the minimum skill requirement for the given perk and the specified actor value.
;Returns Zero if the perk does not have a getBaseAv condition or it doesn't have the given actor value as its parameter.
;If actor_value is empty or isn't valid, the value of the first getBaseAv condition found will be returned.
Int Function getSkillReqForPerk(Perk target, String actor_value) native global

;Scans the mod's configuration file for perk definitions.
Perk[] Function getPerksFromIni(Int setting) native global ;getINIPerks()

Int Function getScriptVersion() global
    return (13)
EndFunction
