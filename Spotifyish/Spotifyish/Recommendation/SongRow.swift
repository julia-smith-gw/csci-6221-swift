//
//  SongRow.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 07/04/25.
//

import SwiftUI

struct SongRow: View {
    let song: Songs
    @EnvironmentObject var playerManager: PlayerManager

    var body: some View {
        HStack(spacing: 16) {
            Image(song.imageName)
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(song.name)
                    .font(.headline)
                Text(song.artistName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Button(action: {
                if playerManager.isPlaying(song: song) {
                    playerManager.stop()
                } else {
                    playerManager.play(song: song)
                }
            }) {
                Image(systemName: playerManager.isPlaying(song: song) ? "pause.circle.fill" : "play.circle.fill")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .foregroundColor(.spotifyGreen)
            }
        }
        .padding(.vertical, 8)
    }
}
