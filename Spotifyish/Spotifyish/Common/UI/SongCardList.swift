import MusicKit
import SwiftUI

//https://medium.com/p/4af42f4503db
// https://stackoverflow.com/questions/66494887/swiftui-list-add-empty-space-at-the-bottom

struct SongList: View {
  var songs: [MusicKit.Song]
  @State private var selectedSong: MusicKit.Song?
  @State private var selectedSongIndex: Int?
  @ObservedObject var audioPlayerViewModel = AudioPlayerViewModel.shared
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
