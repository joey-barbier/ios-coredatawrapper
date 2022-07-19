//
//  Collection+Safe.swift
//  CoreDataWrapper
//
//  Created by Joey Barbier on 26/07/2021.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
