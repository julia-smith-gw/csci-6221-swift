//
//  SongCardList.swift
//  Spotifyish
// https://stackoverflow.com/questions/66494887/swiftui-list-add-empty-space-at-the-bottom
//  Created by Julia  Smith on 3/25/25.
//
import SwiftUI
import MusicKit

struct SongList: View {
  var songs: [MusicKit.Song]

  @State private var selectedSong: MusicKit.Song?
  var body: some View {
    NavigationStack {
        List(songs, id: \.self.id) { song in
          SongCard(song: song).onTapGesture {
            selectedSong=song
          }.listRowSeparator(Visibility.hidden)
        }.safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
              .navigationDestination(item: $selectedSong) { selection in
                PlayerView(song: selection, startNew: true)
                var _ = print("go to player")
        }
    }
  }
}
