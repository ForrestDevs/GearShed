//
//  Brand+Extension.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//


import SwiftUI
import CoreData

// constants
let kUnknownBrandName = "Unknown Brand"

extension Brand: Comparable {
    
    // add Comparable conformance: sort by name
    public static func < (lhs: Brand, rhs: Brand) -> Bool {
        lhs.name < rhs.name
    }
    

    // MARK: - Computed properties
    
    // ** please see the associated discussion over in Item+Extensions.swift **
    
    // name: fronts Core Data attribute name_ that is optional
    // if you change an brand's name, its associated items may want to
    // know that some of their computed brandName properties have been invalidated
    var name: String {
        get { name_ ?? "Unknown Name" }
        set {
            name_ = newValue
            items.forEach({ $0.objectWillChange.send() })
        }
    }
    

    
    // items: fronts Core Data attribute items_ that is an NSSet, and turns it into
    // a Swift array
    var items: [Item] {
        if let items = items_ as? Set<Item> {
            return items.sorted(by: { $0.name < $1.name })
        }
        return []
    }
    
    // itemCount: computed property from Core Data items_
    var itemCount: Int { items_?.count ?? 0 }
    
    // simplified test of "is the unknown brand"
    var isUnknownBrand: Bool { name == kUnknownBrandName }
    
    

    // MARK: - Class Functions
    
    class func count() -> Int {
        return count(context: PersistentStore.shared.context)
    }

    // return a list of all brands, optionally returning only user-defined brand
    // (i.e., excluding the unknown brand)
    class func allBrands(userBrandsOnly: Bool) -> [Brand] {
        var allBrands = allObjects(context: PersistentStore.shared.context) as! [Brand]
        if userBrandsOnly {
            if let index = allBrands.firstIndex(where: { $0.isUnknownBrand }) {
                allBrands.remove(at: index)
            }
        }
        return allBrands
    }

    // creates a new Brand having an id, but then it's the user's responsibility
    // to fill in the field values (and eventually save)
    class func addNewBrand() -> Brand {
        let newBrand = Brand(context: PersistentStore.shared.context)
        newBrand.id = UUID()
        return newBrand
    }
    
    // parameters for the Unknown Brand.  call this only upon startup if
    // the Core Data database has not yet been initialized
    class func createUnknownBrand() {
        let unknownBrand = addNewBrand()
        unknownBrand.name_ = kUnknownBrandName
        PersistentStore.shared.saveContext()
        //return unknownBrand
    }

    /*class func unknownBrand() -> Brand {
        // we only keep one "UnknownBrand" in the data store.  you can find it because its
        // order is the largest 32-bit integer. to make the app work, however, we need this
        // default brand to exist!
        //
        // so if we ever need to get the unknown brand from the database, we will fetch it;
        // and if it's not there, we will create it then.
        let fetchRequest: NSFetchRequest<Brand> = Brand.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name_ == %d", kUnknownBrandName)
        do {
            let brands = try PersistentStore.shared.context.fetch(fetchRequest)
            if brands.count >= 1 { // there should be no more than one
                return brands[0]
            } else {
                return createUnknownBrand()
            }
        } catch let error as NSError {
            fatalError("Error fetching unknown brand: \(error.localizedDescription), \(error.userInfo)")
        }
    }*/

    
    class func theUnknownBrand() -> Brand {
        
        let fetchRequest: NSFetchRequest<Brand> = Brand.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name_ == %@", kUnknownBrandName)
       
        do {
            let brand = try PersistentStore.shared.context.fetch(fetchRequest)
            /*if brand.count >= 1 {
                return brand[0]
            } else {
                return createUnknownBrand()
            }*/
            return brand[0]
        } catch let error as NSError {
            fatalError("Error fetching unknown category: //\(error.localizedDescription), \(error.userInfo)")
        }
    }
    
    class func delete(_ brand: Brand) {
        // you cannot delete the unknownBrand
        guard brand.name_ != kUnknownBrandName else { return }

        // retrieve the context of this Brand and get a list of
        // all items for this brand so we can work with them
        let context = brand.managedObjectContext
        let itemsAtThisBrand = brand.items
        
        // reset brand associated with each of these to the unknownBrand
        // (which in turn, removes the current association with brand). additionally,
        // this could affect each item's computed properties
        let theUnknownBrand = Brand.theUnknownBrand()
        itemsAtThisBrand.forEach({ $0.brand = theUnknownBrand })
        // now finish the deletion and save
        context?.delete(brand)
        try? context?.save()
    }
    
    class func updateData(using editableData: EditableItemData) {
        // if the incoming brand is not nil, then this is just a straight update.
        // otherwise, we must create the new Brand here and add it
        if let id = editableData.idBrand,
             let brand = Brand.object(id: id, context: PersistentStore.shared.context) {
            brand.updateValues(from: editableData)
        } else {
            let newBrand = Brand.addNewBrand()
            newBrand.updateValues(from: editableData)
        }
    }
    
    class func object(withID id: UUID) -> Brand? {
        return object(id: id, context: PersistentStore.shared.context) as Brand?
    }

    
    // MARK: - Object Methods
    
    func updateValues(from editableData: EditableItemData) {
        
        // we first make these changes directly in Core Data
        name_ = editableData.brandName
        
        // one more thing: items associated with this brand may want to know about
        // (some of) these changes.  reason: items rely on knowing some computed
        // properties such as uiColor, brandName, and order.
        // usually, what i would do is this, to be sure that anyone who is
        // observing an Item as an @ObservedObject knows about the Brand update:
        
        items.forEach({ $0.objectWillChange.send() })
    }
    
} // end of extension Brand
