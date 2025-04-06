// NGOC
import SwiftUI

struct LikedController: View {
  @EnvironmentObject var likedViewModel: LikedViewModel
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
      } else if likedViewModel.loaded && likedViewModel.songs?.count == 0 {
        Text("No liked songs")

      } else {
        Text("bro???")
        SongList(songs: Array(likedViewModel.songs ?? []))
      }
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
      .navigationTitle("Browse Music")
  }
}
