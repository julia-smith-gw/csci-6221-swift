//
//  SongRow.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 07/04/25.
//

import SwiftUI

struct SongRow: View {
    var songs: Songs

    @State private var isPlaying = false

    var body: some View {
        HStack(spacing: 16) {
            Image(songs.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(songs.name)
                    .font(.headline)

                Text(songs.artistName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Button(action: togglePlay) {
                Image(systemName: isPlaying ? "stop.circle.fill" : "play.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.spotifyGreen)
            }
        }
        .padding(.vertical, 8)
    }

    func togglePlay() {
        if isPlaying {
            AudioManager.shared.stop()
            isPlaying = false
        } else {
            AudioManager.shared.play(audioFileName: songs.audioFileName)
            isPlaying = true
        }

        // Optional: If you want to notify other rows to update, you'll need a more global state solution like ObservableObject or @EnvironmentObject.
    }
}
