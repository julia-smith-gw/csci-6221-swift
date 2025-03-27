import SwiftUI

struct PlayerView: View {
  @StateObject var audioPlayerViewModel: AudioPlayerViewModel

  init(song: Song) {
    _audioPlayerViewModel = StateObject(wrappedValue:AudioPlayerViewModel(song: song))
  }

  var body: some View {
    VStack (alignment:.center, spacing: 10) {
      Image(audioPlayerViewModel.song.imageName)
        .resizable()
        .frame(width: 200, height: 200)
        .shadow(radius: 10)
    }

    Text(audioPlayerViewModel.song.name)
      .font(.title)
      .fontWeight(.bold)

    Text(audioPlayerViewModel.song.artistName)
      .font(.subheadline)

    HStack {
      Button("Scrub backwards", systemImage: "backward.fill", action: audioPlayerViewModel.skipBackwards)
          .labelStyle(.iconOnly)
          .tint(.pink)

      Button(action: {
        audioPlayerViewModel.playOrPause()
      }) {
        Image(systemName: audioPlayerViewModel.isPlaying ? "pause.fill" : "play.fill")
      }
      Button(action: {
        audioPlayerViewModel.skipForwards()
      }) {
        Image(systemName: "forward.fill")
      }
    }

  }

}
