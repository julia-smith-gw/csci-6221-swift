//
//  PlaylistView.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 06/04/25.
//

import SwiftUI

struct PlaylistView: View {
    var mood: Mood // <- This is your renamed Mood to avoid ambiguity

    var body: some View {
        ZStack {
            Color.spotifyBlack.ignoresSafeArea()

            ScrollView {
                LazyVStack(spacing: 12) {
                    // ✅ You pass the mood values here
                    PlaylistHeaderCell(
                        height: 250,
                        title: mood.title,
                        subtitle: mood.description,
                        imageName: mood.image
                    )

                    PlaylistDescriptionCell(
                        descriptionText: mood.description,
                        userName: "Swift",
                        subheadline: mood.category,
                        onAddToPlaylistPressed: nil,
                        onDownloadPressed: nil,
                        onSharedPressed: nil,
                        onEllipsisPressed: nil,
                        onShufflePressed: nil,
                        onPlayPressed: nil
                    )
                    .padding(.horizontal, 16)
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    PlaylistView(mood: Mood.mock)
}

