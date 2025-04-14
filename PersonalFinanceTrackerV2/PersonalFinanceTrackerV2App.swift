//
//  PersonalFinanceTrackerV2App.swift
//  PersonalFinanceTrackerV2
//
//  Created by Bruno Marques on 13/04/25.
//

import SwiftUI

@main
struct PersonalFinanceTrackerV2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
