import MusicKit
// SHREEYA/JULIA
//https://medium.engineering/how-to-do-pagination-in-swiftui-04511be7fbd1
import SwiftUI

struct LibraryController: View {
  var songs: [MusicKit.Song] = []
  @EnvironmentObject var globalScreenManager: GlobalScreenManager
  @EnvironmentObject var libraryViewModel: SongListViewModel
  @State private var songsLoading: Bool = false

  private func makeMessageView(_ message: String) -> some View {
    Text(message)
  }

  private var loadingView: some View {
    VStack{
      ProgressView()
      Text("Loading library...")
    }
  }

  var body: some View {
    if libraryViewModel.loading {
      loadingView
    } else if libraryViewModel.loaded && libraryViewModel.songs.isEmpty {
      makeMessageView("No songs found")
    } else {
      contentView
    }
  }

  private var contentView: some View {
    VStack{
      SongList(songs: libraryViewModel.loaded ? libraryViewModel.songs : [])
      if (!libraryViewModel.loading && !libraryViewModel.loaded)
          {
        var _ = print("go")
        var _ = print(libraryViewModel)
        loadingView
          .onAppear {
            Task {
              do {
               try await libraryViewModel.fetch()
              } catch AppleMusicError.networkError(let reason) {
                globalScreenManager.showErrorAlert = true
                globalScreenManager.errorMsg = reason
              } catch {
                globalScreenManager.showErrorAlert = true
                globalScreenManager.errorMsg = error.localizedDescription
              }

            }
          }
      } else {
        EmptyView()
      }
    }
    .scrollDismissesKeyboard(.immediately)
    .scrollContentBackground(.hidden)
  }

  //  var body: some View {
  //    VStack{
  //      if (songsLoading) {
  //        ProgressView()
  //      }
  //    }.task {
  //      do {
  //        songsLoading=true
  //        let results: [MusicKit.Song] = try await fetchLibrary()
  //        print(results)
  //      } catch AppleMusicError.networkError(let reason){
  //        globalScreenManager.showErrorAlert = true
  //        globalScreenManager.errorMsg = reason
  //      } catch {
  //        globalScreenManager.showErrorAlert = true
  //        globalScreenManager.errorMsg = error.localizedDescription
  //      }
  //      songsLoading=false
  //    }
  ////    SongList(songs: songs)
  //  }
}
