import MusicKit
//
//  SongCardList.swift
//  Spotifyish
// https://stackoverflow.com/questions/66494887/swiftui-list-add-empty-space-at-the-bottom
//  Created by Julia  Smith on 3/25/25.
//
import SwiftUI

struct SongSelection: Hashable {
    var song: MusicKit.Song
    var index: Int
}

class SelectionData: ObservableObject {
  @Published var selection: SongSelection? = nil
}

struct SongList: View {
  var songs: [MusicKit.Song]

  @State private var selectedSong: MusicKit.Song?
  @State private var selectedSongIndex: Int?
  @StateObject var selectionData: SelectionData = SelectionData()
  var body: some View {
    NavigationStack {
      List {
        ForEach(Array(songs.enumerated()), id: \.element.id) { index, song in
          SongCard(song: song).onTapGesture {
            selectionData.selection = SongSelection(song: song, index: index)
          }.listRowSeparator(Visibility.hidden)
        }
      }.safeAreaPadding(
        EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0)
      )
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .navigationDestination(item: $selectionData.selection) { selection in

        PlayerView(
          song: selection.song,
          songIndex: selection.index,
          playerQueue: songs,
          startNew: true
        )

      }
    }
  }
}
