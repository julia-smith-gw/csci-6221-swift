import MusicKit
import SwiftUI

//https://ix76y.medium.com/creating-a-image-card-in-swift-ui-beginner-tutorial-2881b4420ea3

struct BrowseViewController: View {
  @EnvironmentObject var globalScreenManager: GlobalScreenManager
  @EnvironmentObject var browseViewModel: BrowseViewModel
  @State private var selectedChart : GenreChart?
  @State private var songsLoading: Bool = false

  private func makeMessageView(_ message: String) -> some View {
    Text(message)
  }

  private var loadingView: some View {
    VStack {
      ProgressView()
      Text("Loading browsing information...")
    }
  }

  var body: some View {
    NavigationStack {
        var _ = print("LOADING?>>> \(browseViewModel.loading)")
        if browseViewModel.loading {
          loadingView
        } else {
          contentView
        }
    }.navigationTitle("Browse Music")
      .safeAreaInset(
        edge: .top,
        content: {
          ZStack {
            Rectangle()
              .fill(.background)
              .overlay {

                CustomSearchBar(
                  searchText: $browseViewModel.searchTerm,
                  submitAction: {
                    //await browseViewModel.searchCatalog()
                  },
                  searchActive: $browseViewModel.searchActive
                )
                .offset(y: 40)
              }
              .frame(maxHeight: 120)
              .offset(y: -60)
          }
        }
      )
  }

  private var contentView: some View {
    
    ScrollView {  // NOTE - A scroll view automatically places the images at the top of the page so you don't need to worry about alignment
      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
        ForEach(
          Array(browseViewModel.genreCharts.enumerated()),
          id: \.element.id
        ) { index, genreChart in
          GenreChartCard(genreChart: genreChart).onTapGesture {
            selectedChart=genreChart
          }
        }
      }
    }
    .navigationDestination(item: $selectedChart) { selection in
      SongList(songs: selection.chart?.songCharts.flatMap(\.items) ?? [])
    }
    .safeAreaPadding(
      EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0)
    )
    .alert(isPresented: $browseViewModel.showError) {
      Alert(
        title: Text("Error"),
        message: Text(browseViewModel.errorMessage ?? "Unknown error"),
        dismissButton: .default(Text("OK"))
      )
    }
  }
}
