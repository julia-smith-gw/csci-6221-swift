//
//  SongsViewModel.swift
//  Spotifyish
//
//  Created by Ngoc Phan on 3/29/25.
//

import SwiftUI

// Make a global shared instance so all views can access it
class SongsViewModel: ObservableObject {
    @Published var songs: [Song]
    static let shared = SongsViewModel()

    init() {
        self.songs = []
        loadSongs()
    }
    
    private func loadSongs() {
        self.songs = songs
        print("Songs array initialized in ViewModel: \(self.songs)")    // ISSUE: songs array is empty - any reference to SongsViewModel.songs is an empty array
    }
}
/*
class SongsViewModel: ObservableObject {
    @Published var songs: [Song]
    
    // Private initializer
    private init(songs: [Song]) {
        self.songs = songs
    }

    // Static function to create the shared instance
    static func initializeShared() -> SongsViewModel {
        return SongsViewModel(songs: songs)  // Pass the global songs array here
    }

    // Shared instance (lazy initialization)
    static var shared: SongsViewModel = {
        return initializeShared()  // Using the initialization function
    }()
}*/
