import MusicKit
//https://stackoverflow.com/questions/76832159/searchable-make-the-search-box-stick-to-the-top-without-moving-when-focused
import SwiftUI

//https://medium.engineering/how-to-do-pagination-in-swiftui-04511be7fbd1

//https://developer.apple.com/documentation/swiftui/adding-a-search-interface-to-your-app

struct RecommendationViewController: View {
  @ObservedObject var globalScreenManager = GlobalScreenManager.shared
  @EnvironmentObject var recommendationViewModel: RecommendationViewModel
  @State var selectedPlaylist: Playlist?
  private func makeMessageView(_ message: String) -> some View {
    Text(message)
  }

  private var loadingView: some View {
    VStack {
      ProgressView()
      Text("Loading recommendations..")
    }
  }

  var body: some View {
    VStack {
      if recommendationViewModel.loading
        && recommendationViewModel.playlists.isEmpty
      {
        loadingView
      } else if recommendationViewModel.loaded
        && recommendationViewModel.playlists.isEmpty
      {
        makeMessageView("No recommendations available")
      } else {
        contentView
      }

    }.navigationTitle("Recommendations")
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .alert(isPresented: $recommendationViewModel.showError) {
        Alert(
          title: Text("Error"),
          message: Text(
            recommendationViewModel.errorMessage ?? "Unknown error"
          ),
          dismissButton: .default(Text("OK"))
        )
      }
  }

  private var playlistSongView: some View {
    VStack {
      if recommendationViewModel.loading
        && recommendationViewModel.playlists.isEmpty
      {
        VStack {
          ProgressView()
          Text("Loading recommended songs..")
        }
      } else if recommendationViewModel.loaded
        && recommendationViewModel.songs.isEmpty
      {
        makeMessageView("No songs available in playlist")
      } else {
        SongList(songs: recommendationViewModel.songs)
      }
    }.onAppear {
      if (selectedPlaylist == nil) { return }
      Task {
        await recommendationViewModel.getRecommendationPlaylist(id: selectedPlaylist!.id)
      }
    }.onDisappear {
      recommendationViewModel.songs = []
    }
  }

  private var contentView: some View {
    ScrollView {  // NOTE - A scroll view automatically places the images at the top of the page so you don't need to worry about alignment
      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
        ForEach(
          Array(recommendationViewModel.playlists.enumerated()),
          id: \.element.id
        ) { index, playlist in
          ItemCard(artwork: playlist.artwork, title: playlist.name)
            .onTapGesture {
              selectedPlaylist = playlist
            }
        }
      }.navigationDestination(item: $selectedPlaylist) { selection in
        playlistSongView
      }
    }
    .safeAreaPadding(
      EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0)
    )
  }
}
