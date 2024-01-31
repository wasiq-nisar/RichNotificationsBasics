//
//  Food+CoreDataProperties.swift
//  
//
//  Created by Muhammad Wasiq  on 31/01/2024.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var added: Date?
    @NSManaged public var type: String?

}
