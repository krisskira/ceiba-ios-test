//
//  CeibaApp.swift
//  Ceiba
//
//  Created by Crhistian David Vergara Gomez on 11/05/23.
//

import SwiftUI

@main
struct CeibaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
