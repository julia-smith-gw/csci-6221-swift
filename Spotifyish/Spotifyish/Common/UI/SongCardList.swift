//
//  SongCardList.swift
//  Spotifyish
// https://stackoverflow.com/questions/66494887/swiftui-list-add-empty-space-at-the-bottom
//  Created by Julia  Smith on 3/25/25.
//
import SwiftUI

struct SongList: View {
    @Binding var songs: [Song]
    @State private var selectedSong: Song?

    var body: some View {
        NavigationStack {
            List($songs, id: \.self.id) { $song in
                SongCard(song: $song).onTapGesture {
                    selectedSong=song
                }
            }.safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
                .navigationDestination(item: $selectedSong) { selection in
                    PlayerView(song: Binding(get: { selection }, set: { selectedSong = $0 }), startNew: true)
                }
        }
    }
}
