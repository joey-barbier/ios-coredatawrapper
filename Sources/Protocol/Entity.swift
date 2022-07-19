//
//  EntityWrapper.swift
//  Bliss
//
//  Created by Joey BARBIER on 08/07/2021.
//

import Foundation
import CoreData

public class Entity<T: EntityProtocol> {
    public private(set) var identifier: String
    private var _entity: T?
    public private(set) var entity: T? {
        get {
            //check if the entity is out of date
            if let entity = self._entity, !entity.isFault {
                return entity
            }
            self.entity = .bdd.findBy(id: identifier)
            return _entity
        } set {
            _entity = newValue
        }
    }
    
    public init(with identifier: String) {
        self.identifier = identifier
    }
    
    public init(with entity: T) {
        self.identifier = entity.identifier
        self.entity = entity
    }
}

extension Entity: Equatable {
    public static func == (lhs: Entity<T>, rhs: Entity<T>) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
