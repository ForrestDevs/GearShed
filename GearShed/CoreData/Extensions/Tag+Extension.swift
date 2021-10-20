//
//  Tag+Extension.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI
import CoreData

// constants
let kUnknownTagName = "Unknown Tag"

extension Tag {
    
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
    
    // simplified test of "is the unknown tag"
    var isUnknownTag: Bool { name_ == kUnknownTagName }

    // MARK: - Class Functions
    
    class func count() -> Int {
        return count(context: PersistentStore.shared.context)
    }

    // creates a new Brand having an id, but then it's the user's responsibility
    // to fill in the field values (and eventually save)
    class func addNewTag() -> Tag {
        let newTag = Tag(context: PersistentStore.shared.context)
        newTag.id = UUID()
        return newTag
    }
    
    // parameters for the Unknown Brand.  call this only upon startup if
    // the Core Data database has not yet been initialized
    class func createUnknownTag() -> Tag {
        let unknownTag = addNewTag()
        unknownTag.name_ = kUnknownTagName
        return unknownTag
    }

    class func unknownTag() -> Tag {
        // we only keep one "UnknownBrand" in the data store.  you can find it because its
        // order is the largest 32-bit integer. to make the app work, however, we need this
        // default brand to exist!
        //
        // so if we ever need to get the unknown brand from the database, we will fetch it;
        // and if it's not there, we will create it then.
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        do {
            let tags = try PersistentStore.shared.context.fetch(fetchRequest)
            if tags.count >= 1 { // there should be no more than one
                return tags[0]
            } else {
                return createUnknownTag()
            }
        } catch let error as NSError {
            fatalError("Error fetching unknown brand: \(error.localizedDescription), \(error.userInfo)")
        }
    }
    
    class func delete(_ tag: Tag) {
        // you cannot delete the unknownBrand
        guard tag.name_ != kUnknownTagName else { return }

        // retrieve the context of this Brand and get a list of
        // all items for this brand so we can work with them
        let context = tag.managedObjectContext
        //let itemsAtThisTag = tag.items
        
        // reset tag associated with each of these to the unknownBrand
        // (which in turn, removes the current association with tag). additionally,
        // this could affect each item's computed properties
        //let theUnknownTag = Tag.unknownTag()
        //itemsAtThisTag.forEach({ $0.tag = theUnknownTag })
        // now finish the deletion and save
        context?.delete(tag)
        try? context?.save()
    }
    
    class func updateData(using editableData: EditableItemData) {
        // if the incoming brand is not nil, then this is just a straight update.
        // otherwise, we must create the new Brand here and add it
        if let id = editableData.idTag,
             let tag = Tag.object(id: id, context: PersistentStore.shared.context) {
            tag.updateValues(from: editableData)
        } else {
            let newTag = Tag.addNewTag()
            newTag.updateValues(from: editableData)
        }
    }
    
    class func object(withID id: UUID) -> Tag? {
        return object(id: id, context: PersistentStore.shared.context) as Tag?
    }

    
    // MARK: - Object Methods
    
    func updateValues(from editableData: EditableItemData) {
        
        // we first make these changes directly in Core Data
        name_ = editableData.tagName
        
        // one more thing: items associated with this brand may want to know about
        // (some of) these changes.  reason: items rely on knowing some computed
        // properties such as uiColor, brandName, and order.
        // usually, what i would do is this, to be sure that anyone who is
        // observing an Item as an @ObservedObject knows about the Brand update:
        
        items.forEach({ $0.objectWillChange.send() })
    }
    
} // end of extension Brand*/

