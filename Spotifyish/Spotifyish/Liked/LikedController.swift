// NGOC
import SwiftUI

struct LikedController: View {
  @ObservedObject var likedViewModel = LikedViewModel.shared
  
  var body: some View {
    NavigationStack {
      if likedViewModel.loading {
        LoadingView(loadingText: "Loading liked songs...")
      } else if likedViewModel.loaded && likedViewModel.songs.count == 0 {
        Text("No liked songs")
      } else {
        SongList(songs: likedViewModel.songs, fromLibrary: true)
      }
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
      .navigationTitle("Liked Songs")
  }
}
