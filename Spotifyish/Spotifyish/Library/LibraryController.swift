import MusicKit
//https://stackoverflow.com/questions/76832159/searchable-make-the-search-box-stick-to-the-top-without-moving-when-focused
import SwiftUI

// SHREEYA/JULIA
//https://medium.engineering/how-to-do-pagination-in-swiftui-04511be7fbd1

//https://developer.apple.com/documentation/swiftui/adding-a-search-interface-to-your-app

struct LibraryController: View {
  @EnvironmentObject var globalScreenManager: GlobalScreenManager
  @EnvironmentObject var libraryViewModel: LibraryViewModel
  @State private var songsLoading: Bool = false

  private func makeMessageView(_ message: String) -> some View {
    Text(message)
  }

  private var loadingView: some View {
    VStack {
      ProgressView()
      Text("Loading library...")
    }
  }

  var body: some View {
    VStack {
      if libraryViewModel.loading
        && libraryViewModel.currentlyVisibleSongs.isEmpty
      {
        loadingView
      } else if libraryViewModel.loaded
        && libraryViewModel.currentlyVisibleSongs.isEmpty
      {
        makeMessageView("No songs found")
      } else {
        contentView
      }

    }.safeAreaInset(
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
              .offset(y: 40)
            }
            .frame(maxHeight: 120)
            .offset(y: -60)
        }
      }
    )

  }

  private var contentView: some View {
    NavigationStack {
      LibrarySongList()
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
}
