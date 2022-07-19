//
//  CoreDataHelper.swift
//  Bliss
//
//  Created by Joey BARBIER on 15/07/2021.
//

import Foundation
import UIKit
import CoreData

public class CoreDataHelper {
    public static var persistentContainer: NSPersistentContainer? = nil

    public static var context: NSManagedObjectContext? = {
        //Log.coreData.add("Info - get context")
        guard let persistentContainer = persistentContainer else {
            return nil
        }
        let context = persistentContainer.viewContext
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        context.automaticallyMergesChangesFromParent = true
        context.undoManager = nil
        context.shouldDeleteInaccessibleFaults = true

        return context
    }()

    static var contextBck: NSManagedObjectContext? = {
        //Log.coreData.add("Info - get context")
        guard let persistentContainer = persistentContainer else {
            return nil
        }
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        context.automaticallyMergesChangesFromParent = true
        context.undoManager = nil
        context.shouldDeleteInaccessibleFaults = true

        return context
    }()
}

// MARK: - Save
extension CoreDataHelper {
    public static func save(forceContext context: NSManagedObjectContext? = nil) {
        //Log.coreData.add("Info - save called")
        let context = context ?? self.context
        if context?.hasChanges ?? false {
            do {
                try context?.save()
                context?.reset()
            } catch (let error) {
                let _ = error as NSError
                //ErrorHelper.shared.addCustom(withMessage: "CoreData - Save : \(nserror.description)", identifier: "CoreData_save")
                //Log.coreData.add("Error - save")
            }
        }
    }
}

