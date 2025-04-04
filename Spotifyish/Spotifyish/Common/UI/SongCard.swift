// Source: https://www.youtube.com/watch?v=NvE3SaGGurQ
//  SongCard.swift
//  Spotifyish
//
//  Created by Julia  Smith on 3/25/25.
//

import SwiftUI

struct SongCard: View {
    @Binding var song: Song
    var body: some View {
        HStack {
            Image(song.imageName)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(width: 50, height: 50)
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 2) {
                Text(self.song.name).font(.headline.bold())
                Text(self.song.artistName).font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            
            NavigationLink {
                PlayerView(song: $song)
            } label: {
                
            }
            
            
        }
        .padding(.bottom, 0)

    }
}
