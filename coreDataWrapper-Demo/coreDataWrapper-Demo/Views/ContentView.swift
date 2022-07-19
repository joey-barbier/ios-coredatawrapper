//
//  ContentView.swift
//  coreDataWrapper-Demo
//
//  Created by Joey BARBIER on 19/07/2022.
//

import SwiftUI
import CoreData
import OrkaCoreDataWrapper

struct ContentView: View {
    
    @State private var items: Entities<User> = Entities<User>()
    
    var body: some View {
        NavigationView {
            User.List(users: items, updateUsers: updateUsers)
                .task {
                    updateUsers()
                }
            Text("Select an item")
        }
    }
    
    private func updateUsers() {
        let users: [User] = User.bdd.findAll() ?? []
        items = users.sort().wrapped()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .task {
                CoreDataConfig.init(with: PersistenceController.shared.container)
            }
    }
}
