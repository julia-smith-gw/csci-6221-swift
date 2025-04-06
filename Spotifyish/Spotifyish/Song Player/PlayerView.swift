import Foundation
import MediaPlayer
import MusicKit
import SwiftUI

//https://medium.com/@jongary/binding-a-swiftui-slider-to-an-avplayers-time-a9660526170a
//https://medium.com/@tokusha.aa/mastering-swiftui-and-avplayer-integration-a-complete-guide-to-timecodes-and-advanced-playback-6ef9a88b3b8d

//https://www.kodeco.com/books/swiftui-cookbook/v1.0/chapters/2-understanding-observableobject-observedobject

let formatter = DateComponentsFormatter()

struct PlayerView: View {
  var song: MusicKit.Song
  var songIndex: Int?
  var playerQueue: [MusicKit.Song]? = []
  var startNew: Bool = false
  @ObservedObject var audioPlayerViewModel = AudioPlayerViewModel.shared

  var body: some View {
    VStack(alignment: .center, spacing: 10) {
      Spacer()
      
      AsyncImage(url: audioPlayerViewModel.song?.artwork?.url(width: 200, height: 200)) { result in
          result.image?
              .resizable()
              .scaledToFill()
          }
          .frame(width: 200, height: 200)
          .foregroundStyle(.secondary)
      
      Spacer()
      Text(audioPlayerViewModel.song?.title ?? "")
        .font(.title)
        .fontWeight(.bold)
        .lineLimit(nil)
        .multilineTextAlignment(.center)

      Text(audioPlayerViewModel.song?.artistName ?? "")
        .font(.subheadline)

      HStack(spacing: 20) {
                AsyncButton(
                  systemImageName: "backward.fill",
                  action: audioPlayerViewModel.skipBackwards
                )
                .labelStyle(.iconOnly).imageScale(.large)

        AsyncButton(
          systemImageName: audioPlayerViewModel.isPlaying
            ? "pause.fill" : "play.fill",
          action: audioPlayerViewModel.playOrPause
        ).labelStyle(.iconOnly)
          .imageScale(.large)

                AsyncButton(
                  systemImageName: "forward.fill",
                  action: audioPlayerViewModel.skipForwards
                ).labelStyle(.iconOnly)
                  .imageScale(.large)
      }.padding(10)

      VStack {
        HStack {
          Slider(
            value: $audioPlayerViewModel.currentTime,
            in: (0...audioPlayerViewModel.duration),
            onEditingChanged: { editing in
              if !editing {
                audioPlayerViewModel.isScrubbing = false
                audioPlayerViewModel.scrubTo(
                  newTime: audioPlayerViewModel.currentTime
                )
              } else {
                audioPlayerViewModel.isScrubbing = true
              }
            }
          )
          Text(
            String(
              format: "%02d:%02d",
              ((Int)((audioPlayerViewModel.currentTime))) / 60,
              ((Int)((audioPlayerViewModel.currentTime))) % 60
            )
          ).font(.caption)
          Text("/")
          Text(
            String(
              format: "%02d:%02d",
              ((Int)((audioPlayerViewModel.duration))) / 60,
              ((Int)((audioPlayerViewModel.duration))) % 60
            )
          ).font(.caption)

        }.padding()

      }.padding()
        .onAppear {
          if startNew && (audioPlayerViewModel.song==nil || (audioPlayerViewModel.song != nil && (song.title != audioPlayerViewModel.song?.title && song.artistName != audioPlayerViewModel.song?.artistName))) {
      
            Task {
              //await audioPlayerViewModel.loadNewQueue(playlist: playerQueue ?? [])
              await audioPlayerViewModel.changeSong(
                song: song,
                songIndex: songIndex,
                playlist: playerQueue ?? []
              )
            }
          }
        }
      Spacer()
    }.frame(height: UIScreen.main.bounds.height)
      .alert(isPresented: $audioPlayerViewModel.showSongError) {
        Alert(title: Text("Error"), message: Text(audioPlayerViewModel.songError?.localizedDescription ?? "Unknown error"), dismissButton: .default(Text("OK")))
      }
  }
}
