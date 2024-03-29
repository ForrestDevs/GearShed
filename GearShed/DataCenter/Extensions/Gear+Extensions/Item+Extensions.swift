//
//  Item+Extensions.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

extension Item {
	// MARK: - Computed Properties
	// the name.  this fronts a Core Data optional attribute
	var name: String {
		get { name_ ?? "Not Available" }
		set { name_ = newValue }
	}
    // the details.  this fronts a Core Data optional attribute
    var detail: String {
        get { detail_ ?? "Not Available" }
        set { detail_ = newValue }
    }
    var diaries: [ItemDiary] {
        if let diaries = diaries_ as? Set<ItemDiary> {
            return diaries.sorted(by: { $0.name < $1.name })
        }
        return []
    }
	// whether the item is a favourtie or not.  this fronts a Core Data boolean
	var isFavourite: Bool {
        get { isFavourite_ }
        set { isFavourite_ = newValue }
    }
    // whether the item is a regret or not.  this fronts a Core Data boolean
    var isRegret: Bool {
        get { isRegret_ }
        set { isRegret_ = newValue }
    }
	// whether the item is on the wishlist or not. this fronts a core date boolean
	var isWishlist: Bool {
		get { isWishlist_ }
        set { isWishlist_ = newValue }
	}
	// quantity of the item.   this fronts a Core Data optional attribute
	// but we need to do an Int <--> Int32 conversion
	var quantity: Int {
		get { Int(quantity_) }
		set { quantity_ = Int32(newValue) }
	}
    // the weight in grams.  this fronts a Core Data optional attribute
    var weight: String {
        get { weight_ ?? "" }
        set { weight_ = newValue }
    }
    var itemLbs: String {
        get { lbs_ ?? "" }
        set { lbs_ = newValue }
    }
    var itemOZ: String {
        get { oz_ ?? "" }
        set { oz_ = newValue }
    }
    // the price.  this fronts a Core Data optional attribute
    var price: String {
        get { price_ ?? "" }
        set { price_ = newValue }
    }
	// an item's associated shed.  this fronts a Core Data optional attribute.
	// if you change an item's shed, the old and the new Shed may want to
	// know that some of their computed properties could be invalidated
	var shed: Shed {
        get { shed_! }
		set { shed_?.objectWillChange.send()
              shed_ = newValue
              shed_?.objectWillChange.send()
		}
	}
    // an item's associated brand.  this fronts a Core Data optional attribute.
    // if you change an item's brand, the old and the new Brand may want to
    // know that some of their computed properties could be invalidated
    var brand: Brand {
        get { brand_! }
        set {
            brand_?.objectWillChange.send()
            brand_ = newValue
            brand_?.objectWillChange.send()
        }
    }
    var gearlists: [Gearlist] {
        if let gearlists = gearlists_ as? Set<Gearlist> {
            return gearlists.sorted(by: { $0.name < $1.name })
        }
        return []
    }
    var adventures: [Gearlist] {
        if let adventures = gearlists_ as? Set<Gearlist> {
            let array = adventures.sorted(by: { $0.name < $1.name })
            return array.filter({ $0.isAdventure == true })
        }
        return []
    }
    var activities: [Gearlist] {
        if let activities = gearlists_ as? Set<Gearlist> {
            let array = activities.sorted(by: { $0.name < $1.name })
            return array.filter({ $0.isAdventure == false })
        }
        return []
    }
    // the date purchased
    var datePurchased: Date? {
        get { datePurchased_ ?? nil }
        set { datePurchased_ = newValue }
    }
    var piles: [Pile] {
        if let piles = piles_ as? Set<Pile> {
            return piles.sorted(by: { $0.name < $1.name })
        }
        return []
    }
    var packs: [Pack] {
        if let packs = packs_ as? Set<Pack> {
            return packs.sorted(by: { $0.name < $1.name })
        }
        return []
    }
    
    var onBodyGearlists: [OnBodyGear] {
        if let onBodyGearlists = onbodygears_ as? Set<OnBodyGear> {
            return onBodyGearlists.sorted(by: { $0.id < $1.id })
        }
        return []
    }
    var baseWeightGearlists: [BaseWeightGear] {
        if let baseWeightGearlists = baseweightgears_ as? Set<BaseWeightGear> {
            return baseWeightGearlists.sorted(by: { $0.id < $1.id })
        }
        return []
    }

    var consumableGearlists: [ConsumableGear] {
        if let consumableGearlists = consumablegears_ as? Set<ConsumableGear> {
            return consumableGearlists.sorted(by: { $0.id < $1.id })
        }
        return []
    }

    var packingBools: [PackingBool] {
        if let packingBools = packingBools_ as? Set<PackingBool> {
            return packingBools.sorted(by: { $0.id < $1.id })
        }
        return []
    }
	/// The name of an Items associated Shed
	var shedName: String { shed_?.name_ ?? "Not Available" }
    /// The name of an Items associated Brand
    var brandName: String { brand_?.name_ ?? "Not Available" }
    /// Function to return an Items Pack In a specifc Gearlist.
    func gearlistPack(gearlist: Gearlist) -> Pack? {
        // First Filter out all the packingGroups by Gearlist
        let pack = packs.first(where: { $0.gearlist == gearlist })
        return pack ?? nil
    }
    /// Function to return an Items Pile In a specifc Gearlist.
    func gearlistPile(gearlist: Gearlist) -> Pile? {
        let pile = piles.first(where: { $0.gearlist == gearlist })
        return pile ?? nil
    }
    /// Function to return an Items On Body list in a specific Gearlist
    func gearlistOnBody(gearlist: Gearlist) -> OnBodyGear? {
        let onBody = onBodyGearlists.first(where: { $0.gearlist == gearlist })
        return onBody ?? nil
    }
    /// Function to return an Items Base Weight list in a specific Gearlist
    func gearlistBaseWeight(gearlist: Gearlist) -> BaseWeightGear? {
        let baseWeight = baseWeightGearlists.first(where: { $0.gearlist == gearlist })
        return baseWeight ?? nil
    }
    /// Function to return an Items Consumable list in a specific Gearlist
    func gearlistConsumable(gearlist: Gearlist) -> ConsumableGear? {
        let consumable = consumableGearlists.first(where: { $0.gearlist == gearlist })
        return consumable ?? nil
    }
    /// Function to find wether or not a diary exists for an item in a gearlist
    func hasExistingDiaryInGearlist(gearlist: Gearlist, item: Item) -> Bool {
        var source: Bool = false
        for diary in item.diaries {
            if diary.gearlist == gearlist {
                source = true
            } else {
                source = false
            }
        }
        return source
    }
    /// Function to return the details of a specifc diary in a gearlist
    func gearlistDiaryDetails(gearlist: Gearlist, item: Item) -> String {
        var details: String = ""
        for diary in item.diaries {
            if diary.gearlist == gearlist {
                details = diary.details
            }
        }
        return details
    }
    /// Function to return an Items PackBool in a specific Gearlist.
    func gearlistpackingBool(gearlist: Gearlist) -> PackingBool? {
        let packingBool = packingBools.first(where: {$0.gearlist == gearlist })
        return packingBool ?? nil
    }
    /// Function to return an Items PackBool in a specific Pack.
    func packPackingBool(pack: Pack) -> PackingBool? {
        let packingBool = packingBools.first(where: {$0.pack == pack })
        return packingBool ?? nil
    }
    /// Function to delete an item
    class func delete(_ item: Item) {
        // remove the reference to this item from its associated shed
        // by resetting its (real, Core Data) shed to nil
        item.shed_ = nil
        item.brand_ = nil
        // now delete and save
        let context = item.managedObjectContext
        context?.delete(item)
        try? context?.save()
    }
    /// Function to toggle favourite boolean
    func markFavourite() {
        isWishlist = false
        isRegret = false
        isFavourite = true
    }
    func unmarkFavourite() {
        isFavourite = false
    }
    /// Function to toggle regret boolean
    func markRegret() {
        isFavourite = false
        isWishlist = false
        isRegret = true
    }
    func unmarkRegret() {
        isRegret = false
    }
    /// Function to toggle wishlist boolean
    func markWish() {
        isFavourite = false
        isRegret = false
        isWishlist = true
    }
    func unmarkWish() {
        isWishlist = false
    }
}

