// NGOC
import SwiftUI

struct LikedController: View {
  @ObservedObject var likedViewModel = LikedViewModel.shared
  
  private func makeMessageView(_ message: String) -> some View {
    Text(message)
  }

  private var loadingView: some View {
    VStack {
      ProgressView()
      Text("Loading liked songs...")
    }
  }

  var body: some View {
    NavigationStack {
      if likedViewModel.loading {
        loadingView
      } else if likedViewModel.loaded && likedViewModel.songs.count == 0 {
        Text("No liked songs")
      } else {
        SongList(songs: likedViewModel.songs, fromLibrary: true)
      }
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
      .navigationTitle("Liked Songs")
  }
}
