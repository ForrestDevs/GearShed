//
//  EditableItemData.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//
// this gives me a way to collect all the data for an Item that i might want to edit
// (or even just display).  it defaults to having values appropriate for a new item upon
// creation, and can be initialized from a Item.  this is something
// i can then hand off to an edit view.  at some point, that edit view will
// want to update an Item with this data, so see the class function
// Item.update(using editableData: EditableItemData)

import Foundation

struct EditableItemData {
    
	// the id of the Item, if any, associated with this data collection
	// (nil if data for a new item that does not yet exist)
	var id: UUID? = nil
    
	// all of the values here provide suitable defaults for a new item
	var name: String = ""
	var weight: String = ""
    var price: String = ""
    var quantity: Int = 1
    var details: String = "Item Details"
	var shed = Shed.theUnknownShed()
    var brand = Brand.theUnknownBrand()
    var wishlist: Bool = false
	var isFavourite = false
    var isRegret = false
	var dateText = "" // for display only, not actually editable
    
	// this copies all the editable data from an incoming Item.  this looks fairly
	// benign, but its in the lines below that crashes did/could occur in earlier versions
	// because of the main, underlying problem: if an item is deleted somewhere outside
	// a view showing a list of items, the list view may wind up calling this with an item
	// that's a zombie: the data behind it has been deleted, but it could still be present
	// as a fault in Core Data.  i still don't quite get this -- it's something to do
	// with how SwiftUI updates views and its interaction with a @FetchRequest.  this is the
	// one, remaining issue with SwiftUI i hope to understand real soon.
    
	init(item: Item) {
		id = item.id
		name = item.name
        
		weight = item.weight
        price = item.price
        quantity = item.quantity
        
        details = item.detail
        
		shed = item.shed
        brand = item.brand
        
		wishlist = item.wishlist
        isFavourite = item.isFavourite
        isRegret = item.isRegret
        
		if item.hasBeenPurchased {
			dateText = item.dateLastPurchased.dateText(style: .medium)
		}
	}
	
    init(initialItemName: String?, initialItemDetails: String?, shed: Shed? = nil, brand: Brand? = nil) {
		if let name = initialItemName, name.count > 0 {
			self.name = name
		}
        if let details = initialItemDetails, details.count > 0 {
            self.details = details
        }
		if let shed = shed {
			self.shed = shed
		}
        if let brand = brand {
            self.brand = brand
        }
	}
	
	// to do a save/commit of an Item, it must have a non-empty name
	var canBeSaved: Bool { name.count > 0 }
	// we also want to know if this itemData is attached to a real Item that
	// exists, or is data that will be used to create a new Item
	var representsExistingItem: Bool { id != nil }
	// useful to know the associated Item (which we'll force unwrap, so
	// be sure you check representsExistingItem first (!)
	var associatedItem: Item { Item.object(withID: id!)! }
    
    // MARK: - Brand Stuff
    
    // the id of the Brand, if any, associated with this data collection
    // (nil if data for a new item that does not yet exist)
    var idBrand: UUID? = nil
    // all of the values here provide suitable defaults for a new Brand
    var brandName: String = ""
    
    // this copies all the editable data from an incoming Brand
    init(brand: Brand?) {
        if let brand = brand {
            idBrand = brand.id!
            brandName = brand.name
        }
    }
    
    // to do a save/commit of an Item, it must have a non-empty name
    var canBrandBeSaved: Bool { brandName.count > 0 }
    
    // useful to know if this is associated with an existing Brand
    var representsExistingBrand: Bool { idBrand != nil && Brand.object(withID: idBrand!) != nil }
    // useful to know the associated brand (which we'll force unwrap, so
    // be sure you check representsExistingBrand first (!)
    var associatedBrand: Brand { Brand.object(withID: idBrand!)! }
    
    // MARK: - Shed Stuff
    
    // the id of the Shed, if any, associated with this data collection
    // (nil if data for a new item that does not yet exist)
    var idShed: UUID? = nil
    // all of the values here provide suitable defaults for a new Shed
    var shedName: String = ""
    
    // this copies all the editable data from an incoming Shed
    init(shed: Shed?) {
        if let shed = shed {
            idShed = shed.id!
            shedName = shed.name
        }
    }
    
    // to do a save/commit of an Item, it must have a non-empty name
    var canShedBeSaved: Bool { shedName.count > 0 }
    
    // useful to know if this is associated with an existing Shed
    var representsExistingShed: Bool { idShed != nil && Shed.object(withID: idShed!) != nil }
    // useful to know the associated shed (which we'll force unwrap, so
    // be sure you check representsExistingShed first (!)
    var associatedShed: Shed { Shed.object(withID: idShed!)! }
    
}




