//
//  SpotifyishApp.swift
//  Spotifyish
//
//  Created by Julia  Smith on 3/21/25.
//

import SwiftUI

@main
struct SpotifyishApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
