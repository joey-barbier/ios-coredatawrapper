//
//  User+CoreDataWrapper.swift
//  coreDataWrapper-Demo
//
//  Created by Joey BARBIER on 19/07/2022.
//

import Foundation
import OrkaCoreDataWrapper
import CoreData

final class User: NSManagedObject, EntityProtocol {
    static var entityName: String = "User"
    
    @NSManaged public var identifier: String
    
    @discardableResult
    convenience init(identifier: String, forceContext: NSManagedObjectContext? = nil) {
        guard var managedObjectContext = CoreDataHelper.context else {
            fatalError("Failed context")
        }
        if let forceContext = forceContext {
            managedObjectContext = forceContext
        }
        self.init(context: managedObjectContext)
        self.identifier = identifier
        CoreDataHelper.save()
    }
}
