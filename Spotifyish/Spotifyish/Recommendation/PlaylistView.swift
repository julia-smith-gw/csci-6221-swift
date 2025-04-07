//
//  PlaylistView.swift
//  Spotifyish
//
//  Created by Sumairah Rahman on 06/04/25.
//

import SwiftUI

struct PlaylistView: View {
    var mood: Mood

    let allSongs: [Songs] = [
        Songs(name: "Tequilla", genre: "Country", artistName: "Dan + Shay", imageName: "cover5", audioFileName: "Song5"),
        Songs(name: "Stargazing", genre: "Pop", artistName: "Myles Smith", imageName: "cover6", audioFileName: "Song6"),
        Songs(name: "Remind Me To Forget", genre: "Dance", artistName: "Miguel, Kygo", imageName: "cover7", audioFileName: "Song7"),
        Songs(name: "Happy!", genre: "Pop", artistName: "Pharell Williams", imageName: "cover9", audioFileName: "Song9"),
        Songs(name: "Go Your Own Way", genre: "Rock", artistName: "FleetWood Mac", imageName: "cover10", audioFileName: "Song10"),
        Songs(name: "Cruel Summer", genre: "Pop", artistName: "Taylor Swift", imageName: "cover11", audioFileName: "Song11"),
        Songs(name: "Lil Boo Thang", genre: "Pop", artistName: "Paul Russell", imageName: "cover8", audioFileName: "Song8"),
        Songs(name: "All I Ask", genre: "Pop", artistName: "Adele", imageName: "cover12", audioFileName: "Song12"),
        Songs(name: "We Can't Be Friends", genre: "Pop", artistName: "Ariana Grande", imageName: "cover13", audioFileName: "Song13"),
        Songs(name: "Meant To Be", genre: "Country", artistName: "Bebe Rexha", imageName: "cover15", audioFileName: "Song15"),
        Songs(name: "Chop Suey!", genre: "Metal", artistName: "System of a Down", imageName: "cover15", audioFileName: "Song15"),
        Songs(name: "...Another Chance", genre: "Jazz", artistName: "Philly Jones", imageName: "cover1", audioFileName: "Song1"),
        Songs(name: "Yellow", genre: "Alternative Rock", artistName: "Coldplay", imageName: "cover2", audioFileName: "Song2"),
        Songs(name: "Relax", genre: "Beats", artistName: "Epidemic", imageName: "cover3", audioFileName: "Relax")
    ]

    var filteredSongs: [Songs] {
        allSongs.filter { song in
            song.genre.localizedCaseInsensitiveContains(mood.title) ||
            song.genre.localizedCaseInsensitiveContains(mood.category)
        }
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            ScrollView {
                LazyVStack(spacing: 12) {
                    AsyncImageStretchyHeader(imageName: mood.image)
                        .frame(height: 300)

                    PlaylistDescriptionCell(
                        descriptionText: mood.description,
                        userName: "Swift",
                        subheadline: mood.category,
                        onAddToPlaylistPressed: { print("Add to playlist") },
                        onDownloadPressed: { print("Download") },
                        onSharedPressed: { print("Share") },
                        onEllipsisPressed: { print("More Options") },
                        onShufflePressed: { print("Shuffle") },
                        onPlayPressed: { print("Play") }
                    )
                    .padding(.horizontal, 16)

                    if filteredSongs.isEmpty {
                        Text("No songs available for this mood.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(filteredSongs) { song in
                            SongRow(songs: song)
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}




#Preview {
    PlaylistView(mood: Mood.mock)
}

