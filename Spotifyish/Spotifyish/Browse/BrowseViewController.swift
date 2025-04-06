import MusicKit
import SwiftUI

struct BrowseViewController: View {
  @EnvironmentObject var globalScreenManager: GlobalScreenManager
  @EnvironmentObject var browseViewModel: BrowseViewModel
  @State private var selectedChart: GenreChart?
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

  private var contentView: some View {
    SongList(songs: Array(browseViewModel.searchSongs?.songs ?? []))
      .scrollDismissesKeyboard(.immediately)
      .scrollContentBackground(.hidden)
      .alert(isPresented: $browseViewModel.showError) {
        Alert(
          title: Text("Error"),
          message: Text(browseViewModel.errorMessage ?? "Unknown error"),
          dismissButton: .default(Text("OK"))
        )
      }
  }

  var body: some View {
    VStack {
      if browseViewModel.loading {
        loadingView
      } else if !browseViewModel.loading && !browseViewModel.searchActive {
        genreCardView
      } else {
        contentView
      }
    }.safeAreaPadding(
      EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0)
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .navigationTitle("Browse Music")
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
                  await browseViewModel.fetchCatalogSearchResults()
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

  private var genreCardView: some View {

    ScrollView {  // NOTE - A scroll view automatically places the images at the top of the page so you don't need to worry about alignment
      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
        ForEach(
          Array(browseViewModel.genreCharts.enumerated()),
          id: \.element.id
        ) { index, genreChart in
          GenreChartCard(genreChart: genreChart).onTapGesture {
            selectedChart = genreChart
          }
        }
      }.navigationDestination(item: $selectedChart) { selection in
        SongList(songs: selection.chart?.songCharts.flatMap(\.items) ?? [])
      }
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
