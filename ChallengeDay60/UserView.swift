//
//  UserView.swift
//  ChallengeDay60
//
//  Created by Blake McAnally on 2/11/21.
//

import SwiftUI

struct UserView: View {
    
    var user: User
    
    var tags: [String] {
        if let set = user.tags as? Set<Tag> {
            return set.compactMap { $0.name }
        }
        return []
    }
    
    var friends: [String] {
        if let set = user.friends as? Set<User> {
            return set.compactMap { $0.name }
        }
        return []
    }
    
    let columns: [GridItem] = [
        GridItem(.flexible(minimum: 30, maximum: .infinity)),
        GridItem(.flexible(minimum: 30, maximum: .infinity)),
        GridItem(.flexible(minimum: 30, maximum: .infinity)),
        GridItem(.flexible(minimum: 30, maximum: .infinity)),
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                Text("Age \(user.age)")
                    .font(.subheadline)
                Text(user.about ?? "")
                    .font(.body)
                Spacer()
                Text("Friends")
                    .font(.headline)
                LazyVGrid(columns: columns) {
                    ForEach(friends, id: \.self) { friend in
                        ZStack {
                            Capsule(style: .continuous)
                                .foregroundColor(.blue)
                            Text(friend)
                                .font(.footnote)
                        }
                    }
                }
                
                Text("Tags")
                    .font(.headline)
                LazyVGrid(columns: columns) {
                    ForEach(tags, id: \.self) { tag in
                        ZStack {
                            Capsule(style: .continuous)
                                .foregroundColor(.green)
                            Text(tag)
                                .font(.footnote)
                        }
                    }
                }
            }.padding()
        }.navigationTitle(user.name ?? "")
    }
}

