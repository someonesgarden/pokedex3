//
//  Item+CoreDataProperties.swift
//  Pokedex3
//
//  Created by USER on 2017/03/14.
//  Copyright © 2017年 Someonesgarden. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var name_jp: String?
    @NSManaged public var toImage: Image?
    @NSManaged public var toItemType: ItemType?
    
}
