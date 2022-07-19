//
//  Array+Order.swift
//  CoreDataWrapper
//
//  Created by Joey Barbier on 26/07/2021.
//

import Foundation

extension Array where Array.Element: EntityProtocol {
    public func identifiers() -> [String]{
        return self.sort().map({$0.identifier})
    }
    
    public func wrapped<T: EntityProtocol>() -> Entities<T> {
        let ids = self.map({$0.identifier})
        return Entities(withIdentifier: ids) { entities in
            let ordered = entities.sort()
            return (ordered.map({$0.identifier}), ordered)
        }
    }
    
    public func sort() -> Self {
        return self.sorted(by: { (a:EntityProtocol, b:EntityProtocol) -> Bool in
            return a.identifier < b.identifier
        })
    }
}
