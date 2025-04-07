//
//  SpotifyPlaylistView.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 06/04/25.
//

import SwiftUI
import Foundation

struct SpotifyPlaylistView: View {
    var title: String
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("Playlist: \(title)")
                .foregroundColor(.white)
                .font(.largeTitle.bold())
        }
    }
}
