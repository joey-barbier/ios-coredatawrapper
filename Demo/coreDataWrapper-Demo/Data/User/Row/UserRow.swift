//
//  UserRow.swift
//  coreDataWrapper-Demo
//
//  Created by Joey BARBIER on 19/07/2022.
//

import SwiftUI
import OrkaCoreDataWrapper

extension User {
    struct Row: View {
        var user: Entity<User>
        
        var body: some View {
            if let entity = user.entity {
                Text(entity.identifier)
            }
        }
    }
}
