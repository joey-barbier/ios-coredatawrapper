//
//  CoreDataHelper.swift
//  Bliss
//
//  Created by Joey Barbier on 02/10/2019.
//  Copyright © 2019 prismamedia. All rights reserved.
//

import Foundation
import CoreData

public final class CoreDataFinder<T: EntityProtocol> {
    private var limitElement = 900
    
    // MARK: - Generic search Entity
    public func findBy<T: EntityProtocol>(id identifier: String, forceContext: NSManagedObjectContext? = nil) -> T? {
        //Log.coreData.add("Info - getEntity called")
        var result: T? = nil
        guard let context = forceContext ?? CoreDataHelper.context else {
            return nil
        }
        let request = NSFetchRequest<T>(entityName: T.entityName)
        request.predicate = NSPredicate(format: "\(T.identifierName) == %@", identifier)
        request.returnsObjectsAsFaults = false
        
        do {
            result = try context.fetch(request).first
        } catch {
            //Log.coreData.add("CoreData - getEntity - \(error.localizedDescription)")
        }
        
        return result
    }
    
    public func findBy<T: EntityProtocol>(fromParams params: [String: [String]],
                                          limit: Int? = nil,
                                          sortBy: (name: String, ascending: Bool)? = nil) -> [T]
    {
        //Log.coreData.add("Info - getEntities called")
        
        if let ids = params[T.identifierName], ids.count > limitElement {
            return self.getManyElement(fromParams: params,
                                       limit: limit,
                                       sortBy: sortBy)
        }
        
        var result: [T] = []
        guard let context = CoreDataHelper.context else {
            return result
        }
        let request = NSFetchRequest<T>(entityName: T.entityName)
        
        // get ids :
        var predicates: [NSPredicate] = []
        for (key,values) in params {
            var predicatesKey: [NSPredicate] = []
            for value in values {
                // for the key, you must use "concatenation", to avoid formatting the data
                predicatesKey.append(NSPredicate(format: "\(key) == %@", value))
            }
            predicates.append(NSCompoundPredicate.init(type: .or, subpredicates: predicatesKey))
        }
        
        let predicateCompound = NSCompoundPredicate.init(type: .and, subpredicates: predicates)
        
        request.predicate = predicateCompound
        request.returnsObjectsAsFaults = false
        
        if let limit = limit {
            request.fetchLimit = limit
        }
        
        if let sortBy = sortBy {
            let sortDescriptor = NSSortDescriptor(key: sortBy.name, ascending: sortBy.ascending)
            let sortDescriptors = [sortDescriptor]
            request.sortDescriptors = sortDescriptors
        }
        
        do {
            result = try context.fetch(request)
        } catch {
            //Log.coreData.add("CoreData - getEntity - \(error.localizedDescription)")
        }
        return result
    }
    
    public func findAll<T: EntityProtocol>() -> [T]? {
        //Log.coreData.add("Info - getEntities (all) called")
        var result: [T]? = nil
        guard let context = CoreDataHelper.context else {
            return nil
        }
        let request = NSFetchRequest<T>(entityName: T.entityName)
        request.returnsObjectsAsFaults = false
        do {
            result = try context.fetch(request)
        } catch {
            //Log.coreData.add("CoreData - getEntities - \(error.localizedDescription)")
        }
        return result
    }
    
    public func drop(withEntityName entityName: String, withContext: NSManagedObjectContext? = nil) {
        //Log.coreData.add("Info - DropEntitie called")
        guard let context = withContext ?? CoreDataHelper.context else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch _ {
            //Log.error.add("Detele all data in \(entityName) error : \(error)")
        }
    }
}

// MARK: - private
extension CoreDataFinder {
    private func getManyElement<T: EntityProtocol>(fromParams params: [String: [String]],
                                                   limit: Int? = nil,
                                                   sortBy: (name: String, ascending: Bool)? = nil) -> [T] {
        var ids = params[T.identifierName] ?? []
        var result = [T]()
        
        while !ids.isEmpty {
            let tempIds = ids.prefix(limitElement)
            let rangeTemp = 0...(tempIds.count - 1)
            ids.removeSubrange(rangeTemp)
            
            var paramsTemp = params
            paramsTemp[T.identifierName] = Array(tempIds)
            
            result.append(contentsOf: findBy(fromParams: paramsTemp, limit: limit, sortBy: sortBy))
        }
        
        return result
    }
}

// MARK: - static
extension CoreDataFinder {
    static func save(forceContext context: NSManagedObjectContext? = nil) {
        //Log.coreData.add("Info - save called")
        let context = context ?? context
        if context?.hasChanges ?? false {
            do {
                try context?.save()
                context?.reset()
            } catch (_) {
                //                let nserror = error as NSError
                //                ErrorHelper.shared.addCustom(withMessage: "CoreData - Save : \(nserror.description)",
                //                                             identifier: "CoreData_save")
                //                Log.coreData.add("Error - save")
            }
        }
    }
}
