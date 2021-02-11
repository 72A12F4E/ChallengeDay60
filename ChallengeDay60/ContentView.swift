//
//  ContentView.swift
//  ChallengeDay60
//
//  Created by Blake McAnally on 2/11/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext)
    private var viewContext

    @FetchRequest(entity: User.entity(), sortDescriptors: [
        NSSortDescriptor(key: "isActive", ascending: false),
        NSSortDescriptor(key: "name", ascending: true)
    ])
    var users: FetchedResults<User>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users) { user in
                    NavigationLink(destination: UserView(user: user)) {
                        HStack {
                            if user.isActive {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.gray)
                            }
                            
                            Text(user.name ?? "no name")
                        }
                    }
                }
            }.navigationBarTitle("FriendFace")
        }
    }
}
