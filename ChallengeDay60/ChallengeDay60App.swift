//
//  ChallengeDay60App.swift
//  ChallengeDay60
//
//  Created by Blake McAnally on 2/11/21.
//

import SwiftUI

@main
struct ChallengeDay60App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
