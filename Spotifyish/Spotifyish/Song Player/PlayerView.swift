import Foundation
import MediaPlayer
import MusicKit
import SwiftUI

//Sources
//https://medium.com/@jongary/binding-a-swiftui-slider-to-an-avplayers-time-a9660526170a
//https://medium.com/@tokusha.aa/mastering-swiftui-and-avplayer-integration-a-complete-guide-to-timecodes-and-advanced-playback-6ef9a88b3b8d

//https://www.kodeco.com/books/swiftui-cookbook/v1.0/chapters/2-understanding-observableobject-observedobject

let formatter = DateComponentsFormatter()

struct PlayerView: View {
  var song: MusicKit.Song
  var songIndex: Int?
  var playerQueue: [MusicKit.Song]? = []
  var startNew: Bool = false
  @EnvironmentObject var globalScreenManager: GlobalScreenManager
  @ObservedObject var audioPlayerViewModel = AudioPlayerViewModel.shared
  @ObservedObject var playerObserver = ApplicationMusicPlayerObserver()

  var body: some View {
    VStack(alignment: .center, spacing: 10) {
      Spacer()
      AsyncImage(
        url: playerObserver.song?.artwork?.url(width: 200, height: 200)
      )
      .frame(width: 200, height: 200)
      .foregroundStyle(.secondary)
      .padding(.leading, 20)
      .padding(.trailing, 10)

      if (playerObserver.songLoading) {
        ProgressView()
      }
      Spacer()
      Text(playerObserver.song?.title ?? "")
        .font(.title)
        .fontWeight(.bold)
        .lineLimit(nil)
        .multilineTextAlignment(.center)

      Text(playerObserver.song?.artistName ?? "")
        .font(.subheadline)

      HStack(spacing: 20) {
                AsyncButton(
                  systemImageName: "backward.fill",
                  action: audioPlayerViewModel.skipBackwards
                )
                .labelStyle(.iconOnly).imageScale(.large)

        AsyncButton(
          systemImageName: playerObserver.isPlaying
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
            value: $playerObserver.currentTime,
            in: (0...playerObserver.duration),
            onEditingChanged: { editing in
              if !editing {
                audioPlayerViewModel.isScrubbing = false
                audioPlayerViewModel.scrubTo(
                  newTime: playerObserver.currentTime
                )
              } else {
                audioPlayerViewModel.isScrubbing = true
              }
            }
          )
          Text(
            String(
              format: "%02d:%02d",
              ((Int)((playerObserver.currentTime))) / 60,
              ((Int)((playerObserver.currentTime))) % 60
            )
          ).font(.caption)
          Text("/")
          Text(
            String(
              format: "%02d:%02d",
              ((Int)((playerObserver.duration))) / 60,
              ((Int)((playerObserver.duration))) % 60
            )
          ).font(.caption)

        }.padding()

      }.padding()
        .onAppear {
          if startNew {
        
            print("LOAD NEW QUEUE AND SONG, \(playerQueue?.count ?? -1)")
            print("SONG INDEX:", songIndex)
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
