//
//  SpotifyishApp.swift
//  Spotifyish
//
//  Created by Julia  Smith on 3/25/25.
//

import SwiftUI

@main
struct SpotifyishApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if let _ = UserDefaults.standard.string(forKey: "signedInUsername") {
               
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                
                WelcomeViewControllerWrapper()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}

