// NGOC
import SwiftUI

struct LikedController: View {
    @ObservedObject var viewModel: SongsViewModel
    @State var likedSongs: [Song] = []

    var body: some View {
        VStack {
            SongList(songs: $likedSongs)  // Display liked songs
                .onAppear {
                    loadLikedSongs()  // Load liked songs when the view appears
                    //print("Songs array in LikedController: \(viewModel.allsongs)")
                }
                .onChange(of: viewModel.allsongs) {
                    loadLikedSongs()
                    print("viewModel.allsongs change detected.")
                }
        }
    }

    func loadLikedSongs() {
        likedSongs = viewModel.allsongs.filter { song in song.liked }
    }
}
