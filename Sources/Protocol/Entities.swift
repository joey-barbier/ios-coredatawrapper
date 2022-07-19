//
//  Entities.swift
//  CoreDataWrapper
//
//  Created by Joey Barbier on 26/07/2021.
//

import Foundation

public class Entities<T: EntityProtocol> {
    public private(set) var identifiers: [String]
    private var entities: [Entity<T>] = []
    
    public var count: Int {
        return identifiers.count
    }

    public var isEmpty: Bool {
        return identifiers.isEmpty
    }
    
    public var first: Entity<T>? {
        return entities.first
    }
    
    public var last: Entity<T>? {
        return entities.last
    }
    
    public init(withIdentifier identifiers: [String], sortItems: (([T])->(ids: [String], objects: [T]))? = nil) {
        let entities: [T] = T.bdd.findBy(fromParams: [T.identifierName: identifiers])
        let sorted = sortItems?(entities)
        
        self.identifiers = sorted?.ids ?? entities.identifiers()
        self.entities = sorted?.objects.map({Entity<T>(with: $0)}) ?? entities.wrapped().get()
    }
    
    public init(withEntityWrappers entityWrappers: [Entity<T>]) {
        self.identifiers = entityWrappers.map({$0.identifier})
        self.entities = entityWrappers
    }
    
    public init(allItemsSort sortItems: (([T])->(ids: [String], objects: [T]))? = nil) {
        let entities: [T] = T.bdd.findAll() ?? []
        let sorted = sortItems?(entities)
        
        self.identifiers = sorted?.ids ?? entities.identifiers()
        self.entities = sorted?.objects.map({Entity<T>(with: $0)}) ?? entities.wrapped().get()
    }
    
    public init() {
        self.identifiers = []
        self.entities = []
    }

    public func get(at index: Int) -> Entity<T>? {
        if let entity = entities[safe: index] {
            return entity
        }
        guard let identifier = identifiers[safe: index] else {
            return nil
        }
        entities[index] = Entity<T>(with: identifier)
        return entities[safe: index]
    }
    
    public func get() -> [Entity<T>] {
        return entities
    }
    
    public func filter(_ filter: ((T)->(Bool))) -> Entities<T> {
        return Entities<T>(withEntityWrappers: entities.filter({ item in
            guard let entity = item.entity else {return false}
            return filter(entity)
        }))
    }
    
    public func append(_ values: [T]) {
        let items: Entities<T> = values.wrapped()
        append(items)
    }
    
    public func append(_ values: Entities<T>) {
        self.identifiers.append(contentsOf: values.identifiers)
        self.entities.append(contentsOf: values.get())
    }
    
    public func sorted(_ sorted: ((T, T)->(Bool))) {
        self.entities = entities.sorted(by: { itemA, itemB in
            guard let entityA = itemA.entity, let entityB = itemB.entity else {return false}
            return sorted(entityA, entityB)
        })
    }
}
