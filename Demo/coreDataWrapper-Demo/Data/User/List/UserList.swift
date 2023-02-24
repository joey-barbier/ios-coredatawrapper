//
//  UserList.swift
//  coreDataWrapper-Demo
//
//  Created by Joey BARBIER on 19/07/2022.
//

import SwiftUI
import OrkaCoreDataWrapper

extension User {
    struct List: View {
        var users: Entities<User>
        var updateUsers: (()->())
        
        var body: some View {
            SwiftUI.List {
                ForEach(users.get(), id: \.identifier) { item in
                    User.Row(user: item)
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }
}

extension User.List {
    private func addItem() {
        withAnimation {
            let _ = User(identifier: "\(Date().timeIntervalSince1970)")
            updateUsers()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.forEach({ index in
                guard let item = users.get(at: index), let entity = item.entity else {return}
                CoreDataHelper.context?.delete(entity)
            })
            CoreDataHelper.save()
            updateUsers()
        }
    }
}
