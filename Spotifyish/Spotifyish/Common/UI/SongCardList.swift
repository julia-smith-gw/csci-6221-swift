import MusicKit
//https://medium.com/p/4af42f4503db
//  Created by Julia  Smith on 3/25/25.
//
import SwiftUI

//
//  SongCardList.swift
//  Spotifyish
// https://stackoverflow.com/questions/66494887/swiftui-list-add-empty-space-at-the-bottom

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
  @ObservedObject var audioPlayerViewModel = AudioPlayerViewModel.shared
  @StateObject var selectionData: SelectionData = SelectionData()
  var fromLibrary: Bool = false
  var body: some View {
    List {
      ForEach(Array(songs.enumerated()), id: \.element.id) { index, song in
        SongCard(
          song: song,
          tapAction: {
            if audioPlayerViewModel.song == nil
              || (audioPlayerViewModel.song != nil
                && (song.title != audioPlayerViewModel.song?.title
                  && song.artistName != audioPlayerViewModel.song?.artistName))
            {
              Task {
                await audioPlayerViewModel.changeSong(
                  song: song,
                  songIndex: index,
                  fromLibrary: fromLibrary,
                  playlist: songs
                )
              }
            }
          },
          fromLibrary: fromLibrary
        )
        .listRowSeparator(Visibility.hidden)
      }
    }
    .safeAreaPadding(
      EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0)
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
