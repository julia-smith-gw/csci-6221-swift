// SHREEYA/JULIA
import SwiftUI

struct LibraryController: View {
    @ObservedObject var viewModel: SongsViewModel
    //var songs: [Song] = viewModel.songs
  // NOTE - In this section, I will create 3 functions related to the table2
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return songs.count // OR you can do songs.count
      
  }

  var body: some View {
      VStack {
          Text("Songs count: \(viewModel.songs.count)")     // debug
          SongList(songs: $viewModel.songs)
      }
      .onAppear {
          // Debugging: Print the songs array when the view appears
          print("Songs array in LibraryController: \(viewModel.songs)")
      }
  }

}
/*
struct LibraryController: View {
    @ObservedObject var viewModel: SongsViewModel

    var body: some View {
        SongList(songs: $viewModel.songs)  // Pass the binding to SongList
    }
}*/
