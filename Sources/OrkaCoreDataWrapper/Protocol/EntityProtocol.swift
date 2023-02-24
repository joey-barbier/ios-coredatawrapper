//
//  Entity.swift
//  Bliss
//
//  Created by Joey BARBIER on 08/07/2021.
//

import Foundation
import CoreData

public protocol EntityProtocol: Any, NSManagedObject {
    var identifier: String {get}
    
    static var identifierName: String {get}
    static var entityName: String {get set}
    static var bdd: CoreDataFinder<Self> {get}
    
    func wrapped() -> Entity<Self>
}

extension EntityProtocol {
    public static var bdd: CoreDataFinder<Self> {
        return CoreDataFinder()
    }
    
    public func wrapped() -> Entity<Self> {
        return Entity<Self>(with: self)
    }
}
