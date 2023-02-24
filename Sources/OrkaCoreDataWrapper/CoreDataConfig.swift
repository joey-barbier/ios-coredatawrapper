//
//  CoreDataConfig.swift
//  CoreDataWrapper
//
//  Created by Joey Barbier on 26/07/2021.
//

import Foundation
import CoreData

@objc
public class CoreDataConfig: NSObject {
    
    @objc
    @discardableResult
    public init(with container: NSPersistentContainer) {
        CoreDataHelper.persistentContainer = container
    }
    
}
