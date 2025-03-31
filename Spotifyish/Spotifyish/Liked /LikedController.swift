// NGOC
import SwiftUI

struct LikedController: View {
    @ObservedObject var viewModel: SongsViewModel
    //@Binding var songs: [Song]
    //var songs: [Song]
    @State var likedSongs: [Song] = []

    var body: some View {
        VStack {
            SongList(songs: $likedSongs)  // Display liked songs
                .onAppear {
                    loadLikedSongs()  // Load liked songs when the view appears
                    print("Songs array in LikedController: \(viewModel.songs)")
                }
                .onChange(of: viewModel.songs) { _ in
                    loadLikedSongs()
                }
        }
    }

    func loadLikedSongs() {
        likedSongs = songs.filter { song in song.liked }
    }
}
