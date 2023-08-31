ScriptName HM_Inventory Extends Quest Conditional

HM_actor Property _actor Auto
HM_Stations Property _station Auto

FormList Property materials Auto	
FormList Property rare_materials Auto
FormList Property dummy_list Auto Hidden
Form[] Property available_materials Auto Hidden ;Materials available to NPCs. Obtained from materials + rare_materials.
Bool Property equipment_ready Auto Conditional

ObjectReference Property item_storage Auto Hidden
ObjectReference Property sale_container Auto
ObjectReference Property transition_container Auto
ObjectReference Property returns_container Auto
ObjectReference[] Property npc_storage_list Auto
ObjectReference[] Property npc_merchant_container Auto Hidden
MiscObject[] Property packed_items_list Auto
MiscObject Property gold Auto

Form[] Property new_equipment Auto Hidden
Form[] Property materials_used Auto Hidden
Int[] Property materials_used_count Auto Hidden
Form[] Property npc_materials Auto Hidden
Int[] Property npc_materials_count Auto Hidden
Float Property common_materials_acquisition_time = 0.05 Auto Hidden
Float Property rare_materials_acquisition_time = 0.33 Auto Hidden
Int Property MAX_MATERIAL_TO_ADD = 50 AutoReadOnly

Int Property EQUIPMENT_RELATION Auto Hidden ;ENUMERATOR
Int Property MATERIALS_COST Auto Hidden ;ENUMERATOR
Int Property WEAPONS_AVERAGE_CHARGE Auto Hidden ;ENUMERATOR
Int Property STORAGE_IDX Auto Hidden ;ENUMERATOR

ObjectReference[] storage_records
Form[] NULL

Form property packed_form auto

Function acquireNPCStorage()
	Int idx = storage_records.Find(None)

	If (idx < 0)
		idx = storage_records.Length
		idx -= ((idx > 0) As Int)
	EndIf
	item_storage = npc_storage_list[idx]
	storage_records[idx] = item_storage
EndFunction


Function releaseNPCStorage(ObjectReference storage, Int index = 0)
	Int idx
	
	If (storage)
		idx = npc_storage_list.Find(storage)
		If (idx < 0)
			Return
		EndIf
	ElseIf(idx > -1)
		idx = index
	EndIf
	storage_records[idx] = None
	item_storage = None
EndFunction


Function InitNPCStorage()
	storage_records = New ObjectReference[10;/npc_storage_list.Length/;]
EndFunction


Function processCreatedEquipment()
	Actor	player = _actor.player
	Int		idx = new_equipment.length
	Int		created
	Form	item
	
	HMCraftingUtils.getCachedItemCount(None, None)
	While (idx)
		idx -= 1;
		item = new_equipment[idx]
		created = HMCraftingUtils.getProducedQuantityForItem(item)
		Int total = HMCraftingUtils.getCachedItemCount(player, item);player.getItemcount(item)

		If (total > created && ((item As Armor) || (item As Weapon) ) )
			processDuplicates(item, created, total, player.IsEquipped(item) )
		Else
			player.RemoveItem(item, created, True, item_storage)
		EndIf
	EndWhile
EndFunction


Function processDuplicates(Form item, Int created, Int total, bool is_equipped)
	ObjectReference	destination
	ObjectReference	equipped_container = sale_container
	Actor			player = _actor.player
	Int				initial_cnt = total
	bool			reequip

	While (total && created)
		destination = returns_container
		player.RemoveItem(item, 1, True, transition_container)
		If (is_equipped && !player.IsEquipped(item) )
			is_equipped = false
			reequip = true
			destination = equipped_container
		EndIf
		If (HMCraftingUtils.containsProducedItem(transition_container) )
			reequip = !(!reequip || destination == equipped_container)
			destination = item_storage
			created -= 1
		EndIf
		transition_container.RemoveAllItems(destination)
		total -= 1
	EndWhile
	If (reequip)
		player.RemoveItem(item, initial_cnt, True, returns_container)
		equipped_container.RemoveAllItems(player)
		player.EquipItemEx(item, 0, equipSound = true)
	EndIf
	returns_container.RemoveAllItems(player)
EndFunction


Function adjustEquipmentPrice (Form[] packed_items)
	HM_array_extension_library _hmael = _actor._mod._hmael
	Form[]	equipment = New Form[128]
	Int[]	cost = New Int[128]
	Int		service = _hmael.aStructureGetMember_int(_actor.vendor, _actor.TRANSACTION_TYPE)
	Int		item_count = packed_items.Find(None)
	Int		idx = item_count

	While (idx > 0)
		idx -= 1
		equipment[idx] = _hmael.aStructureGetMapElement_formForm(_actor.vendor, EQUIPMENT_RELATION, packed_items[idx])
	EndWhile
	If (service == _actor.CRAFT_SERVICE)
		calcCraftingCost(cost, equipment, item_count)
	ElseIf (service == _actor.RECHARGE_SERVICE)
		calcRechargingCost(cost, equipment, item_count)
	Else
		calcEnchTemperingCost(cost, equipment, item_count, service)
	EndIf
	idx = item_count
	While (idx > 0)
		idx -= 1
		packed_items[idx].SetGoldValue(cost[idx])
	EndWhile
EndFunction


Function calcCraftingCost(Int[] cost, Form[] items, Int count)
	HM_array_extension_library _hmael = _actor._mod._hmael
	Float	price_factor = (_actor.craft_price_multiplier * Math.Log(_hmael.aStructureGetMember_int(_actor.vendor, _actor.VENDOR_SKILL) ) * 0.4343) ;constant to convert from natural to base10 logarithm without using division
	Float	matcost = (_hmael.aStructureGetMember_int(_actor.vendor, MATERIALS_COST) As Float * _actor.materials_price_multiplier)
	Float	mats_adjustment
	Float	ammo_mod = ((1.0 - price_factor) * ((price_factor >= 1.0) as Float) * 0.25) + 1.0
	Form	item
	
	While (count > 0)
		count -= 1
		item = items[count]
		mats_adjustment = (matcost / (item_storage.GetItemCount(item) as Float) )
		If (item As ammo)
			cost[count] = (((HMCraftingUtils.getDisplayCostForItem(item_storage, item) as Float) * price_factor) * ammo_mod) as Int
		Else
			cost[count] = (((HMCraftingUtils.getDisplayCostForItem(item_storage, item) as Float) * price_factor) + mats_adjustment) as Int
		EndIf
	EndWhile
EndFunction


Function calcEnchTemperingCost(Int[] cost, Form[] items, Int count, Int service)
	Float service_multiplier

	If (service == _actor.ENCHANT_SERVICE)
		service_multiplier = _actor.enchant_price_multiplier
	Else 
		service_multiplier = _actor.temper_price_multiplier
	EndIf
	HM_array_extension_library _hmael = _actor._mod._hmael
	Float	price_factor = service_multiplier * _hmael.aStructureGetMember_int(_actor.vendor, _actor.VENDOR_SKILL)
	Float	matcost = (_hmael.aStructureGetMember_int(_actor.vendor, MATERIALS_COST) As Float * _actor.materials_price_multiplier)
	Float	mats_adjustment

	While (count > 0)
		count -= 1
		mats_adjustment = (matcost / (item_storage.GetItemCount(items[count]) as Float) )
		cost[count] = ((Math.sqrt(HMCraftingUtils.getDisplayCostForItem(item_storage, items[count]) * 2) * price_factor) + mats_adjustment) as Int
	EndWhile
EndFunction


Function calcRechargingCost(Int[] cost, Form[] items, Int count)
	HM_array_extension_library _hmael = _actor._mod._hmael
	Float	price_factor = _actor.recharge_price_multiplier * getRechargeCost(_hmael.aStructureGetMember_int(_actor.vendor, WEAPONS_AVERAGE_CHARGE) )

	While (count > 0)
		count -= 1
		cost[count] = ((Math.sqrt(items[count].GetGoldValue() * 10) + price_factor) As Int)
	EndWhile
EndFunction


Int Function getRechargeCost (Int average_charge)
	Int gem_cost = 1 + Game.GetFormFromFile(0x0002e4f3, "Skyrim.esm").GetGoldValue()
	Int cost = Math.Ceiling(average_charge / 1000.0) ;charge of a common soulgem 	

	If (cost)
		Return (cost * gem_cost * _actor.materials_price_multiplier) As Int
	EndIf
	Return (gem_cost * _actor.materials_price_multiplier) As Int
EndFunction


Float Function restoreWeaponCharge (Form[] weapons, ObjectReference source, ObjectReference destination)
	Actor	mannequin = _actor.mannequin
	Int		weapon_number = weapons.length
	Int		charged_cnt
	Float	deficit
	Float	restored
	Float	maxcharge
	Bool	charged

	While (weapon_number)
		weapon_number -= 1
		source.RemoveItem(weapons[weapon_number], 1, True, mannequin)
		mannequin.EquipItemEx(weapons[weapon_number], 0)
		maxcharge = WornObject.GetItemMaxCharge(mannequin, 1, 0)
		deficit = (maxcharge - WornObject.GetItemCharge(mannequin, 1, 0) )
		If (maxcharge && deficit > 0.0)	;restoreav fails for some users, while setav fails for others. Trying one if the other fails.
			mannequin.RestoreActorValue("RightItemCharge", maxcharge)
			charged = mannequin.GetActorValue("RightItemCharge") >= maxcharge
			If (!charged)
				mannequin.SetActorValue("RightItemCharge", maxcharge)
				charged = mannequin.GetActorValue("RightItemCharge") >= maxcharge
			EndIf
		EndIf
		If (!charged)
			mannequin.removeAllItems(transition_container)
		Else
			mannequin.removeAllItems(destination)
			restored += deficit
			charged_cnt += 1
		EndIf
		charged = False
	EndWhile
	charged_cnt += ((!charged_cnt) as Int)
	transition_container.RemoveAllItems(source)
	_actor._mod._hmael.aStructureAddMember(_actor.vendor, WEAPONS_AVERAGE_CHARGE, NULL, new_int_member = (restored As Int / charged_cnt) )
	Return (restored)
EndFunction


Function prepareItemsForSale (Form[] equipment_items)	
	Int item_index	
	Int TOTAL_ITEMS = equipment_items.Length
	Int MAX_ITEMS_DISPLAYED = packed_items_list.length
	String prefix = _actor._mod.messages.ITEM_PREFIX
	Form[] packed_items = New Form[128]
	Form packed_item
	HM_array_extension_library _hmael = _actor._mod._hmael

	While (item_index < TOTAL_ITEMS && item_index < MAX_ITEMS_DISPLAYED)
		packed_item = packed_items_list[item_index]
		sale_container.AddItem(packed_item, item_storage.GetItemCount(equipment_items[item_index]) )
		packed_item.SetName(prefix + " " + equipment_items[item_index].GetName() )
		packed_items[item_index] = packed_item		
		_hmael.aStructureAddMapElement_formForm(_actor.vendor, EQUIPMENT_RELATION, packed_item, equipment_items[item_index])
		item_index += 1	
	EndWhile	
	adjustEquipmentPrice(packed_items)
EndFunction


Function adjustEquipmentQuality (Form equipment_item, ObjectReference source)
	Int	type = equipment_item.GetType()
	
	If (type == 41 || type == 26)
		Int		craftsmanskill = _actor._mod._hmael.aStructureGetMember_int(_actor.vendor, _actor.VENDOR_SKILL)
		Float	skill_ratio = craftsmanskill * 0.01

		If (skill_ratio > 1.0)
			skill_ratio = 1.0
		EndIf
		Float quality_level = skill_ratio * (game.getGameSettingFloat("fSmithingArmorMax") * 0.005 + 0.2) + 1.0
		Int	slot
		Int	hand_slot	

		If (type == 26)
			slot = (equipment_item As Armor).GetSlotMask()
		Else
			hand_slot = 1
		EndIf
		source.RemoveItem(equipment_item, 1, True, _actor.mannequin)
		_actor.mannequin.EquipItemEx(equipment_item, hand_slot, False, False)
		WornObject.SetItemHealthPercent(_actor.mannequin, hand_slot, slot, quality_level)
		_actor.mannequin.RemoveItem(equipment_item, 1, True, source)
	EndIf
EndFunction


Function	setAvailableMaterials ()
	Int		iterations = (_actor.vendors_have_basic_mats As Int) + (_actor.vendors_have_rare_mats As Int)
	Int		material
	Int		idx = materials.GetSize() + rare_materials.GetSize()
	Form[]	list

	If (_actor.vendors_have_basic_mats)
		list = materials.ToArray()
	ElseIf (_actor.vendors_have_rare_mats)
		list = rare_materials.ToArray()
	EndIf
	available_materials = utility.CreateFormArray(1 + idx * ((idx < 512) as Int) )
	iterations *= ((idx < 512) as Int)
	While (iterations)
		idx = list.length
		While (idx)
			idx -= 1
			available_materials[material] = list[idx]
			material += 1
		EndWhile
		list = rare_materials.ToArray()
		iterations -= 1
	EndWhile
EndFunction


Function scanNPCMaterials ()
	ObjectReference	merchant_container
	Faction[]		factions = _actor.vendor.getFactions(0, 2)			
	Form[]			container_items
	Form[]			rare = rare_materials.ToArray()
	Form[]			common = materials.ToArray()
	Int				merchant_container_index
	Int				factions_index = factions.Length
	Int				items_index
	Int				npc_mats_idx	
	
	While (factions_index)
		factions_index -= 1
		If (;/factions[factions_index].IsVendor() &&/; !_actor.player.isInFaction(factions[factions_index]) )
			merchant_container = factions[factions_index].GetMerchantContainer()
			If (merchant_container && npc_merchant_container.Find(merchant_container) < 0)
				npc_merchant_container[merchant_container_index] = merchant_container
				merchant_container_index += 1
				container_items = merchant_container.getContainerForms()
				If (container_items)
					items_index = available_materials.Find(None)
					While (items_index > 0)
						items_index -= 1
						If (container_items.Find(available_materials[items_index]) > -1)
							npc_materials[npc_mats_idx] = available_materials[items_index]
							npc_materials_count[npc_mats_idx] = merchant_container.GetItemCount(available_materials[items_index])
							npc_mats_idx += 1
						EndIf 
					EndWhile
				EndIf
			EndIf
		EndIf
	EndWhile	
EndFunction


Function addMaterials (Bool Add = True)
	Int mats_idx = npc_materials.Find(None)
	FormList materials_available_to_NPC = dummy_list	
	materials_available_to_NPC.addForms(available_materials)
	If (Add)
		_actor.increasePlayerEncumbrance()
		If (_actor.vendors_have_basic_mats || _actor.vendors_have_rare_mats)
			_actor.player.AddItem(materials_available_to_NPC, MAX_MATERIAL_TO_ADD, True)
		EndIf		
		While (mats_idx > 0)
			mats_idx -= 1
			_actor.player.AddItem(npc_materials[mats_idx], npc_materials_count[mats_idx], True)
		EndWhile
	Else
		If (_actor.vendors_have_basic_mats || _actor.vendors_have_rare_mats)
			_actor.player.RemoveItem(materials_available_to_NPC, MAX_MATERIAL_TO_ADD, True)
			dummy_list.Revert()
		EndIf		
		While (mats_idx > 0)
			mats_idx -= 1
			_actor.player.RemoveItem(npc_materials[mats_idx], npc_materials_count[mats_idx], True)
		EndWhile
		_actor.increasePlayerEncumbrance(False)
	EndIf
EndFunction


Function getMaterialsUsed ()	
	Actor player = _actor.player	
	Int mats_idx
	Int used_mats_idx
	Int player_materials_count		
	
	If (_actor.vendors_have_basic_mats || _actor.vendors_have_rare_mats)		
		mats_idx = available_materials.Find(None)
		Int npcmat_idx
		Int mats_from_npc

		HMCraftingUtils.getCachedItemCount(None, None);clear the cache		
		While (mats_idx > 0)
			mats_idx -= 1			
			npcmat_idx = npc_materials.Find(available_materials[mats_idx])
			mats_from_npc = npc_materials_count[npcmat_idx * ((npcmat_idx > -1) as Int)] * ((npcmat_idx > -1) as Int)
			player_materials_count = HMCraftingUtils.getCachedItemCount(player, available_materials[mats_idx])
			If (player_materials_count > -1 && player_materials_count < (MAX_MATERIAL_TO_ADD + mats_from_npc) )
				materials_used[used_mats_idx] = available_materials[mats_idx]
				materials_used_count[used_mats_idx] = ((MAX_MATERIAL_TO_ADD + mats_from_npc) - player_materials_count)
				used_mats_idx += 1
			EndIf
		EndWhile
	Else
		mats_idx = npc_materials.Find(None)
		While (mats_idx > 0)
			mats_idx -= 1
			player_materials_count = player.GetItemCount(npc_materials[mats_idx])
			If (player_materials_count < npc_materials_count[mats_idx] )
				materials_used[used_mats_idx] = npc_materials[mats_idx]
				materials_used_count[used_mats_idx] = (npc_materials_count[mats_idx] - player_materials_count)
				used_mats_idx += 1
			EndIf
		EndWhile
	EndIf
EndFunction


Function removeMaterialsFromNPC()
	Int mats_idx
	Int merchant_container_index = npc_merchant_container.Find(None)	
	While (merchant_container_index > 0)
		merchant_container_index -= 1
		mats_idx = materials_used.Find(None)
		While (mats_idx > 0)
			mats_idx -= 1
			npc_merchant_container[merchant_container_index].RemoveItem(materials_used[mats_idx], materials_used_count[mats_idx])				
		EndWhile		
	EndWhile
EndFunction


Int Function getMaterialsAverageCost()
	Int	mats_idx = materials_used.Find(None)
	Int	total_items = new_equipment.length
	Int	cost
	
	While (mats_idx > 0)
		mats_idx -= 1
		cost += (materials_used[mats_idx].GetGoldValue() * materials_used_count[mats_idx])
	EndWhile
	cost /= total_items
	Return ((cost As Float) / Game.GetGameSettingFloat("fBarterMax")  ) As Int
EndFunction


Int Property script_version Hidden
Int Function get ()
	return (13)
EndFunction
EndProperty
