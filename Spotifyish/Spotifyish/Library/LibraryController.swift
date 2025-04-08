import MusicKit
import SwiftUI

//https://stackoverflow.com/questions/76832159/searchable-make-the-search-box-stick-to-the-top-without-moving-when-focused
//https://medium.engineering/how-to-do-pagination-in-swiftui-04511be7fbd1
//https://developer.apple.com/documentation/swiftui/adding-a-search-interface-to-your-app

struct LibraryController: View {
  @ObservedObject var globalScreenManager = GlobalScreenManager.shared
  @ObservedObject var libraryViewModel = LibraryViewModel.shared
  
  var body: some View {
    VStack {
      if libraryViewModel.loading
        && libraryViewModel.currentlyVisibleSongs.isEmpty
      {
        LoadingView(loadingText: "Loading library...")
      } else if libraryViewModel.loaded
        && libraryViewModel.currentlyVisibleSongs.isEmpty
      {
        Text("No songs found")
      } else {
        contentView
      }

    }.navigationTitle("Library")
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .safeAreaInset(
      edge: .top,
      content: {
        ZStack {
          Rectangle()
            .fill(.background)
            .overlay {

              CustomSearchBar(
                searchText: $libraryViewModel.searchTerm,
                submitAction: {
                  await libraryViewModel.searchLibrary()
                },
                searchActive: $libraryViewModel.searchActive
              )
              .offset(y: 30)
            }
            .frame(maxHeight: 120)
            .offset(y: -60)
        }
      }
    )

  }

  private var contentView: some View {
    SongList(songs: libraryViewModel.currentlyVisibleSongs, fromLibrary: true)
        .scrollDismissesKeyboard(.immediately)
        .scrollContentBackground(.hidden)
        .alert(isPresented: $libraryViewModel.showError) {
          Alert(
            title: Text("Error"),
            message: Text(libraryViewModel.errorMessage ?? "Unknown error"),
            dismissButton: .default(Text("OK"))
          )
        }
    }
}
