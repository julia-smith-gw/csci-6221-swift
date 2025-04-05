//
//  LibrarySongList.swift
//  Spotifyish
//
//  Created by Julia  Smith on 4/5/25.
//


import MusicKit
import SwiftUI

// https://medium.com/p/4af42f4503db
// https://stackoverflow.com/questions/66494887/swiftui-list-add-empty-space-at-the-bottom

struct LibrarySongSelection: Hashable {
  var song: MusicKit.Song
  var index: Int
}

class LibrarySelectionData: ObservableObject {
  @Published var selection: SongSelection? = nil
}

struct LibrarySongList: View {

  @State private var selectedSong: MusicKit.Song?
  @State private var selectedSongIndex: Int?
  @EnvironmentObject private var libraryViewModel: LibraryViewModel
  @StateObject var selectionData: SelectionData = SelectionData()
  var body: some View {
    NavigationStack {
      List {
        ForEach(Array(libraryViewModel.currentlyVisibleSongs.enumerated()), id: \.element.id) { index, song in
          SongCard(song: song).onTapGesture {
            selectionData.selection = SongSelection(song: song, index: index)
          }.onAppear {
            Task {
              await libraryViewModel.loadMoreItemsIfNeeded(currentIndex: index)
            }
          }
          .listRowSeparator(Visibility.hidden)
        }
        if libraryViewModel.loading {
          HStack {
            Spacer()
            ProgressView()
            Spacer()
          }
        }
      }
      .safeAreaPadding(
        EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0)
      )
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .navigationDestination(item: $selectionData.selection) { selection in

        PlayerView(
          song: selection.song,
          songIndex: selection.index,
          playerQueue: libraryViewModel.currentlyVisibleSongs,
          startNew: true
        )
      }
    }
  }
}
